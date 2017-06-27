#' Create a Spotify API object.
#' 
#' @param auth An authorization token (optional)
#' @param requests_session
#'     A Requests session object or a truthy value to create one.
#'     A falsy value disables sessions.
#'     It should generally be a good idea to keep sessions enabled
#'     for performance reasons (connection pooling).
#' @param client_credentials_manager
#'     SpotifyClientCredentials object
#' @param proxies
#'     Definition of proxies (optional)
#' @param requests_timeout
#'     Tell Requests to stop waiting for a response after a given number of seconds
#' @return a list with the essential Spotify API connection settings
create_spotify_object <- function(auth=NA, requests_session=TRUE,
        client_credentials_manager=NA, proxies=NA, requests_timeout=NA) {
    obj <- list()
    obj$trace = FALSE  # Enable tracing?
    obj$trace_out = FALSE
    obj$max_get_retries = 10

    obj$prefix = 'https://api.spotify.com/v1/'
    obj$auth = auth
    obj$client_credentials_manager = client_credentials_manager
    obj$proxies = proxies
    obj$requests_timeout = requests_timeout

    # if isinstance(requests_session, requests.Session) {
    #     self._session = requests_session
    # else:
    #     if requests_session:  # Build a new session.
    #         self._session = requests.Session()
    #     else:  # Use the Requests API module as a "session".
    #         from requests import api
    #         self._session = api
    return(obj)
}

#' Retrieve the ID part of the URI
#' 
#' Retrieve the ID part of a URI (spotify:track:AAABBBCCC333) or a URL (http://blah.com/track/AAABBBCCC333)
#' 
#' @param type the expected type for this id, which may be in the long ID form as penultimate entry before the ID
#' @param long_id - a spotify URI, URL or ID
#' @import stringr
#' @return the short ID
retrieve_id <- function(type, long_id) {
  fields <- stringr::str_split(long_id, pattern=':')[[1]]
  if (length(fields) >= 3) { 
    if (type != fields[length(fields) - 1]) {
      warning(paste0('expected id of type ', type, ' but found type ', fields[length(fields) - 1], ' ', long_id, ' '))
    }
    return(fields[length(fields)])
  }
  fields <- stringr::str_split(long_id, pattern = '/')[[1]]
  if (length(fields) >= 3) {
    itype = fields[length(fields) - 1]
    if (type != itype) {
      warning(paste0('expected id of type ', type, ' but found type ', itype, ' ', long_id, ' '))
    }
    return(fields[length(fields)])
  }
  return(long_id)
}

#' Builds a spotify URI
#' 
#' Builds a spotify URI from a short ID and the type of the ID, e.g. 'track'
#' 
#' @param type the expected type for this id, which may be in the 
#' @param id - a spotify ID
#' @return the spotify URI
make_uri <- function(type, id) {
  return(paste0('spotify:' , type , ":" , retrieve_id(type, id)))
}

#' Builds a spotify URL
#' 
#' Builds a full spotify URL for use in web requests
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @return the spotify URL to use in a request
spot_url <- function(spot_cnx, url_postfix) {
  spot_cnx$prefix
  return(paste(spot_cnx$prefix, url_postfix, sep = '')) # if prefix ends in /
}

#' Make a GET request to the spotify API
#' 
#' Make a GET request to the spotify API
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @param ... TDB
#' @import httr
#' @return a list with class attribute 'response'
spot_get <- function(spot_cnx, url_postfix, ...) {
  gtoken <- spot_cnx$auth
  url <- spot_url(spot_cnx, url_postfix)
  return(httr::GET(url, config = gtoken))
}

#' returns a single track given the track's ID, URI or URL
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param track_id - a spotify URI, URL or ID
#' @return a list with class attribute 'response'
#' @export
track <- function(spot_cnx, track_id) {
  trid <- retrieve_id( 'track', track_id)
  spot_get(spot_cnx, paste0('tracks/', trid))
}

#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param tracks - a list of spotify URIs, URLs or IDs
#' @param market - an ISO 3166-1 alpha-2 country code.
#' @return a list with class attribute 'response'
#' @export
tracks <- function(spot_cnx, tracks, market = as.character(NA)) {
  tlist <- sapply(tracks, retrieve_id, type = 'track')
  track_ids <- paste(tlist, collapse = ',')
  #return spot_get(spot_cnx, 'tracks/?ids=' + ','.join(tlist), market = market)
  spot_get(spot_cnx, paste0('tracks/?ids=', track_ids))
}

#' returns a single artist given the artist's ID, URI or URL
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param artist_id - an artist ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
artist <- function(spot_cnx, artist_id) {
  aid <- retrieve_id('artist', artist_id)
  spot_get(spot_cnx, paste0('artists/', aid))
}

