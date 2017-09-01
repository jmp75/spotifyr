message_env_variables <- function() {
  msg <- "
            You may need to set your Spotify API credentials. You can do this by
            setting environment variables like so:

            export SPOTIFYR_CLIENT_ID='your-spotify-client-id'
            export SPOTIFYR_CLIENT_SECRET='your-spotify-client-secret'

            Get your credentials at     
                https://developer.spotify.com/my-applications
"
  message(msg)
}


#' Obtain a spotify context interactively
#' 
#' spotify_interactive_login opens a web browser, asks for your username+password,
#' performs the OAuth dance, retrieves the token, and uses it to create a spotify
#' context.
#'
#' Refer to \url{http://developer.spotify.com/guides/basics-of-authentication/}
#' 
#' @param client_id the spotify client ID
#'   
#' @param client_secret the spotify client secret
#'   
#' @param scopes the OAuth scopes you want to request
#'   
#' @param base_url the base URL for the spotify webpage. Change this in GitHub
#'   Enterprise deployments to your base G.E. URL
#'   
#' @param api_url the base URL for the spotify API. Change this in GitHub
#'   Enterprise deployments to your base G.E. API URL
#'   
#' @param max_etags the maximum number of entries to cache in the context
#'   
#' @param verbose logical, passed to \code{create_spotify_context} and,
#'   ultimately, to httr configuration
#'   
#' @return a spotify context object that is used in every spotify API call issued
#'   by this library.
spotify_interactive_login <- function(client_id = "",
                              client_secret = "",
                              scopes = NULL,
                              base_url = "https://spotify.com",
                              api_url = "https://api.spotify.com/v1",
                              max_etags = 10000,
                              verbose = FALSE,
                              appname="spotifyr")
{
  sp_token <- spotify_token(client_id, client_secret, scopes=scopes, appname=appname)
  create_spotify_context(api_url, client_id, client_secret, sp_token, verbose=verbose)
}


#' Gets an authentication token for the Spotify Web API
#' 
#' Gets an authentication token for the Spotify Web API. See https://developer.spotify.com/web-api/authorization-guide/.
#' 
#' @param client_id the client key for the application
#' @param client_secret the client secret for the application
#' @import httr
#' @import httpuv
#' @export
#' @return an httr authorisation token
spotify_token <- function(client_id="", client_secret="", scopes=NULL, appname="spotifyr") {
  # package constants, very unlikely to be changing
  # Note that we are likely to need further exception handling later on.
  s_endpoint <- httr::oauth_endpoint(
      authorize = "https://accounts.spotify.com/authorize",
      access = "https://accounts.spotify.com/api/token")

  if (client_id == "") client_id <- Sys.getenv("SPOTIFYR_CLIENT_ID")
  if (client_secret == "") client_secret <- Sys.getenv("SPOTIFYR_CLIENT_SECRET")

  if ((client_id == "") || (client_secret == "")) {
    message_env_variables()
  }

  if (client_id == "") stop("No spotify client key found")
  if (client_secret == "") stop("No spotify client secret found")
  myapp <- httr::oauth_app(appname, key = client_id, secret = client_secret)

  app_token <- httr::oauth2.0_token(s_endpoint, myapp, scope=scopes)
  token <- httr::config(token = app_token)
  return(token)
}

