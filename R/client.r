#' 
# Create a Spotify API object.
# :param auth: An authorization token (optional)
# :param requests_session:
#     A Requests session object or a truthy value to create one.
#     A falsy value disables sessions.
#     It should generally be a good idea to keep sessions enabled
#     for performance reasons (connection pooling).
# :param client_credentials_manager:
#     SpotifyClientCredentials object
# :param proxies:
#     Definition of proxies (optional)
# :param requests_timeout:
#     Tell Requests to stop waiting for a response after a given number of seconds
#' 
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

auth_headers <- function(spot_cnx) {
    if (!is.na(spot_cnx$auth)) {
        token = spot_cnx$auth
    } else if (!is.na(spot_cnx$client_credentials_manager)) {
        token = spot_cnx$client_credentials_manager.get_access_token()
    } else {
        return(NULL)
    }
    return(httr::add_headers(Authorization = paste0('Bearer ', token)))
}

retrieve_id <- function(type, id) {
  fields <- stringr::str_split(id, pattern=':')[[1]]
  if (length(fields) >= 3) { 
    if (type != fields[length(fields) - 1]) {
      warning(paste0('expected id of type ', type, ' but found type ', fields[length(fields) - 1], ' ', id, ' '))
    }
    return(fields[length(fields)])
  }
  fields <- stringr::str_split(id, pattern = '/')[[1]]
  if (length(fields) >= 3) {
    itype = fields[length(fields) - 1]
    if (type != itype) {
      warning(paste0('expected id of type ', type, ' but found type ', itype, ' ', id, ' '))
    }
    return(fields[length(fields)])
  }
  return(id)
}

make_uri <- function(type, id) {
  return(paste0('spotify:' , type , ":" , retrieve_id(type, id)))
}

# Not sure we will need all this - duplicates httr's functionalities?
internal_call <- function(spot_cnx, method, url, payload, params) {
#     args = dict(params=params)
#     args["timeout"] = self.requests_timeout
#     if not url.startswith('http') {
#         url = self.prefix + url
#     headers = self.auth_headers()
#     headers['Content-Type'] = 'application/json'

#     if payload:
#         args["data"] = json.dumps(payload)

#     if self.trace_out:
#         print(url)
#     r = self._session.request(method, url, headers=headers, proxies=self.proxies, **args)

#     if self.trace:  # pragma: no cover
#         print()
#         print ('headers', headers)
#         print ('http status', r.status_code)
#         print(method, r.url)
#         if payload:
#             print("DATA", json.dumps(payload))

#     try:
#         r.raise_for_status()
#     except:
#         if r.text and len(r.text) > 0 and r.text != 'null':
#             raise SpotifyException(r.status_code,
#                 -1, '%s:\n %s' % (r.url, r.json()['error']['message']),
#                 headers=r.headers)
#         else:
#             raise SpotifyException(r.status_code,
#                 -1, '%s:\n %s' % (r.url, 'error'), headers=r.headers)
#     finally:
#         r.connection.close()
#     if r.text and len(r.text) > 0 and r.text != 'null':
#         results = r.json()
#         if self.trace:  # pragma: no cover
#             print('RESP', results)
#             print()
#         return results
#     else:
#         return None
}

# _post <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('POST', url, payload, kwargs)

# _delete <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('DELETE', url, payload, kwargs)

# _put <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('PUT', url, payload, kwargs)

#next <- function(spot_cnx, result) {
    ##' returns the next result given a paged result

    ##' 
    ##' @param result - a previously returned paged result
    ##' 
    #if result['next']:
        #return spot_get(spot_cnx, result['next'])
    #else:
        #return None
#}

#previous <- function(spot_cnx, result) {
    ##' returns the previous result given a paged result

    ##' 
    ##' @param result - a previously returned paged result
    ##' 
    #if result['previous']:
        #return spot_get(spot_cnx, result['previous'])
    #else:
        #return None
#}

#warn_old <- function(spot_cnx, msg) {
    #print('warning:' + msg, file=sys.stderr)
#}

#spot_warn <- function(spot_cnx, msg, *args) {
    #print('warning:' + msg.format(*args), file=sys.stderr)
#}

spot_url <- function(spot_cnx, url_postfix) {
  spot_cnx$prefix
  return(paste(spot_cnx$prefix, url_postfix, sep = '')) # if prefix ends in /
}

spot_get <- function(spot_cnx, url_postfix) {
  gtoken <- spot_cnx$auth
  url <- spot_url(spot_cnx, url_postfix)
  return(httr::GET(url, config = gtoken))
}

#' returns a single track given the track's ID, URI or URL

#' 
#' @param track_id - a spotify URI, URL or ID
#' 
track <- function(spot_cnx, track_id) {
  trid <- retrieve_id( 'track', track_id)
  spot_get(spot_cnx, paste0('tracks/', trid))
}

#########################################

#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' @param tracks - a list of spotify URIs, URLs or IDs
#' @param market - an ISO 3166-1 alpha-2 country code.
#' 
tracks <- function(spot_cnx, tracks, market = as.character(NA)) {
  tlist <- sapply(tracks, retrieve_id, type = 'track')
  track_ids <- paste(tlist, collapse = ',')
  #return spot_get(spot_cnx, 'tracks/?ids=' + ','.join(tlist), market = market)
  spot_get(spot_cnx, paste0('tracks/?ids=', track_ids))
}

