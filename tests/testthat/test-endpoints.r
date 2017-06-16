library(spotifyr)
context("Spotify API endpoints")

creep_urn <- 'spotify:track:3HfB5hBU0dmBt8T0iCmH42'
creep_id <- '3HfB5hBU0dmBt8T0iCmH42'
creep_url <- 'http://open.spotify.com/track/3HfB5hBU0dmBt8T0iCmH42'
el_scorcho_urn <- 'spotify:track:0Svkvt5I79wficMFgaqEQJ'
el_scorcho_bad_urn <- 'spotify:track:0Svkvt5I79wficMFgaqEQK'
pinkerton_urn <- 'spotify:album:04xe676vyiTeYNXw15o9jT'
weezer_urn <- 'spotify:artist:3jOstUTkEu2JkjvRdBA5Gu'
pablo_honey_urn <- 'spotify:album:6AZv3m27uyRxi8KyJSfUxL'
radiohead_urn <- 'spotify:artist:4Z8W4fKeB5YxbusRsdQVPb'
angeles_haydn_urn <- 'spotify:album:1vAbqAeuJVWNAe7UR00bdM'
bad_id <- 'BAD_ID'

# As of June 2017 all requests require a token ID. 
# Not sure yet how it will look but a hint of an object state here to avoid tokens passed as parameters. 
# Maybe an S4 or R6 class is warranted for this.
spotify_token <- spotipy.Spotify()

test_that("test_artist_urn", {
    artist <- spotify_token$artist(radiohead_urn)
    # in spotipy artist is a dict - likely we want to have lists with names in spotifyr
    # we may want to consider 'dict' or 'hash' packages, but likely httr returns lists anyway.
    expect_true(artist$name == 'Radiohead')
})

test_that("test_artists", {
    results <- spotify_token$artists(c(weezer_urn, radiohead_urn))
    expect_true('artists' %in% names(results))
    expect_true(length(results$artists) == 2)
})

test_that("test_album_urn", {
    album <- spotify_token$album(pinkerton_urn)
    expect_true(album$name == 'Pinkerton')
})

test_that("test_album_tracks", {
    results <- spotify_token$album_tracks(pinkerton_urn)
    expect_true(length(results$items) == 10)
})

test_that("test_album_tracks_many", {
    results <- spotify_token$album_tracks(angeles_haydn_urn)
    tracks <- results$items
    total <- results$total
    received <- length(tracks)
    while received < total:
        results <- spotify_token$album_tracks(angeles_haydn_urn, offset=received)
        tracks.extend(results$items)
        received <- length(tracks)

    assertEqual(received, total)
})

test_that("test_albums", {
    results <- spotify_token$albums(c(pinkerton_urn, pablo_honey_urn))
    expect_true('albums' %in% names(results))
    expect_true(length(results$albums) == 2)
})

test_that("test_track_urn", {
    track <- spotify_token$track(creep_urn)
    expect_true(track$name == 'Creep')
})

test_that("test_track_id", {
    track <- spotify_token$track(creep_id)
    expect_true(track$name == 'Creep')
})

test_that("test_track_url", {
    track <- spotify_token$track(creep_url)
    expect_true(track$name == 'Creep')
})

test_that("test_track_bad_urn", {
    try:
        track <- spotify_token$track(el_scorcho_bad_urn)
        expect_true(False)
    except spotipy.SpotifyException:
        expect_true(True)
})

test_that("test_tracks", {
    results <- spotify_token$tracks(c(creep_url, el_scorcho_urn))
    expect_true('tracks' %in% names(results))
    expect_true(length(results$tracks) == 2)
})

test_that("test_artist_top_tracks", {
    results <- spotify_token$artist_top_tracks(weezer_urn)
    expect_true('tracks' %in% names(results))
    expect_true(length(results$tracks) == 10)
})

test_that("test_artist_related_artists", {
    results <- spotify_token$artist_related_artists(weezer_urn)
    expect_true('artists' %in% names(results))
    expect_true(length(results$artists) == 20)
    for artist in results$artists:
        if artist$name == 'Jimmy Eat World':
            found <- True
    expect_true(found)
})

test_that("test_artist_search", {
    results <- spotify_token$search(q='weezer', type='artist')
    expect_true('artists' %in% names(results))
    expect_true(length(results$artists$items) > 0)
    expect_true(results$artists$items[0]$name == 'Weezer')
})

test_that("test_artist_search_with_market", {
    results <- spotify_token$search(q='weezer', type='artist', market='GB')
    expect_true('artists' %in% names(results))
    expect_true(length(results$artists$items) > 0)
    expect_true(results$artists$items[0]$name == 'Weezer')
})

test_that("test_artist_albums", {
    results <- spotify_token$artist_albums(weezer_urn)
    expect_true('items' %in% names(results))
    expect_true(length(results$items) > 0)

    found <- False
    for album in results$items:
        if album$name == 'Hurley':
            found <- True

    expect_true(found)
})

test_that("test_search_timeout", {
    sp <- spotipy.Spotify(requests_timeout=.1)
    try:
        results <- sp.search(q='my*', type='track')
        expect_true(False, 'unexpected search timeout')
    except requests.ReadTimeout:
        expect_true(True, 'expected search timeout')
})


test_that("test_album_search", {
    results <- spotify_token$search(q='weezer pinkerton', type='album')
    expect_true('albums' %in% names(results))
    expect_true(length(results$albums$items) > 0)
    expect_true(results$albums$items[0]$name.find('Pinkerton') >= 0)
})

test_that("test_track_search", {
    results <- spotify_token$search(q='el scorcho weezer', type='track')
    expect_true('tracks' %in% names(results))
    expect_true(length(results$tracks$items) > 0)
    expect_true(results$tracks$items[0]$name == 'El Scorcho')
})

test_that("test_user", {
    user <- spotify_token$user(user='plamere')
    expect_true(user['uri'] == 'spotify:user:plamere')
})

test_that("test_track_bad_id", {
    try:
        track <- spotify_token$track(bad_id)
        expect_true(False)
    except spotipy.SpotifyException:
        expect_true(True)
})

test_that("test_track_bad_id", {
    try:
        track <- spotify_token$track(bad_id)
        expect_true(False)
    except spotipy.SpotifyException:
        expect_true(True)
})

test_that("test_unauthenticated_post_fails", {
    with assertRaises(SpotifyException) as cm:
        spotify_token$user_playlist_create("spotify", "Best hits of the 90s")
    expect_true(cm.exception.http_status == 401 or
        cm.exception.http_status == 403)
})

test_that("test_custom_requests_session", {
    from requests import Session
    sess <- Session()
    sess.headers["user-agent"] <- "spotipy-test"
    with_custom_session <- spotipy.Spotify(requests_session=sess)
    expect_true(with_custom_session.user(user="akx")["uri"] == "spotify:user:akx")
})

test_that("test_force_no_requests_session", {
    from requests import Session
    with_no_session <- spotipy.Spotify(requests_session=False)
    self.assertFalse(isinstance(with_no_session._session, Session))
    expect_true(with_no_session.user(user="akx")["uri"] == "spotify:user:akx")
})


