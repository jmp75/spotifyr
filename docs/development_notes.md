<!-- ---
title: "Development notes for spotifyr"
author: "Jean-Michel Perraud"
date: "`r Sys.Date()`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Development notes for spotifyr}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
--- -->

These are personal dev notes, as a memento - skim if you wish.

## Prior art

* [Spotipy](https://github.com/plamere/spotipy)
* [An R package tapping into a Web API](https://github.com/philferriere/mscsweblm4r)
* Looks like the `httr` package is the equivalent of the `requests` python package. Not sure hot to transpose use though. Work by similarities. 

## The really messy part of poking and seeing what's happening

Careful with IDs, as a principle.
Use `source ~/private_spotify_creds.sh` for actual stuff 

```py
export SPOTIPY_CLIENT_ID='428ebb1c7bc044298a20f62225dd413d'
export SPOTIPY_CLIENT_SECRET='XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export SPOTIPY_REDIRECT_URI='http://localhost:8888/callback'
Redirect URIs
#http://localhost:8888/callback
```

Seems I now _do_ need a server running to get a token

```sh
nodejs ~/src/tmp/spotipy/server.js 
```

```py
import pprint
import sys

import spotipy
import spotipy.util as util
import simplejson as json

username = 'jmp202'
scope = 'user-library-read'
token = util.prompt_for_user_token(username, scope)
# token = 'BQC4fxC6TKqTWSwEYe6TLyU1fJRn3AdIOUav9lXfezI8az0haR4GGSRn-BMYJoTSaf4KxNW_LHCAqXSSXAK4m7kUEIgXgjwA1OCQN8nmP0xmp45FQZjxoEQNEtq0yWZjCIFoRsUbog'

sp = spotipy.Spotify(auth=token)
sp.trace = False


creep_urn = 'spotify:track:3HfB5hBU0dmBt8T0iCmH42'
creep_id = '3HfB5hBU0dmBt8T0iCmH42'
creep_url = 'http://open.spotify.com/track/3HfB5hBU0dmBt8T0iCmH42'
el_scorcho_urn = 'spotify:track:0Svkvt5I79wficMFgaqEQJ'
el_scorcho_bad_urn = 'spotify:track:0Svkvt5I79wficMFgaqEQK'
pinkerton_urn = 'spotify:album:04xe676vyiTeYNXw15o9jT'
weezer_urn = 'spotify:artist:3jOstUTkEu2JkjvRdBA5Gu'
pablo_honey_urn = 'spotify:album:6AZv3m27uyRxi8KyJSfUxL'
radiohead_urn = 'spotify:artist:4Z8W4fKeB5YxbusRsdQVPb'
angeles_haydn_urn = 'spotify:album:1vAbqAeuJVWNAe7UR00bdM'

bad_id = 'BAD_ID'

artist = sp.artist(radiohead_urn)

results = sp.current_user_saved_tracks()
for item in results['items']:
    track = item['track']
    print(track['name'] + ' - ' + track['artists'][0]['name'])

```

Step 2b: low-level taste

```R
library(httr)

#http://localhost:8888/callback?AQAC828ATouX5arXSwUqwosusl3mJ-6QZNTRntR5M_TYtwVEhABwMRyEQm-OxjHIvtyE3cvjHOR8oogLzs13O91AecuR32_67NitoHlFx2BcyJH93QcJOgx1x2Aka6BlnjLWx_7fDvSyd3OIozcUA5jaZLIBwTAQvtOcmeS6sbSSjcXnypXKHO60EnTv5kn2voK7KnA5ICb3uIh50Brt9H305F76nhg
token = 'BQC4fxC6TKqTWSwEYe6TLyU1fJRn3AdIOUav9lXfezI8az0haR4GGSRn-BMYJoTSaf4KxNW_LHCAqXSSXAK4m7kUEIgXgjwA1OCQN8nmP0xmp45FQZjxoEQNEtq0yWZjCIFoRsUbog'
r <- GET("https://api.spotify.com/v1/tracks/3n3Ppam7vgaVa1iaRUc9Lp", add_headers(Authorization = paste0('Bearer ', token), Accept='application/json'))
str(r)
typeof(r)
class(r)

status_code(r)
headers(r)
```


```r
OAUTH_TOKEN_URL <- "https://accounts.spotify.com/api/token"
client_id='428ebb1c7bc044298a20f62225dd413d'
client_secret='XXXXXXXXXXXXXXXXXXXXXXXXXXXX'
#export SPOTIPY_REDIRECT_URI='http://localhost:8888/callback'
self <- create_SpotifyClientCredentials(client_id=client_id, client_secret=client_secret, proxies=NA)
payload <- list()
payload$grant_type <- 'client_credentials' 
headers <- make_authorization_headers(self$client_id, self$client_secret)
# POST(url = NULL, config = list(), ..., body = NULL,
# encode = c("multipart", "form", "json"), multipart = TRUE,
# handle = NULL)
response <- POST(url=OAUTH_TOKEN_URL, body=payload,
    config=headers) 
    # verify=True, proxies=self$proxies)
response
status_code(response)
reason
content(response)
content(response, as='text')
content(response, as='json')


library(httr)
spotify_oauth_endpoint <- httr::oauth_endpoint(
  authorize = "https://accounts.spotify.com/authorize",
  access = "https://accounts.spotify.com/api/token")

myapp <- httr::oauth_app("spotifyr",
  key = "428ebb1c7bc044298a20f62225dd413d",
  secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX")

app_token <- oauth2.0_token(spotify_oauth_endpoint, myapp)

gtoken <- config(token = app_token)


req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)


spot_cnx <- create_spotify_object(auth=gtoken, requests_session=TRUE,
        client_credentials_manager=NA, proxies=NA, requests_timeout=NA)


dirty_dirty_track_id <- '4nETpyqHdNiVyEEM9jo7WN'
deixa_track_id <- '7DIjp3BM7vlta1UixnQOp9'

track(spot_cnx, dirty_dirty_track_id)
tracks(spot_cnx, tracks=c(dirty_dirty_track_id, deixa_track_id))

```

## Package 'skeleton'

Actually, I'd advocate to avoid `package.skeleton`

```r
library(devtools)
p <- 'c:/src/github_jm/spotifyr/'
setwd(p)
devtools::use_testthat()
```

And here is a winding road to figuring out where to reuse, reshape, refactor, etc.

[Commit history](https://github.com/jmp75/spotifyr/commits/master)

[devtools::load_all works](https://github.com/jmp75/spotifyr/tree/66db1e1996ff40f771202c4f2a14b03d1ef63f2a)

```r
load_all()
```

moving on to check, and of course this is a long list of issues:

```r
check()
```

let's reduce our ambitions. And iterate with the following:

```r
document()
check(document=FALSE, manual=FALSE, cran=FALSE)
```

Remaining issues:

```txt
* checking DESCRIPTION meta-information ... NOTE
License components which are templates and need '+ file LICENSE':
  MIT

  * checking dependencies in R code ... WARNING
'::' or ':::' import not declared from: 'stringr'
Namespaces in Imports field not imported from:
  'jsonlite' 'methods'
  All declared Imports should be used.
* checking examples ... NONE

 ERROR
Running the tests in 'tests/testthat.R' failed.


Last 13 lines of output:
  The following object is masked from 'package:base':
      search


```

[improve package check](https://github.com/jmp75/spotifyr/tree/f51bea0b594a9643d03f62cfb3546504cdad6cb9)

## Syntactic checks

```r
p <- 'c:/src/github_jm/spotifyr/'
setwd(p)
lintr::lint_package()
```

```txt
...
R\client.r:19:15: style: Use <-, not =, for assignment.
    obj$trace = FALSE  # Enable tracing?
R\client.r:23:18: style: Only use double-quotes.
    obj$prefix = 'https://api.spotify.com/v1/'
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
R\client.r:30:11: style: Commented code should be removed.
    #     self._session = requests_session
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```

Can we fix it automatically:

```r
p <- 'c:/src/github_jm/spotifyr/'
setwd(p)
formatR::tidy_dir("R", indent = 2)
formatR::tidy_dir("tests", indent = 2)
formatR::tidy_dir("tests/testthat/", indent = 2)
```

## vignette

```r
p <- 'c:/src/github_jm/spotifyr/'
setwd(p)
devtools::use_vignette("getting_started")
```

What compelling story do we want?

```r
library(spotifyr)
library(devtools) ; load_all('/home/per202/src/github_jm/spotifyr')
require(httpuv)

#The grubby details:
#  s_endpoint <- httr::oauth_endpoint(
#    authorize = "https://accounts.spotify.com/authorize",
#    access = "https://accounts.spotify.com/api/token")
#  
#  myapp <- httr::oauth_app("spotifyr",
#    key = "428ebb1c7bc044298a20f62225dd413d",
#    secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX")
#  
#  app_token <- oauth2.0_token(s_endpoint, myapp)
# token <- config(token = app_token)

# What we want a user to see by default is rather:
token <- spotify_token()

# req <- GET("https://api.github.com/rate_limit", gtoken)
# stop_for_status(req)
# content(req)

# OR:
# req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
# stop_for_status(req)
# content(req)

spot_cnx <- create_spotify_object(auth=token, requests_session=TRUE,
        client_credentials_manager=NA, proxies=NA, requests_timeout=NA)

dirty_dirty_track_id <- '4nETpyqHdNiVyEEM9jo7WN'
charlotte_s_track <- track(spot_cnx, dirty_dirty_track_id)

deixa_track_id <- '7DIjp3BM7vlta1UixnQOp9'
tracks(spot_cnx, tracks=c(dirty_dirty_track_id, deixa_track_id))
```