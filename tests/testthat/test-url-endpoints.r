context("Creating URLs and related string processing")

test_that("Correct URLs postfix paths are created", {
  
  expected_identifier <- "0123456789abcdef"

  tested <- paste0(
      c(
        "spotify:track:", 
        "track:", 
        "http://spotify.api.mock/track/"),
  expected_identifier)

  x <- retrieve_id(tested, "track")
  expect_equal(x, rep(expected_identifier, 3))
  x <- retrieve_id(tested)
  expect_equal(x, rep(expected_identifier, 3))
  expect_error(retrieve_id(tested, "blah"))

  tested <- paste0(
        "spotify:track:",
      c("123","456","789"))

  x <- list_ids(tested, "track")
  expect_equal(x, "123,456,789")

  expect_equal(create_url_endpoint("albums" ,"{id}"), "v1/albums/{id}")
  expect_equal(create_url_endpoint("albums" ,"{id}", "tracks"), "v1/albums/{id}/tracks")
  expect_equal(create_url_endpoint("artists","{id}"), "v1/artists/{id}")
  expect_equal(create_url_endpoint("artists","{id}", "top-tracks"), "v1/artists/{id}/top-tracks")
  expect_equal(create_url_endpoint("audio-analysis","{id}"), "v1/audio-analysis/{id}")
  expect_equal(create_url_endpoint("albums" ,"?ids={ids}"), "v1/albums?ids={ids}")
  expect_equal(create_url_endpoint("albums" ,"?ids=", "{ids}"), "v1/albums?ids={ids}")
  expect_equal(create_url_endpoint("albums?ids=", "{ids}"), "v1/albums?ids={ids}")

  mock_spoturl <- "http://blah.com"
  expect_equal(spot_url(mock_spoturl, "v1/tracks/abcdef"), "http://blah.com/v1/tracks/abcdef")

})

test_that("Query parameters", {
  album_type='single,album'
  market=NULL
  limit=4
  offset=NULL

  test_url <- 'http://blah.blah'
  test_path <- 'search'
  query <- create_query_parameters(album_type=album_type, market=market, limit=limit, offset=offset)
  expect_equal( 
    httr::modify_url(url=test_url, path=test_path, query=query),
    'http://blah.blah/search?album_type=single%2Calbum&limit=4'
  )
  album_type=c('single','album')
  create_query_parameters(album_type=album_type, market=market, limit=limit, offset=offset)
  expect_equal( 
    httr::modify_url(url=test_url, path=test_path, query=query),
    'http://blah.blah/search?album_type=single%2Calbum&limit=4'
  )
})
  
