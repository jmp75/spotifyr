# spotifyr - a R client for The Spotify Web API

## Description

spotifyr is a thin client library for the Spotify Web API.

## Installation

* TBC Install the release version of `spotifyr` from CRAN with `install.packages("spotifyr")`, or
* Install the development version of spotifyr (assuming you have devtools)

```R
devtools::install_github("jmp75/spotifyr")
```

## Quick Start
To get started, simply install spotifyr, create a Spotify object and call methods:

```R
library(spotifyr)
token <- spotify_get_some_auth_token()
# Note: point to naming and code conventions
results <- spotify_search(q='weezer', limit=20)
some_data_frame <- spotify_todo(results)
#for i, t in enumerate(results['tracks']['items']):
#    print ' ', i, t['name']
```

## Acknowledgements

TBC, but a priori a lot will be borrowed from [spotipy](https://github.com/plamere/spotipy).

## Reporting Issues

If you have suggestions, bugs or other issues specific to this library, file them [here](https://github.com/jmp75/spotifyr/issues). Or just send me a pull request.

