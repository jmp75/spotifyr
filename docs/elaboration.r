library(devtools)
require(httpuv)
library(testthat)

library(httr)
library(jsonlite)
library(magrittr)

load_all('/home/per202/src/github_jm/spotifyr')

source('~/credentials/private_spotify_creds.R')



library(spotifyr)
source('~/credentials/private_spotify_creds.R')
# ctx <- spotify_interactive_login()

ctx <- spotify_background_login('~/credentials/doc_http_auth')
album_id <- "spotify:album:51fdWBBJ2KdQDwT5gskA0Y"
the_album <- albums(album_id, ctx)

album_tracks(album_id, ctx)

ctx <- spotify_interactive_login()

dirty_dirty_track_id <- '4nETpyqHdNiVyEEM9jo7WN'
x <- i_get_tracks(ctx, dirty_dirty_track_id, 'track')

stop_for_status(x)  # convert HTTP errors to R errors
names(x)
x$status_code
x$headers$`content-type`

clue_json <- x


# Parse with jsonlite
clue <- json_text_content %>% 
  fromJSON


# Helper function
json_parse <- function(req) {
  text <- content(req, as = "text", encoding = "UTF-8")
  if (identical(text, "")) warn("No output to parse.")
  fromJSON(text)
}


# Parse with httr
json_text_content <- content(clue_json, as = "text")
json_text_content
json_parsed_content <- content(clue_json, as = "parsed")
json_parsed_content
names(json_parsed_content)

album_id <- "spotify:album:51fdWBBJ2KdQDwT5gskA0Y"
album_response <- i_get_albums(ctx, album_id, "album")
album_parsed <- json_parse(album_response)
class(album_parsed)


the_album <- album(album_id, ctx)

charlotte_s_track <- track(ctx, dirty_dirty_track_id)

## Getting more than one track at a time:
deixa_track_id <- '7DIjp3BM7vlta1UixnQOp9'
tracks(ctx, tracks=c(dirty_dirty_track_id, deixa_track_id))

text_content <- httr::content(charlotte_s_track, as="text", encoding="UTF-8")
x <- text_content %>% fromJSON


# GET, /v1/  ===>  # spot_get(spot_ctx, create_url_endpoint("
# {id}  ===> retrieve_id(id, id_type)
# /retrieve_id ===>  ", retrieve_id
# id_type)/ ===> id_type), "
# spot_get(spot_ctx, create_url_endpoint("albums", retrieve_id(id, id_type)        #  , Get an album, album

#######################################################

# Method	Endpoint	Usage	Returns

# GET, /v1/albums/{id}, Get an album, album
# GET, /v1/albums?ids={ids}, Get several albums, albums
# GET, /v1/albums/{id}/tracks , Get an album's tracks, tracks*
# GET, /v1/artists/{id}, Get an artist, artist 
# GET, /v1/artists?ids={ids}, Get several artists, artists 
# GET, /v1/artists/{id}/albums, Get an artist's albums, albums*
# GET, /v1/artists/{id}/top-tracks, Get an artist's top tracks, tracks
# GET, /v1/artists/{id}/related-artists, Get an artist's related artists, artists 
# GET, /v1/audio-analysis/{id}, Get Audio Analysis for a Track, audio analysis object
# GET, /v1/audio-features/{id}, Get audio features for a track, audio features
# GET, /v1/audio-features?ids={ids}, Get audio features for several tracks, audio features
# GET, /v1/browse/featured-playlists , Get a list of featured playlists , playlists
# GET, /v1/browse/new-releases, Get a list of new releases, albums*
# GET, /v1/browse/categories, Get a list of categories, categories
# GET, /v1/browse/categories/{id}, Get a category, category
# GET, /v1/browse/categories/{id}/playlists, Get a category's playlists, playlists*
# GET, /v1/me, Get current user's profile, user
# GET, /v1/me/following, Get Followed Artists, artists
# GET, /v1/me/following/contains, Check if User Follows Users or Artists, true/false
# GET, /v1/me/tracks, Get user's saved tracks, saved tracks
# GET, /v1/me/tracks/contains?ids={ids}, Check user's saved tracks, true/false
# GET, /v1/me/albums, Get user's saved albums, saved albums
# GET, /v1/me/albums/contains?ids={ids}, Check user's saved albums, true/false
# GET, /v1/me/top/{type}, Get a user's top artists or tracks, artists or tracks
# GET, /v1/recommendations, Get recommendations based on seeds, recommendations object
# GET, /v1/search?type=album, Search for an album, albums*
# GET, /v1/search?type=artist, Search for an artist, artists
# GET, /v1/search?type=playlist, Search for a playlist, playlists*
# GET, /v1/search?type=track, Search for a track, tracks
# GET, /v1/tracks/{id}, Get a track, tracks
# GET, /v1/tracks?ids={ids}, Get several tracks, tracks
# GET, /v1/users/{user_id}, Get a user's profile, user*
# GET, /v1/users/{user_id}/playlists, Get a list of a user's playlists, playlists*
# GET, /v1/me/playlists, Get a list of the current user's playlists , playlists*
# GET, /v1/users/{user_id}/playlists/{playlist_id}, Get a playlist, playlist
# GET, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Get a playlist's tracks, tracks
# GET, /v1/users/{user_id}/playlists/{playlist_id}/followers/contains, Check if Users Follow a Playlist, true/false
# GET, /v1/me/player/recently-played, Get Current User’s Recently Played Tracks, play history object
# GET, /v1/me/player/devices, Get a User’s Available Devices, 
# GET, /v1/me/player, Get Information About The User’s Current Playback, 
# GET, /v1/me/player/currently-playing, Get the User’s Currently Playing Track, 

# POST, /v1/users/{user_id}/playlists, Create a playlist, playlist
# POST, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Add tracks to a playlist, -
# POST, /v1/me/player/next, Skip User’s Playback To Next Track, 
# POST, /v1/me/player/previous, Skip User’s Playback To Previous Track, 

# PUT, /v1/me/following, Follow Artists or Users, -
# PUT, /v1/users/{owner_id}/playlists/{playlist_id}/followers, Follow a Playlist, -
# PUT, /v1/me/tracks?ids={ids}, Save tracks for user, -
# PUT, /v1/me/albums?ids={ids}, Save albums for user, -
# PUT, /v1/users/{user_id}/playlists/{playlist_id}, Change a playlist's details, -
# PUT, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Reorder a playlist's tracks, snapshot_id
# PUT, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Replace a playlist's tracks, -
# PUT, /v1/users/{user_id}/playlists/{playlist_id}/images, Upload a Custom Playlist Cover Image, 
# PUT, /v1/me/player, Transfer a User’s Playback, 
# PUT, /v1/me/player/play, Start/Resume a User’s Playback, 
# PUT, /v1/me/player/pause, Pause a User’s Playback, 
# PUT, /v1/me/player/seek, Seek To Position In Currently Playing Track, 
# PUT, /v1/me/player/repeat, Set Repeat Mode On User’s Playback, 
# PUT, /v1/me/player/volume, Set Volume For User’s Playback, 
# PUT, /v1/me/player/shuffle , Toggle Shuffle For User’s Playback 	

# DELETE, /v1/me/following, Unfollow Artists or Users, -
# DELETE, /v1/users/{owner_id}/playlists/{playlist_id}/followers, Unfollow a Playlist, -
# DELETE, /v1/me/tracks?ids={ids}, Remove user's saved tracks, -
# DELETE, /v1/me/albums?ids={ids}, Remove user's saved albums, -
# DELETE, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Remove tracks from a playlist, snapshot_id

