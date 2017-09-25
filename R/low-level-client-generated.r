#####################################
# THIS FILE IS GENERATED - DO NOT MODIFY
#####################################

#' i_get_albums_id
#' 
#' i_get_albums_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_albums_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("albums", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_albums_ids
#' 
#' i_get_albums_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_albums_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("albums?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_albums_id_tracks
#' 
#' i_get_albums_id_tracks
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_albums_id_tracks <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("albums", retrieve_id(id, id_type), "tracks"), query=query) %>% json_parse
}

#' i_get_artists_id
#' 
#' i_get_artists_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_artists_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("artists", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_artists_ids
#' 
#' i_get_artists_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_artists_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("artists?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_artists_id_albums
#' 
#' i_get_artists_id_albums
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_artists_id_albums <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("artists", retrieve_id(id, id_type), "albums"), query=query) %>% json_parse
}

#' i_get_artists_id_top_tracks
#' 
#' i_get_artists_id_top_tracks
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_artists_id_top_tracks <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("artists", retrieve_id(id, id_type), "top-tracks"), query=query) %>% json_parse
}

#' i_get_artists_id_related_artists
#' 
#' i_get_artists_id_related_artists
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_artists_id_related_artists <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("artists", retrieve_id(id, id_type), "related-artists"), query=query) %>% json_parse
}

#' i_get_audio_analysis_id
#' 
#' i_get_audio_analysis_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_audio_analysis_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("audio-analysis", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_audio_features_id
#' 
#' i_get_audio_features_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_audio_features_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("audio-features", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_audio_features_ids
#' 
#' i_get_audio_features_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_audio_features_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("audio-features?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_browse_featured_playlists
#' 
#' i_get_browse_featured_playlists
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_browse_featured_playlists <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("browse", "featured-playlists"), query=query) %>% json_parse
}

#' i_get_browse_new_releases
#' 
#' i_get_browse_new_releases
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_browse_new_releases <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("browse", "new-releases"), query=query) %>% json_parse
}

#' i_get_browse_categories
#' 
#' i_get_browse_categories
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_browse_categories <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("browse", "categories"), query=query) %>% json_parse
}

#' i_get_browse_categories_id
#' 
#' i_get_browse_categories_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_browse_categories_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("browse", "categories", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_browse_categories_id_playlists
#' 
#' i_get_browse_categories_id_playlists
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_browse_categories_id_playlists <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("browse", "categories", retrieve_id(id, id_type), "playlists"), query=query) %>% json_parse
}

#' i_get_me
#' 
#' i_get_me
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me"), query=query) %>% json_parse
}

#' i_get_me_following
#' 
#' i_get_me_following
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_following <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "following"), query=query) %>% json_parse
}

#' i_get_me_following_contains
#' 
#' i_get_me_following_contains
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_following_contains <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "following", "contains"), query=query) %>% json_parse
}

#' i_get_me_tracks
#' 
#' i_get_me_tracks
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_tracks <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "tracks"), query=query) %>% json_parse
}

#' i_get_me_tracks_contains_ids
#' 
#' i_get_me_tracks_contains_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_me_tracks_contains_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "tracks", "contains?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_me_albums
#' 
#' i_get_me_albums
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_albums <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "albums"), query=query) %>% json_parse
}

#' i_get_me_albums_contains_ids
#' 
#' i_get_me_albums_contains_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_me_albums_contains_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "albums", "contains?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_me_top_type
#' 
#' i_get_me_top_type
#' 
#' @param  spot_ctx spot_ctx
#' @param  type type
#' @param  query query
#' @return a list
#' @export
i_get_me_top_type <- function(spot_ctx, type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "top", check_type(type)), query=query) %>% json_parse
}

#' i_get_recommendations
#' 
#' i_get_recommendations
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_recommendations <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("recommendations"), query=query) %>% json_parse
}

#' i_get_search_type_album
#' 
#' i_get_search_type_album
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_search_type_album <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("search?type=", "album"), query=query) %>% json_parse
}

#' i_get_search_type_artist
#' 
#' i_get_search_type_artist
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_search_type_artist <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("search?type=", "artist"), query=query) %>% json_parse
}