#' returns a list of artists given the artist IDs, URIs, or URLs
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param artists - a list of  artist IDs, URIs or URLs
#' @return a list with class attribute 'response'
#' @export
artists <- function(spot_cnx, artists) {
  tlist <- sapply(tracks, retrieve_id, type = 'artist')
  track_ids <- paste(tlist, collapse = ',')
  spot_get(spot_cnx, paste0('artists/?ids=', track_ids))
}

#' Get Spotify catalog information about an artist's albums
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @param album_type - 'album', 'single', 'appears_on', 'compilation'
#' @param country - limit the response to one particular country.
#' @param limit  - the number of albums to return
#' @param offset - the index of the first album to return
#' @return a list with class attribute 'response'
#' @export
artist_albums <- function(spot_cnx, artist_id, album_type=NA, country=NA, limit=20, offset=0) {
  trid <- retrieve_id('artist', artist_id)
  spot_get(spot_cnx, paste0('artists/', trid, '/albums'), album_type = album_type,
                        country = country, limit = limit, offset = offset)
}

#' Get Spotify catalog information about an artist's top 10 tracks by country.
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @param country - limit the response to one particular country.
#' @return a list with class attribute 'response'
#' @export
artist_top_tracks <- function(spot_cnx, artist_id, country='US') {
    trid <- retrieve_id( 'artist', artist_id)
  spot_get(spot_cnx, paste0('artists/' , trid , '/top-tracks'), country=country)
}

#' Get Spotify catalog information about artists similar to an identified artist.
#' 
#' Get Spotify catalog information about artists similar to an identified artist. Similarity is based on analysis of the Spotify community's listening history.
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
artist_related_artists <- function(spot_cnx, artist_id) {
    trid <- retrieve_id( 'artist', artist_id)
  spot_get(spot_cnx, paste0('artists/' , trid , '/related-artists'))
}

#' returns a single album given the album's ID, URIs or URL
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param album_id - the album ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
album <- function(spot_cnx, album_id) {
  trid <- retrieve_id( 'album', album_id)
  spot_get(spot_cnx, paste0('albums/', trid))
}

#' Get Spotify catalog information about an album's tracks
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param album_id - the album ID, URI or URL
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
album_tracks <- function(spot_cnx, album_id, limit=50, offset=0) {
  trid <- retrieve_id( 'album', album_id)
  spot_get(spot_cnx, paste0('albums/', trid, '/tracks/'), limit=limit,
                        offset=offset)
}

#' returns a list of albums given the album IDs, URIs, or URLs
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param albums - a list of  album IDs, URIs or URLs
#' @return a list with class attribute 'response'
#' @export
albums <- function(spot_cnx, albums) {
  tlist <- sapply(albums, retrieve_id, type = 'album')
  album_ids <- paste(tlist, collapse = ',')
  spot_get(spot_cnx, paste0('albums/?ids=', album_ids))
}

#' searches for an item
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param q - the search query
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @param type - the type of item to return. One of 'artist', 'album',
    #                  'track' or 'playlist'
#' @param market - An ISO 3166-1 alpha-2 country code or the string from_token.
#' @return a list with class attribute 'response'
#' @export
search <- function(spot_cnx, q, limit=10, offset=0, type='track', market=NA) {
  spot_get(spot_cnx, 'search', q=q, limit=limit, offset=offset, type=type, market=market)
}

#' Gets basic profile information about a Spotify User
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param user - the id of the usr
#' @return a list with class attribute 'response'
#' @export
user <- function(spot_cnx, user) {
  spot_get(spot_cnx, 'users/' + user)
}

#' Get current user playlists without required getting his profile
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
current_user_playlists <- function(spot_cnx, limit=50, offset=0) {
  spot_get(spot_cnx, "me/playlists", limit=limit, offset=offset)
}

#' Gets playlists of a user
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param user - the id of the usr
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
user_playlists <- function(spot_cnx, user, limit=50, offset=0) {
  spot_get(spot_cnx, paste0("users/",user,"/playlists"), limit=limit, offset=offset)
}

#' Gets playlist of a user
#' 
#' @param spot_cnx - a list with the essential Spotify API connection settings
#' @param user - the id of the user
#' @param playlist_id - the id of the playlist
#' @param fields - which fields to return
#' @return a list with class attribute 'response'
#' @export
user_playlist <- function(spot_cnx, user, playlist_id = NA, fields = NA) {
  if (is.na(playlist_id)) {
    spot_get(spot_cnx, paste0("users/", user, "/starred"), fields = fields)
  }
  plid <- retrieve_id('playlist', playlist_id)
  spot_get(spot_cnx, paste0("users/", user, "/playlists/", plid), fields = fields)
}

