

# class SpotifyOauthError(Exception):
#     pass


make_authorization_headers <- function(client_id, client_secret) {
    # spotipy was using a base64 encoding package. and some 'six' package can't figure out for sure what this was about 
    # but probably all only a work around Python 2. None of that may be required here.
    # perhaps <- base64enc::base64encode(paste0('Basic ', client_id, ':', client_secret))
    bb <- base64enc::base64encode( charToRaw(paste0(client_id, ':', client_secret)))
    bd <- base64enc::base64decode(bb)
    httr::add_headers(Authorization = bd)
}

has_token_expired(token_info) {
    tnow <- lubridate::now()
    return(as.numeric(tnow- token_info['expires_at'], units="hours") < 1) # I *think* this was one hour ('60')... TBC
}

OAUTH_TOKEN_URL = 'https://accounts.spotify.com/api/token'

# class SpotifyClientCredentials(object):

create_SpotifyClientCredentials <- function(client_id=NA, client_secret=NA, proxies=NA){
    # """
    # You can either provid a client_id and client_secret to the
    # constructor or set SPOTIPY_CLIENT_ID and SPOTIPY_CLIENT_SECRET
    # environment variables
    # """
    if (is.na(client_id)) {
        client_id = Sys.getenv('SPOTIPY_CLIENT_ID')
    }
    if (is.na(client_secret)) {
        client_secret = Sys.getenv('SPOTIPY_CLIENT_SECRET')
    }
    if (is.na(client_id)) {
        stop('No client id')
    }
    if (is.na(client_secret)) {
        stop('No client secret')
    }

    self <- list()
    self$client_id = client_id
    self$client_secret = client_secret
    self$token_info = NA
    self$proxies = proxies
    return(self)
}

get_access_token <- function(self) {
    # """
    # If a valid access token is in memory, returns it
    # Else feches a new token and returns it
    # """
    if (!is.na(self$token_info) and !has_token_expired(self$token_info)) {
        return(self$token_info$access_token)
    } else {
        token_info = request_access_token()
        token_info = add_custom_values_to_token_info(token_info)
        self$token_info = token_info
        return(self$token_info$access_token)
    }
}

request_access_token <- function(self) {
    # """Gets client credentials access token """
    payload <- list()
    # payload = { 'grant_type': 'client_credentials'}
    payload$grant_type <- 'client_credentials' 

    headers <- make_authorization_headers(self$client_id, self$client_secret)

    # POST(url = NULL, config = list(), ..., body = NULL,
    # encode = c("multipart", "form", "json"), multipart = TRUE,
    # handle = NULL)
    response <- POST(url=OAUTH_TOKEN_URL, body=payload,
        config=headers) 
        # verify=True, proxies=self$proxies)

    if (status_code(response) != 200) {
        raise SpotifyOauthError(response.reason)
    }
    token_info = response.json()
    return token_info
}

add_custom_values_to_token_info <- function(self, token_info) {
    # """
    # Store some values that aren't directly provided by a Web API
    # response.
    # """
    token_info['expires_at'] = int(time.time()) + token_info['expires_in']
    return token_info
}

# class SpotifyOAuth(object):
    # '''
    # Implements Authorization Code Flow for Spotify's OAuth implementation.
    # '''

OAUTH_AUTHORIZE_URL = 'https://accounts.spotify.com/authorize'
OAUTH_TOKEN_URL = 'https://accounts.spotify.com/api/token'

create_SpotifyOAuth <- function(self, client_id, client_secret, redirect_uri,
        state=NA, scope=NA, cache_path=NA, proxies=NA) {
    # '''
    #     Creates a SpotifyOAuth object

    #     Parameters:
    #          - client_id - the client id of your app
    #          - client_secret - the client secret of your app
    #          - redirect_uri - the redirect URI of your app
    #          - state - security state
    #          - scope - the desired scope of the request
    #          - cache_path - path to location to save tokens
    # '''

    self <- list()
    self$client_id = client_id
    self$client_secret = client_secret
    self$redirect_uri = redirect_uri
    self$state=state
    self$cache_path = cache_path
    self$scope=self$_normalize_scope(scope)
    self$proxies = proxies
}

