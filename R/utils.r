
# ''' prompts the user to login if necessary and returns
#     the user token suitable for use with the spotipy.Spotify 
#     constructor

#     Parameters:

#      - username - the Spotify username
#      - scope - the desired scope of the request
#      - client_id - the client id of your app
#      - client_secret - the client secret of your app
#      - redirect_uri - the redirect URI of your app

# '''
prompt_for_user_token <- function(username, scope=NA, client_id = NA,
        client_secret = NA, redirect_uri = NA) {
    if is.na(client_id) {
        client_id = Sys.getenv('SPOTIPY_CLIENT_ID')
    }
    if is.na(client_secret) {
        client_secret = Sys.getenv('SPOTIPY_CLIENT_SECRET')
    }
    if is.na(redirect_uri) {
        redirect_uri = Sys.getenv('SPOTIPY_REDIRECT_URI')
    }
    if is.na(client_id) {
        message("
            You need to set your Spotify API credentials. You can do this by
            setting environment variables like so:

            export SPOTIPY_CLIENT_ID='your-spotify-client-id'
            export SPOTIPY_CLIENT_SECRET='your-spotify-client-secret'
            export SPOTIPY_REDIRECT_URI='your-app-redirect-url'

            Get your credentials at     
                https://developer.spotify.com/my-applications
        ")
        raise spotipy.SpotifyException(550, -1, 'no credentials set')
    }
    sp_oauth = oauth2.SpotifyOAuth(client_id, client_secret, redirect_uri, 
        scope=scope, cache_path=".cache-" + username )

    # try to get a valid token for this user, from the cache,
    # if not in the cache, the create a new (this will send
    # the user to a web page where they can authorize this app)

    token_info = sp_oauth.get_cached_token()

    if is.na(token_info) {
        message("
            User authentication requires interaction with your
            web browser. Once you enter your credentials and
            give authorization, you will be redirected to
            a url.  Paste that url you were directed to to
            complete the authorization.
        ")
        auth_url = sp_oauth.get_authorize_url()
        try:
            webbrowser.open(auth_url)
            print("Opened %s in your browser" % auth_url)
        except:
            print("Please navigate here: %s" % auth_url)

        print()
        print()
        try:
            response = raw_input("Enter the URL you were redirected to: ")
        except NameError:
            response = input("Enter the URL you were redirected to: ")

        print()
        print() 

        code = sp_oauth.parse_response_code(response)
        token_info = sp_oauth.get_access_token(code)
    }
    # Auth'ed API request
    if token_info:
        return token_info['access_token']
    else:
        return NA

}