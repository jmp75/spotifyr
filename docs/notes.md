

These are my evolving dev notes - not of use in the package itself.

# References and prior art

[mscsweblm4r](https://github.com/philferriere/mscsweblm4r)
[httr](https://www.r-pkg.org/pkg/httr)

# elaboration

see [elaboration.r](../vignettes/elaboration.R)

# generate api functions

## 2017-10-02

Found out about swagger, now known as OpenAPI

```sh
java -jar modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate -i http://petstore.swagger.io/v2/swagger.json   -l java   -o samples/client/petstore/java^C
```

```sh
cd ~/src/tmp/testspf
java -jar ~/src/tmp/swagger-codegen-master/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate -i https://github.com/APIs-guru/openapi-directory/blob/master/APIs/spotify.com/v1/swagger.yaml -l java   -o ./java

```

```sh
cd ~/src/tmp/testspf
java -jar ~/src/tmp/swagger-codegen-master/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate -i ./spf.yaml -l java -o ./java
```

## 2017-09

```r

library(devtools)
require(httpuv)
library(testthat)

library(httr)
library(jsonlite)
library(magrittr)

load_all('/home/per202/src/github_jm/spotifyr')

api_lines <- c(
"GET, /v1/albums/{id}, Get an album, album"
,"GET, /v1/albums?ids={ids}, Get several albums, albums"
,"GET, /v1/albums/{id}/tracks , Get an album's tracks, tracks*"
,"GET, /v1/artists/{id}, Get an artist, artist "
,"GET, /v1/artists?ids={ids}, Get several artists, artists "
,"GET, /v1/artists/{id}/albums, Get an artist's albums, albums*"
,"GET, /v1/artists/{id}/top-tracks, Get an artist's top tracks, tracks"
,"GET, /v1/artists/{id}/related-artists, Get an artist's related artists, artists "
,"GET, /v1/audio-analysis/{id}, Get Audio Analysis for a Track, audio analysis object"
,"GET, /v1/audio-features/{id}, Get audio features for a track, audio features"
,"GET, /v1/audio-features?ids={ids}, Get audio features for several tracks, audio features"
,"GET, /v1/browse/featured-playlists , Get a list of featured playlists , playlists"
,"GET, /v1/browse/new-releases, Get a list of new releases, albums*"
,"GET, /v1/browse/categories, Get a list of categories, categories"
,"GET, /v1/browse/categories/{id}, Get a category, category"
,"GET, /v1/browse/categories/{id}/playlists, Get a category's playlists, playlists*"
,"GET, /v1/me, Get current user's profile, user"
,"GET, /v1/me/following, Get Followed Artists, artists"
,"GET, /v1/me/following/contains, Check if User Follows Users or Artists, true/false"
,"GET, /v1/me/tracks, Get user's saved tracks, saved tracks"
,"GET, /v1/me/tracks/contains?ids={ids}, Check user's saved tracks, true/false"
,"GET, /v1/me/albums, Get user's saved albums, saved albums"
,"GET, /v1/me/albums/contains?ids={ids}, Check user's saved albums, true/false"
,"GET, /v1/me/top/{type}, Get a user's top artists or tracks, artists or tracks"
,"GET, /v1/recommendations, Get recommendations based on seeds, recommendations object"
,"GET, /v1/search?type=album, Search for an album, albums*"
,"GET, /v1/search?type=artist, Search for an artist, artists"
,"GET, /v1/search?type=playlist, Search for a playlist, playlists*"
,"GET, /v1/search?type=track, Search for a track, tracks"
,"GET, /v1/tracks/{id}, Get a track, tracks"
,"GET, /v1/tracks?ids={ids}, Get several tracks, tracks"
,"GET, /v1/users/{user_id}, Get a user's profile, user*"
,"GET, /v1/users/{user_id}/playlists, Get a list of a user's playlists, playlists*"
,"GET, /v1/me/playlists, Get a list of the current user's playlists , playlists*"
,"GET, /v1/users/{user_id}/playlists/{playlist_id}, Get a playlist, playlist"
,"GET, /v1/users/{user_id}/playlists/{playlist_id}/tracks, Get a playlist's tracks, tracks"
,"GET, /v1/users/{user_id}/playlists/{playlist_id}/followers/contains, Check if Users Follow a Playlist, true/false"
,"GET, /v1/me/player/recently-played, Get Current User’s Recently Played Tracks, play history object"
,"GET, /v1/me/player/devices, Get a User’s Available Devices, "
,"GET, /v1/me/player, Get Information About The User’s Current Playback, "
,"GET, /v1/me/player/currently-playing, Get the User’s Currently Playing Track, "
)

func <- lapply(api_lines, generate_low_level, exported=TRUE)

x <- c(
    '#####################################',
    '# THIS FILE IS GENERATED - DO NOT MODIFY',
    '#####################################',
    ''
)
for (i in 1:length(func)) { x <- c(x, func[[i]])}

writeLines( x, '/home/per202/src/github_jm/spotifyr/R/low-level-client-generated.r')
```

```r
library(roxygen2)
roxygenize('/home/per202/src/github_jm/spotifyr')
```


