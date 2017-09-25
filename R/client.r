
album_id_type <- "album"
track_id_type <- "track"
artist_id_type <- "artist"
playlist_id_type <- "playlist"

check_id_arg <- function(ids, expected_length=NA_integer_) {
  stopifnot(is.character(ids))
  if(length(ids)==0) {stop("there must be at least one identifier or type specified")}
  if(!is.na(expected_length)) {
    if(length(ids) != expected_length) stop(paste0("expected a character vector of length ", expected_length))
  }
}

#' Get one or more album
#' 
#' Retrieve album(s) given the ID, URIs or URL of these album(s)
#' 
#' @param ids - album(s) ID, URI or URL
#' @param market - optional, not used yet - ISO 3166-1 alpha-2 country code. 
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @return a list 
#' @export
albums <- function(ids, spot_ctx=NULL, market=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(ids)
  query <- create_query_parameters(market=market)
  if(length(ids)==1) {
    i_get_albums_id(spot_ctx, ids, album_id_type, query=query)
  } else {
    i_get_albums_ids(spot_ctx, ids, album_id_type, query=query)
  }
}

#' Get one or more track
#' 
#' Retrieve track(s) given the ID, URIs or URL of these track(s)
#' 
#' @param ids - track(s) ID, URI or URL
#' @param market - optional, not used yet - ISO 3166-1 alpha-2 country code. 
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @return a list 
#' @export
tracks <- function(ids, spot_ctx=NULL, market=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(ids)
  query <- create_query_parameters(market=market)
  if(length(ids)==1) {
    i_get_tracks_id(spot_ctx, ids, track_id_type, query=query)
  } else {
    i_get_tracks_ids(spot_ctx, ids, track_id_type, query=query)
  }
}

#' Get one or more artist
#' 
#' Retrieve artist(s) given the ID, URIs or URL of these artist(s)
#' 
#' @param ids - artist(s) ID, URI or URL
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @return a list 
#' @export
artists <- function(ids, spot_ctx=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(ids)
  if(length(ids)==1) {
    i_get_artists_id(spot_ctx, ids, artist_id_type)
  } else {
    i_get_artists_ids(spot_ctx, ids, artist_id_type)
  }
}

#' Get tracks of an album
#' 
#' Retrieve the tracks of an album given the ID, URIs or URL of this album
#' 
#' @param id - album ID, URI or URL
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @param market - optional, not used yet - ISO 3166-1 alpha-2 country code. 
#' @param limit Default: 20. Minimum: 1. Maximum: 50.
#' @param offset first index
#' @return a list 
#' @export
album_tracks <- function(id, spot_ctx=NULL, market=NULL, limit=NULL, offset=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(id, 1)
  query <- create_query_parameters(market=market, limit=limit, offset=offset)
  i_get_albums_id_tracks(spot_ctx, id, album_id_type, query=query)
}

#' Get tracks of an album
#' 
#' Retrieve the albums of an artist given the ID, URIs or URL of this artist. https://developer.spotify.com/web-api/get-artists-albums/
#' 
#' @param id - artist ID, URI or URL
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @param album_type character vector, one or more of: album    single    appears_on    compilation
#' @param market - optional, not used yet - ISO 3166-1 alpha-2 country code. 
#' @param limit Default: 20. Minimum: 1. Maximum: 50.
#' @param offset first index
#' @return a list 
#' @export
artist_albums <- function(id, spot_ctx=NULL, album_type=NULL, market=NULL, limit=NULL, offset=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(id, 1)
  query <- create_query_parameters(album_type=album_type, market=market, limit=limit, offset=offset)
  i_get_artists_id_albums(spot_ctx, id, album_id_type, query=query)
}


#' Get a detailed audio analysis for a single track 
#' 
#' Get a detailed audio analysis for a single track 
#' 
#' @param id - track ID, URI or URL
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @return a list 
#' @export
audio_analysis <- function(id, spot_ctx=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(id, 1)
  i_get_audio_analysis_id(spot_ctx, id, track_id_type, query=NULL)
}

#' Get audio features for a one or more tracks
#' 
#' Get audio features for a one or more tracks
#' 
#' @param ids - artist(s) ID, URI or URL
#' @param spot_ctx optional Spotify connexion context. If not provided the cached package context is used.
#' @return a list 
#' @export
audio_features <- function(ids, spot_ctx=NULL) {
  spot_ctx <- get_spotify_context(spot_ctx)
  check_id_arg(ids)
  if(length(ids)==1) {
    i_get_audio_features_id(spot_ctx, ids, artist_id_type)
  } else {
    i_get_audio_features_ids(spot_ctx, ids, artist_id_type)
  }
}


