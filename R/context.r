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
#' @param appname application name
#'   
#' @return a spotify context object that is used in every spotify API call issued
#'   by this library.
#' @export
spotify_interactive_login <- function(client_id = "",
                              client_secret = "",
                              scopes = NULL,
                              base_url = "https://spotify.com",
                              api_url = "https://api.spotify.com",
                              max_etags = 10000,
                              verbose = FALSE,
                              appname="spotifyr")
{
  sp_token <- spotify_token(client_id, client_secret, scopes=scopes, appname=appname)
  create_spotify_context(api_url, client_id, client_secret, sp_token, verbose=verbose)
}


#' Create a spotify context using a cached token
#' 
#' Create a spotify context using a cached token. This is likely of use only for vignette building
#' 
#' @param cached_token cached oauth2 token 
#'   
#' @param api_url the base URL for the spotify API. Change this in GitHub
#'   Enterprise deployments to your base G.E. API URL
#'   
#' @param verbose logical, passed to \code{create_spotify_context} and,
#'   ultimately, to httr configuration
#'   
#' @return a spotify context object that is used in every spotify API call issued
#'   by this library.
#' @export
spotify_background_login <- function(
                              cached_token,
                              api_url = "https://api.spotify.com",
                              verbose = FALSE)
{
  stop("not yet implemented - GET method fail with failed authentication")
  if(is.character(cached_token)) {
    stopifnot(file.exists(cached_token))
    sp_token <- readRDS(cached_token)
  } else if ("Token2.0" %in% class(cached_token)) {
    sp_token <- cached_token
  }
  class(sp_token) <- 'config'
  create_spotify_context(api_url, "", "", sp_token, verbose=verbose)
}


#' Gets an authentication token for the Spotify Web API
#' 
#' Gets an authentication token for the Spotify Web API. See #' Refer to \url{https://developer.spotify.com/web-api/authorization-guide/}
#' 
#' @param client_id the client key for the application
#' @param client_secret the client secret for the application
#' @param scopes the OAuth scopes you want to request
#' @param appname application name
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

# for reference and credits, create_spotify_context is derived from 
# https://github.com/cscheid/rgithub/blob/master/R/github.R
create_spotify_context <- function(api_url = "https://api.spotify.com/", client_id = NULL,
                                  client_secret = NULL, spotify_token = NULL,
                                  max_etags = 10000, verbose = FALSE, cache=TRUE)
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
  if(cache) { .state$ctx <- ctx }
  ctx
}

get_spotify_context <- function(ctx=NULL) {
  if(is.null(ctx)){
    .state$ctx
  } else {
    ctx
  }
}