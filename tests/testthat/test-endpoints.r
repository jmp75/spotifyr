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
