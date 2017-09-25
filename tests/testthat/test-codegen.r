context("codegen")

test_that("generate low level web api calls", {

  x <- "GET, /v1/albums/{id}, Get an album, album"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"albums\", retrieve_id(id, id_type))")
  expect_equal(generate_low_level_funcname(x), "i_get_albums_id")

  x <- "GET, /v1/albums?ids={ids}, Get several albums, albums"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"albums?ids=\", list_ids(ids, id_type))")
  expect_equal(generate_low_level_funcname(x), "i_get_albums_ids")

  x <- "GET, /v1/albums/{id}/tracks , Get an album's tracks, tracks*"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"albums\", retrieve_id(id, id_type), \"tracks\")")
  expect_equal(generate_low_level_funcname(x), "i_get_albums_id_tracks")

  x <- "GET, /v1/artists/{id}, Get an artist, artist "
  x <- "GET, /v1/artists?ids={ids}, Get several artists, artists "
  x <- "GET, /v1/artists/{id}/albums, Get an artist's albums, albums*"
  x <- "GET, /v1/artists/{id}/top-tracks, Get an artist's top tracks, tracks"
  x <- "GET, /v1/artists/{id}/related-artists, Get an artist's related artists, artists "
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"artists\", retrieve_id(id, id_type), \"related-artists\")")
  expect_equal(generate_low_level_funcname(x), "i_get_artists_id_related_artists")

  x <- "GET, /v1/audio-analysis/{id}, Get Audio Analysis for a Track, audio analysis object"
  x <- "GET, /v1/audio-features/{id}, Get audio features for a track, audio features"
  x <- "GET, /v1/audio-features?ids={ids}, Get audio features for several tracks, audio features"
  x <- "GET, /v1/browse/featured-playlists , Get a list of featured playlists , playlists"
  x <- "GET, /v1/browse/new-releases, Get a list of new releases, albums*"
  x <- "GET, /v1/browse/categories, Get a list of categories, categories"
  x <- "GET, /v1/browse/categories/{id}, Get a category, category"
  x <- "GET, /v1/browse/categories/{id}/playlists, Get a category's playlists, playlists*"
  x <- "GET, /v1/me, Get current user's profile, user"
  x <- "GET, /v1/me/following, Get Followed Artists, artists"
  x <- "GET, /v1/me/following/contains, Check if User Follows Users or Artists, true/false"
  x <- "GET, /v1/me/tracks, Get user's saved tracks, saved tracks"
  x <- "GET, /v1/me/tracks/contains?ids={ids}, Check user's saved tracks, true/false"
  x <- "GET, /v1/me/albums, Get user's saved albums, saved albums"
  x <- "GET, /v1/me/albums/contains?ids={ids}, Check user's saved albums, true/false"
  x <- "GET, /v1/me/top/{type}, Get a user's top artists or tracks, artists or tracks"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"me\", \"top\", check_type(type))")
  expect_equal(generate_low_level_funcname(x), "i_get_me_top_type")

  x <- "GET, /v1/recommendations, Get recommendations based on seeds, recommendations object"
  x <- "GET, /v1/search?type=album, Search for an album, albums*"
  x <- "GET, /v1/search?type=artist, Search for an artist, artists"
  x <- "GET, /v1/search?type=playlist, Search for a playlist, playlists*"
  x <- "GET, /v1/search?type=track, Search for a track, tracks"
  x <- "GET, /v1/tracks/{id}, Get a track, tracks"
  x <- "GET, /v1/tracks?ids={ids}, Get several tracks, tracks"
  x <- "GET, /v1/users/{user_id}, Get a user's profile, user*"
  x <- "GET, /v1/users/{user_id}/playlists, Get a list of a user's playlists, playlists*"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"users\", user_id, \"playlists\")")
  expect_equal(generate_low_level_funcname(x), "i_get_users_user_id_playlists")

  x <- "GET, /v1/me/playlists, Get a list of the current user's playlists , playlists*"
  x <- "GET, /v1/users/{user_id}/playlists/{playlist_id}, Get a playlist, playlist"
  x <- "GET, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Get a playlist's tracks, tracks"
  x <- "GET, /v1/users/{user_id}/playlists/{playlist_id}/followers/contains, Check if Users Follow a Playlist, true/false"
  expect_equal(generate_endpoint_url(x), "create_url_endpoint(\"users\", user_id, \"playlists\", retrieve_id(playlist_id, playlist_id_type), \"followers\", \"contains\")")
  expect_equal(generate_low_level_funcname(x), "i_get_users_user_id_playlists_playlist_id_followers_contains")

  x <- "GET, /v1/me/player/recently-played, Get Current User’s Recently Played Tracks, play history object"
  x <- "GET, /v1/me/player/devices, Get a User’s Available Devices, "
  x <- "GET, /v1/me/player, Get Information About The User’s Current Playback, "
  x <- "GET, /v1/me/player/currently-playing, Get the User’s Currently Playing Track, "
    
})
