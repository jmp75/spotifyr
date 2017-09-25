

#' split a spotify URI
#' 
#' split a spotify URI
#' 
#' @param long_uri - a spotify URI, URL or ID
#' @param sep_pattern sep pattern
#' @import stringr
#' @return the elements of the URI
split_uri <- function(long_uri, sep_pattern="[:/]") {
  stringr::str_split(long_uri, pattern = sep_pattern)
}

#' Retrieve the ID part of the URI
#' 
#' Retrieve the ID part of a URI (spotify:track:AAABBBCCC333) or a URL (http://blah.com/track/AAABBBCCC333)
#' 
#' @param type the expected type for this id, which may be in the long ID form as penultimate entry before the ID
#' @param long_uri - a spotify URI, URL or ID
#' @import stringr
#' @return the short ID
retrieve_id <- function(long_uri, type=NA_character_) {
  fields <- split_uri(long_uri)
  get_uid <- function(fields, type)
  {
    stopifnot(is.character(fields))
    stopifnot(is.character(type))
    n <- length(fields)
    if(n==0) {
        stop("empty character vector")
    } else {
      if(is.na(type) || (n==1)) { # not 100% sure whether we should reject n==1 here if type is not NA
        return(fields[n])
      } else {
        if(fields[n-1] != type) {
          stop(paste0("expected id of type ", type, " but found type ", fields[n-1], " in ", long_uri, " "))
        } else{
          return(fields[n])
        }
      }
    }
  }
  sapply(fields, FUN=get_uid, type=type)
}

#' Retrieve the ID part of the URI, and make a list thereof
#' 
#' Retrieve the ID part of each URI (spotify:track:AAABBBCCC333) or a URL (http://blah.com/track/AAABBBCCC333), and make a list of each for use in the Web API
#' 
#' @param type the expected type for this id, which may be in the long ID form as penultimate entry before the ID
#' @param long_ids - one or more spotify URI, URL or ID
#' @import stringr
#' @return the list of short IDs
list_ids <- function(long_ids, type=NA_character_) {
  uids <- sapply(long_ids, FUN=retrieve_id, type=type)
  paste(uids, collapse=',')
}

#' Builds a spotify URI
#' 
#' Builds a spotify URI from a short ID and the type of the ID, e.g. 'track'
#' 
#' @param type the expected type for this id, which may be in the 
#' @param id - a spotify ID
#' @return the spotify URI
make_uri <- function(type, id) {
  return(paste0("spotify:", type, ":", retrieve_id(type, id)))
}

#' Builds a spotify URL
#' 
#' Builds a full spotify URL for use in web requests
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @return the spotify URL to use in a request
spot_url <- function(spot_ctx, url_postfix) {
  if(is.character(spot_ctx)){ # unit tests
    httr::modify_url(spot_ctx, path=url_postfix) 
  } else {
    httr::modify_url(spot_ctx$api_url, path=url_postfix) 
  }
}

check_type <- function(type) {
  # https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/
  stopifnot(type %in% c('artists' ,'tracks'))
  type
}

#' Builds a spotify URL endpoint
#' 
#' Builds a spotify URL endpoint for use in web requests, see https://developer.spotify.com/web-api/endpoint-reference/
#' 
#' @param ... characters, components of the endpoint URL
#' @return the spotify URL endpoint to use in a request
create_url_endpoint <- function(...) {
  url_ep <- paste(..., sep='/')
  url_ep <- paste("v1", url_ep, sep='/')
  # v1/albums?ids={ids}
  url_ep <- stringr::str_replace_all(url_ep, '/\\?', '\\?')
  url_ep <- stringr::str_replace_all(url_ep, '\\?/', '\\?')
  url_ep <- stringr::str_replace_all(url_ep, '/=', '=')
  url_ep <- stringr::str_replace_all(url_ep, '=/', '=')
  url_ep
}