#' i_get_search_type_playlist
#' 
#' i_get_search_type_playlist
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_search_type_playlist <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("search?type=", "playlist"), query=query) %>% json_parse
}

#' i_get_search_type_track
#' 
#' i_get_search_type_track
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_search_type_track <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("search?type=", "track"), query=query) %>% json_parse
}

#' i_get_tracks_id
#' 
#' i_get_tracks_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  id id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_tracks_id <- function(spot_ctx, id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("tracks", retrieve_id(id, id_type)), query=query) %>% json_parse
}

#' i_get_tracks_ids
#' 
#' i_get_tracks_ids
#' 
#' @param  spot_ctx spot_ctx
#' @param  ids ids
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_tracks_ids <- function(spot_ctx, ids, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("tracks?ids=", list_ids(ids, id_type)), query=query) %>% json_parse
}

#' i_get_users_user_id
#' 
#' i_get_users_user_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  user_id user_id
#' @param  query query
#' @return a list
#' @export
i_get_users_user_id <- function(spot_ctx, user_id, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("users", user_id), query=query) %>% json_parse
}

#' i_get_users_user_id_playlists
#' 
#' i_get_users_user_id_playlists
#' 
#' @param  spot_ctx spot_ctx
#' @param  user_id user_id
#' @param  query query
#' @return a list
#' @export
i_get_users_user_id_playlists <- function(spot_ctx, user_id, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("users", user_id, "playlists"), query=query) %>% json_parse
}

#' i_get_me_playlists
#' 
#' i_get_me_playlists
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_playlists <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "playlists"), query=query) %>% json_parse
}

#' i_get_users_user_id_playlists_playlist_id
#' 
#' i_get_users_user_id_playlists_playlist_id
#' 
#' @param  spot_ctx spot_ctx
#' @param  user_id user_id
#' @param  playlist_id playlist_id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_users_user_id_playlists_playlist_id <- function(spot_ctx, user_id, playlist_id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("users", user_id, "playlists", retrieve_id(playlist_id, playlist_id_type)), query=query) %>% json_parse
}

#' i_get_users_user_id_playlists_playlist_id_tracks
#' 
#' i_get_users_user_id_playlists_playlist_id_tracks
#' 
#' @param  spot_ctx spot_ctx
#' @param  user_id user_id
#' @param  playlist_id playlist_id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_users_user_id_playlists_playlist_id_tracks <- function(spot_ctx, user_id, playlist_id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("users", user_id, "playlists", retrieve_id(playlist_id, playlist_id_type), "tracks"), query=query) %>% json_parse
}

#' i_get_users_user_id_playlists_playlist_id_followers_contains
#' 
#' i_get_users_user_id_playlists_playlist_id_followers_contains
#' 
#' @param  spot_ctx spot_ctx
#' @param  user_id user_id
#' @param  playlist_id playlist_id
#' @param  id_type id_type
#' @param  query query
#' @return a list
#' @export
i_get_users_user_id_playlists_playlist_id_followers_contains <- function(spot_ctx, user_id, playlist_id, id_type, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("users", user_id, "playlists", retrieve_id(playlist_id, playlist_id_type), "followers", "contains"), query=query) %>% json_parse
}

#' i_get_me_player_recently_played
#' 
#' i_get_me_player_recently_played
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_player_recently_played <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "player", "recently-played"), query=query) %>% json_parse
}

#' i_get_me_player_devices
#' 
#' i_get_me_player_devices
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_player_devices <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "player", "devices"), query=query) %>% json_parse
}

#' i_get_me_player
#' 
#' i_get_me_player
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_player <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "player"), query=query) %>% json_parse
}

#' i_get_me_player_currently_playing
#' 
#' i_get_me_player_currently_playing
#' 
#' @param  spot_ctx spot_ctx
#' @param  query query
#' @return a list
#' @export
i_get_me_player_currently_playing <- function(spot_ctx, query=NULL) {
  spot_get(spot_ctx, create_url_endpoint("me", "player", "currently-playing"), query=query) %>% json_parse
}