get_cached_token <- function(self) {
    # ''' Gets a cached auth token
    # '''
    token_info = NA
    if self$cache_path:
        try:
            f = open(self$cache_path)
            token_info_string = f.read()
            f.close()
            token_info = json.loads(token_info_string)

            # if scopes don't match, then bail
            if 'scope' not in token_info or not self$is_scope_subset(self$scope, token_info['scope']):
                return NA

            if self$has_token_expired(token_info):
                token_info = self$refresh_access_token(token_info['refresh_token'])

        except IOError:
            pass
    return token_info
}

save_token_info <- function(self, token_info) {
    if self$cache_path:
        try:
            f = open(self$cache_path, 'w')
            f.write(json.dumps(token_info))
            f.close()
        except IOError:
            self$_warn("couldn't write token cache to " + self$cache_path)
            pass
}

is_scope_subset <- function(self, needle_scope, haystack_scope) {
    if needle_scope:
        needle_scope = set(needle_scope.split())
    if haystack_scope:
        haystack_scope = set(haystack_scope.split())

    return needle_scope <= haystack_scope
}

has_token_expired <- function(self, token_info) {
    return has_token_expired(token_info)
}

get_authorize_url(self, state=NA) {
    # """ Gets the URL to use to authorize this app
    # """
    payload = {'client_id': self$client_id,
                'response_type': 'code',
                'redirect_uri': self$redirect_uri}
    if self$scope:
        payload['scope'] = self$scope
    if state is NA:
        state = self$state
    if state is not NA:
        payload['state'] = state

    urlparams = urllibparse.urlencode(payload)

    return "%s?%s" % (self$OAUTH_AUTHORIZE_URL, urlparams)
}

parse_response_code <- function(self, url) {
    # """ Parse the response code in the given response url

    #     Parameters:
    #         - url - the response url
    # """

    try:
        return url.split("?code=")[1].split("&")[0]
    except IndexError:
        return NA
}

make_authorization_headers <- function(self) {
    return make_authorization_headers(self$client_id, self$client_secret)
}

get_access_token <- function(self, code) {
    # """ Gets the access token for the app given the code

    #     Parameters:
    #         - code - the response code
    # """
    payload = {'redirect_uri': self$redirect_uri,
                'code': code,
                'grant_type': 'authorization_code'}
    if self$scope:
        payload['scope'] = self$scope
    if self$state:
        payload['state'] = self$state

    headers = self$make_authorization_headers()

    response = requests.post(self$OAUTH_TOKEN_URL, data=payload,
        headers=headers, verify=True, proxies=self$proxies)
    if status_code(response) is not 200:
        raise SpotifyOauthError(response.reason)
    token_info = response.json()
    token_info = self$_add_custom_values_to_token_info(token_info)
    self$save_token_info(token_info)
    return token_info
}

normalize_scope <- function(self, scope) {
    if scope:
        scopes = scope.split()
        scopes.sort()
        return ' '.join(scopes)
    else:
        return NA
}

refresh_access_token <- function(self, refresh_token) {
    payload = { 'refresh_token': refresh_token,
                'grant_type': 'refresh_token'}

    headers = self$make_authorization_headers()

    response = requests.post(self$OAUTH_TOKEN_URL, data=payload,
        headers=headers, proxies=self$proxies)
    if status_code(response) != 200:
        if False:  # debugging code
            print('headers', headers)
            print('request', response.url)
        self$_warn("couldn't refresh token: code:%d reason:%s" \
            % (status_code(response), response.reason))
        return NA
    token_info = response.json()
    token_info = self$_add_custom_values_to_token_info(token_info)
    if not 'refresh_token' in token_info:
        token_info['refresh_token'] = refresh_token
    self$save_token_info(token_info)
    return token_info
}

add_custom_values_to_token_info <- function(self, token_info) {
    # '''
    # Store some values that aren't directly provided by a Web API
    # response.
    # '''
    token_info['expires_at'] = int(time.time()) + token_info['expires_in']
    token_info['scope'] = self$scope
    return token_info
}
warn <- function(self, msg) {
    print('warning:' + msg, file=sys.stderr)
}