.state <- new.env(parent=emptyenv())
# for reference create_spotify_context is derived from spotify.R
create_spotify_context <- function(api_url = "https://api.spotify.com/v1/", client_id = NULL,
                                  client_secret = NULL, spotify_token = NULL,
                                  max_etags = 10000, verbose = FALSE)
{
  ctx <- list(api_url        = api_url,
              client_id      = client_id,
              client_secret  = client_secret,
            #   personal_token = personal_token,
              token          = spotify_token,
              max_etags      = max_etags,
              etags          = new.env(parent = emptyenv()),
              authenticated  = !is.null(spotify_token),
              verbose        = verbose)
  class(ctx) <- "spotifycontext"
  .state$ctx <- ctx
  ctx
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
  fields <- stringr::str_split(long_id, pattern = ":")[[1]]
  if (length(fields) >= 3) {
    if (type != fields[length(fields) - 1]) {
      warning(paste0("expected id of type ", type, " but found type ", fields[length(fields) - 1], " ", long_id, " "))
    }
    return(fields[length(fields)])
  }
  fields <- stringr::str_split(long_id, pattern = "/")[[1]]
  if (length(fields) >= 3) {
    itype = fields[length(fields) - 1]
    if (type != itype) {
      warning(paste0("expected id of type ", type, " but found type ", itype, " ", long_id, " "))
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
  return(paste0("spotify:", type, ":", retrieve_id(type, id)))
}

#' Builds a spotify URL
#' 
#' Builds a full spotify URL for use in web requests
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @return the spotify URL to use in a request
spot_url <- function(spot_ctx, url_postfix) {
  return(httr::modify_url(spot_ctx$api_url, path=url_postfix)) 
}

#' Make a GET request to the spotify API
#' 
#' Make a GET request to the spotify API
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @param ... TDB
#' @import httr
#' @return a list with class attribute 'response'
spot_get <- function(spot_ctx, url_postfix, ...) {
  gtoken <- spot_ctx$token
  url <- spot_url(spot_ctx, url_postfix)
  return(httr::GET(url, config = gtoken))
}

#' returns a single track given the track's ID, URI or URL
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param track_id - a spotify URI, URL or ID
#' @return a list with class attribute 'response'
#' @export
track <- function(spot_ctx, track_id) {
  trid <- retrieve_id("track", track_id)
  spot_get(spot_ctx, paste0("tracks/", trid))
}

#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' returns a list of tracks given a list of track IDs, URIs, or URLs
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param tracks - a list of spotify URIs, URLs or IDs
#' @param market - an ISO 3166-1 alpha-2 country code.
#' @return a list with class attribute 'response'
#' @export
tracks <- function(spot_ctx, tracks, market = as.character(NA)) {
  tlist <- sapply(tracks, retrieve_id, type = "track")
  track_ids <- paste(tlist, collapse = ",")
  # return spot_get(spot_ctx, 'tracks/?ids=' + ','.join(tlist), market = market)
  spot_get(spot_ctx, paste0("tracks/?ids=", track_ids))
}

#' returns a single artist given the artist's ID, URI or URL
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param artist_id - an artist ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
artist <- function(spot_ctx, artist_id) {
  aid <- retrieve_id("artist", artist_id)
  spot_get(spot_ctx, paste0("artists/", aid))
}

#' returns a list of artists given the artist IDs, URIs, or URLs
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param artists - a list of  artist IDs, URIs or URLs
#' @return a list with class attribute 'response'
#' @export
artists <- function(spot_ctx, artists) {
  tlist <- sapply(tracks, retrieve_id, type = "artist")
  track_ids <- paste(tlist, collapse = ",")
  spot_get(spot_ctx, paste0("artists/?ids=", track_ids))
}

#' Get Spotify catalog information about an artist's albums
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @param album_type - 'album', 'single', 'appears_on', 'compilation'
#' @param country - limit the response to one particular country.
#' @param limit  - the number of albums to return
#' @param offset - the index of the first album to return
#' @return a list with class attribute 'response'
#' @export
artist_albums <- function(spot_ctx, artist_id, album_type = NA, country = NA, limit = 20, offset = 0) {
  trid <- retrieve_id("artist", artist_id)
  spot_get(spot_ctx, paste0("artists/", trid, "/albums"), album_type = album_type, country = country, limit = limit, offset = offset)
}

#' Get Spotify catalog information about an artist's top 10 tracks by country.
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @param country - limit the response to one particular country.
#' @return a list with class attribute 'response'
#' @export
artist_top_tracks <- function(spot_ctx, artist_id, country = "US") {
  trid <- retrieve_id("artist", artist_id)
  spot_get(spot_ctx, paste0("artists/", trid, "/top-tracks"), country = country)
}

#' Get Spotify catalog information about artists similar to an identified artist.
#' 
#' Get Spotify catalog information about artists similar to an identified artist. Similarity is based on analysis of the Spotify community's listening history.
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param artist_id - the artist ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
artist_related_artists <- function(spot_ctx, artist_id) {
  trid <- retrieve_id("artist", artist_id)
  spot_get(spot_ctx, paste0("artists/", trid, "/related-artists"))
}

#' returns a single album given the album's ID, URIs or URL
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param album_id - the album ID, URI or URL
#' @return a list with class attribute 'response'
#' @export
album <- function(spot_ctx, album_id) {
  trid <- retrieve_id("album", album_id)
  spot_get(spot_ctx, paste0("albums/", trid))
}

#' Get Spotify catalog information about an album's tracks
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param album_id - the album ID, URI or URL
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
album_tracks <- function(spot_ctx, album_id, limit = 50, offset = 0) {
  trid <- retrieve_id("album", album_id)
  spot_get(spot_ctx, paste0("albums/", trid, "/tracks/"), limit = limit, offset = offset)
}

#' returns a list of albums given the album IDs, URIs, or URLs
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param albums - a list of  album IDs, URIs or URLs
#' @return a list with class attribute 'response'
#' @export
albums <- function(spot_ctx, albums) {
  tlist <- sapply(albums, retrieve_id, type = "album")
  album_ids <- paste(tlist, collapse = ",")
  spot_get(spot_ctx, paste0("albums/?ids=", album_ids))
}

#' searches for an item
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param q - the search query
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @param type - the type of item to return. One of 'artist', 'album',
# 'track' or 'playlist'
#' @param market - An ISO 3166-1 alpha-2 country code or the string from_token.
#' @return a list with class attribute 'response'
#' @export
search <- function(spot_ctx, q, limit = 10, offset = 0, type = "track", market = NA) {
  spot_get(spot_ctx, "search", q = q, limit = limit, offset = offset, type = type, market = market)
}

#' Gets basic profile information about a Spotify User
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param user - the id of the usr
#' @return a list with class attribute 'response'
#' @export
user <- function(spot_ctx, user) {
  spot_get(spot_ctx, "users/" + user)
}

#' Get current user playlists without required getting his profile
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
current_user_playlists <- function(spot_ctx, limit = 50, offset = 0) {
  spot_get(spot_ctx, "me/playlists", limit = limit, offset = offset)
}

#' Gets playlists of a user
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param user - the id of the usr
#' @param limit  - the number of items to return
#' @param offset - the index of the first item to return
#' @return a list with class attribute 'response'
#' @export
user_playlists <- function(spot_ctx, user, limit = 50, offset = 0) {
  spot_get(spot_ctx, paste0("users/", user, "/playlists"), limit = limit, offset = offset)
}

#' Gets playlist of a user
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param user - the id of the user
#' @param playlist_id - the id of the playlist
#' @param fields - which fields to return
#' @return a list with class attribute 'response'
#' @export
user_playlist <- function(spot_ctx, user, playlist_id = NA, fields = NA) {
  if (is.na(playlist_id)) {
    spot_get(spot_ctx, paste0("users/", user, "/starred"), fields = fields)
  }
  plid <- retrieve_id("playlist", playlist_id)
  spot_get(spot_ctx, paste0("users/", user, "/playlists/", plid), fields = fields)
}