#' returns a single artist given the artist's ID, URI or URL
#' 
#' @param artist_id - an artist ID, URI or URL
#' 
artist <- function(spot_cnx, artist_id) {
  aid <- retrieve_id('artist', artist_id)
  spot_get(spot_cnx, paste0('artists/', aid))
}

#' returns a list of artists given the artist IDs, URIs, or URLs
#' 
#' @param artists - a list of  artist IDs, URIs or URLs
#' 
artists <- function(spot_cnx, artists) {
  tlist <- sapply(tracks, retrieve_id, type = 'artist')
  track_ids <- paste(tlist, collapse = ',')
  spot_get(spot_cnx, paste0('artists/?ids=', track_ids))
}

#' Get Spotify catalog information about an artist's albums

#' 
#' @param artist_id - the artist ID, URI or URL
#' @param album_type - 'album', 'single', 'appears_on', 'compilation'
#' @param country - limit the response to one particular country.
#' @param limit  - the number of albums to return
#' @param offset - the index of the first album to return
#' 
artist_albums <- function(spot_cnx, artist_id, album_type=NA, country=NA, limit=20, offset=0) {
  trid <- retrieve_id('artist', artist_id)
  spot_get(spot_cnx, paste0('artists/', trid, '/albums'), album_type = album_type,
                        country = country, limit = limit, offset = offset)
}

#' Get Spotify catalog information about an artist's top 10 tracks by country.
#' 
#' @param artist_id - the artist ID, URI or URL
#' @param country - limit the response to one particular country.
#' 
artist_top_tracks <- function(spot_cnx, artist_id, country='US') {
    trid <- retrieve_id( 'artist', artist_id)
  spot_get(spot_cnx, paste0('artists/' , trid , '/top-tracks'), country=country)
}

#' Get Spotify catalog information about artists similar to an identified artist.
#' 
#' Get Spotify catalog information about artists similar to an identified artist. Similarity is based on analysis of the Spotify community's listening history.
#' 
#' @param artist_id - the artist ID, URI or URL
#' 
artist_related_artists <- function(spot_cnx, artist_id) {
    trid <- retrieve_id( 'artist', artist_id)
  spot_get(spot_cnx, paste0('artists/' , trid , '/related-artists'))
}

#' returns a single album given the album's ID, URIs or URL
#' 
#' @param album_id - the album ID, URI or URL
#' 
album <- function(spot_cnx, album_id) {
  trid <- retrieve_id( 'album', album_id)
  spot_get(spot_cnx, paste0('albums/', trid))
}

#' Get Spotify catalog information about an album's tracks
#' 
#' @param album_id - the album ID, URI or URL
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' 
album_tracks <- function(spot_cnx, album_id, limit=50, offset=0) {
  trid <- retrieve_id( 'album', album_id)
  spot_get(spot_cnx, paste0('albums/', trid, '/tracks/'), limit=limit,
                        offset=offset)
}

#' returns a list of albums given the album IDs, URIs, or URLs
#' 
#' @param albums - a list of  album IDs, URIs or URLs
#' 
albums <- function(spot_cnx, albums) {
  tlist <- sapply(albums, retrieve_id, type = 'album')
  album_ids <- paste(tlist, collapse = ',')
  spot_get(spot_cnx, paste0('albums/?ids=', album_ids))
}

#' searches for an item
#' 
#' @param q - the search query
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @param type - the type of item to return. One of 'artist', 'album',
    #                  'track' or 'playlist'
#' @param market - An ISO 3166-1 alpha-2 country code or the string from_token.
#' 
search <- function(spot_cnx, q, limit=10, offset=0, type='track', market=NA) {
  spot_get(spot_cnx, 'search', q=q, limit=limit, offset=offset, type=type, market=market)
}

#' Gets basic profile information about a Spotify User
#' 
#' @param user - the id of the usr
#' 
user <- function(spot_cnx, user) {
  spot_get(spot_cnx, 'users/' + user)
}

#' Get current user playlists without required getting his profile
#' 
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
  #'
current_user_playlists <- function(spot_cnx, limit=50, offset=0) {
  spot_get(spot_cnx, "me/playlists", limit=limit, offset=offset)
}

#' Gets playlists of a user

#' 
#' @param user - the id of the usr
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' 
user_playlists <- function(spot_cnx, user, limit=50, offset=0) {
  spot_get(spot_cnx, paste0("users/",user,"/playlists"), limit=limit, offset=offset)
}

#' Gets playlist of a user
#' 
#' @param user - the id of the user
#' @param playlist_id - the id of the playlist
#' @param fields - which fields to return
#' 
user_playlist <- function(spot_cnx, user, playlist_id = NA, fields = NA) {
  if (is.na(playlist_id)) {
    spot_get(spot_cnx, paste0("users/", user, "/starred"), fields = fields)
  }
  plid <- retrieve_id('playlist', playlist_id)
  spot_get(spot_cnx, paste0("users/", user, "/playlists/", plid), fields = fields)
}

