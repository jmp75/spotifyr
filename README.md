# spotifyr - R client for The Spotify Web API

## Description

spotifyr is a thin client library for the Spotify Web API.

## Installation

* TBC Install the release version of `spotifyr` from CRAN with `install.packages("spotifyr")`, or
* Install the development version of spotifyr (assuming you have devtools)

```R
devtools::install_github("jmp75/spotifyr")
```

## Quick Start

From the "getting started" vignette (see [there](https://developer.spotify.com/web-api/authorization-guide/) for getting a client id/secret)

```R
library(spotifyr)
# Adapt the following
Sys.setenv(
    SPOTIFYR_CLIENT_ID='0123456789abcdef0123456789abcdef',
    SPOTIFYR_CLIENT_SECRET='0123456789abcdeffffffffffffffffff',
    SPOTIFYR_REDIRECT_URI='http://localhost:8888/callback'
)
ctx <- spotify_interactive_login()

album_id <- "spotify:album:51fdWBBJ2KdQDwT5gskA0Y"
the_album <- albums(album_id, ctx)
names(the_album)
the_album$name
class(the_album$tracks$items)
faufile <- the_album$tracks$items[6,]
faufile$artists
faufile_track <- tracks(faufile$uri, ctx)
faufile_track$name
```

## Acknowledgements

`spotifyr` first started by porting from [spotipy](https://github.com/plamere/spotipy). In the end the R package was pretty much all rewritten but the author is grateful for learning from `spotipy`.

The code dealing with OAuth2 authentication borrows a lot from [rgithub](https://github.com/cscheid/rgithub/).

## Reporting Issues

If you have suggestions, bugs or other issues specific to this library, file them [here](https://github.com/jmp75/spotifyr/issues). Or just send me a pull request.

