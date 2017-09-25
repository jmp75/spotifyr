
library(magrittr)

#' Make a GET request to the spotify API
#' 
#' Make a GET request to the spotify API
#' 
#' @param spot_ctx - a list with the essential Spotify API connection settings
#' @param url_postfix - the part after the root spotify Web API site URL
#' @param ... extra arguments to build URLs - usage to be determined
#' @import httr
#' @return a list with class attribute 'response'
spot_get <- function(spot_ctx, url_postfix, ...) {
  gtoken <- spot_ctx$token
  url <- spot_url(spot_ctx, url_postfix)
  response <- httr::GET(url, config = gtoken, ...)
  httr::stop_for_status(response)
  response
}

spot_put <- function(spot_ctx, url_postfix, ...) {
  stop("spot_put not yet implemented")
}

spot_post <- function(spot_ctx, url_postfix, ...) {
  stop("spot_post not yet implemented")
}

spot_delete <- function(spot_ctx, url_postfix, ...) {
  stop("spot_delete not yet implemented")
}


create_query_parameters <- function(...) {
  p <- list(...)
  missing_index <- which(!sapply(p, is.null))
  p <- p[missing_index]
  p <- lapply(p, create_query_parameter)
  p
}

create_query_parameter <- function(x) {
  if(is.character(x)) {
    x <- paste(x, collapse=',')
  }
  x
}

#' helper function
#' 
#' helper function among other elements from https://github.com/rstudio/rstudio-conf/blob/master/2017/Web_APIs_R_Amanda_Gadrow/swapi.R
#' 
#' @param response response to a Web API call made via httr
#' @import jsonlite
json_parse <- function(response) {
  text <- content(response, as = "text", encoding = "UTF-8")
  if (identical(text, "")) warning("No output to parse.")
  jsonlite::fromJSON(text)
}

