# '''
# Create a Spotify API object.
# :param auth: An authorization token (optional)
# :param requests_session:
#     A Requests session object or a truthy value to create one.
#     A falsy value disables sessions.
#     It should generally be a good idea to keep sessions enabled
#     for performance reasons (connection pooling).
# :param client_credentials_manager:
#     SpotifyClientCredentials object
# :param proxies:
#     Definition of proxies (optional)
# :param requests_timeout:
#     Tell Requests to stop waiting for a response after a given number of seconds
# '''
create_spotify_object <- function(auth=NA, requests_session=True,
        client_credentials_manager=NA, proxies=NA, requests_timeout=NA){
    obj <- list()
    obj$trace = FALSE  # Enable tracing?
    obj$trace_out = FALSE
    obj$max_get_retries = 10

    obj$prefix = 'https://api.spotify.com/v1/'
    obj$auth = auth
    obj$client_credentials_manager = client_credentials_manager
    obj$proxies = proxies
    obj$requests_timeout = requests_timeout

    # if isinstance(requests_session, requests.Session) {
    #     self._session = requests_session
    # else:
    #     if requests_session:  # Build a new session.
    #         self._session = requests.Session()
    #     else:  # Use the Requests API module as a "session".
    #         from requests import api
    #         self._session = api
    return(obj)
}

auth_headers <- function(spot_cnx) {
    if (!is.na(spot_cnx$auth)) {
        token = spot_cnx$auth
    } else if (!is.na(spot_cnx$client_credentials_manager) {
        token = spot_cnx$client_credentials_manager.get_access_token()
    } else {}
        return(NULL)
    }
    return(httr::add_headers(Authorization = paste0('Bearer ', token)))
}

# Not sure we will need all this - duplicates httr's functionalities?
# internal_call <- function(spot_cnx, method, url, payload, params) {
#     args = dict(params=params)
#     args["timeout"] = self.requests_timeout
#     if not url.startswith('http') {
#         url = self.prefix + url
#     headers = self.auth_headers()
#     headers['Content-Type'] = 'application/json'

#     if payload:
#         args["data"] = json.dumps(payload)

#     if self.trace_out:
#         print(url)
#     r = self._session.request(method, url, headers=headers, proxies=self.proxies, **args)

#     if self.trace:  # pragma: no cover
#         print()
#         print ('headers', headers)
#         print ('http status', r.status_code)
#         print(method, r.url)
#         if payload:
#             print("DATA", json.dumps(payload))

#     try:
#         r.raise_for_status()
#     except:
#         if r.text and len(r.text) > 0 and r.text != 'null':
#             raise SpotifyException(r.status_code,
#                 -1, '%s:\n %s' % (r.url, r.json()['error']['message']),
#                 headers=r.headers)
#         else:
#             raise SpotifyException(r.status_code,
#                 -1, '%s:\n %s' % (r.url, 'error'), headers=r.headers)
#     finally:
#         r.connection.close()
#     if r.text and len(r.text) > 0 and r.text != 'null':
#         results = r.json()
#         if self.trace:  # pragma: no cover
#             print('RESP', results)
#             print()
#         return results
#     else:
#         return None

# _get <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     retries = self.max_get_retries
#     delay = 1
#     while retries > 0:
#         try:
#             return self.internal_call('GET', url, payload, kwargs)
#         except SpotifyException as e:
#             retries -= 1
#             status = e.http_status
#             # 429 means we hit a rate limit, backoff
#             if status == 429 or (status >= 500 and status < 600) {
#                 if retries < 0:
#                     raise
#                 else:
#                     sleep_seconds = int(e.headers.get('Retry-After', delay))
#                     print ('retrying ...' + str(sleep_seconds) + 'secs')
#                     time.sleep(sleep_seconds + 1)
#                     delay += 1
#             else:
#                 raise
#         except Exception as e:
#             raise
#             print ('exception', str(e))
#             # some other exception. Requests have
#             # been know to throw a BadStatusLine exception
#             retries -= 1
#             if retries >= 0:
#                 sleep_seconds = int(e.headers.get('Retry-After', delay))
#                 print ('retrying ...' + str(delay) + 'secs')
#                 time.sleep(sleep_seconds + 1)
#                 delay += 1
#             else:
#                 raise

# _post <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('POST', url, payload, kwargs)

# _delete <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('DELETE', url, payload, kwargs)

# _put <- function(spot_cnx, url, args=NA, payload=NA, **kwargs) {
#     if args:
#         kwargs.update(args)
#     return self.internal_call('PUT', url, payload, kwargs)

next <- function(spot_cnx, result) {
    # ''' returns the next result given a paged result

    #     Parameters:
    #         - result - a previously returned paged result
    # '''
    if result['next']:
        return spot_cnx$_get(result['next'])
    else:
        return None
}

previous <- function(spot_cnx, result) {
    # ''' returns the previous result given a paged result

    #     Parameters:
    #         - result - a previously returned paged result
    # '''
    if result['previous']:
        return spot_cnx$_get(result['previous'])
    else:
        return None
}

warn_old <- function(spot_cnx, msg) {
    print('warning:' + msg, file=sys.stderr)
}

spot_warn <- function(spot_cnx, msg, *args) {
    print('warning:' + msg.format(*args), file=sys.stderr)
}

track <- function(spot_cnx, track_id) {
    # ''' returns a single track given the track's ID, URI or URL

    #     Parameters:
    #         - track_id - a spotify URI, URL or ID
    # '''

    trid = spot_cnx$_get_id('track', track_id)
    return spot_cnx$_get('tracks/' + trid)
}

tracks <- function(spot_cnx, tracks, market = as.character(NA)) {
    # ''' returns a list of tracks given a list of track IDs, URIs, or URLs

    #     Parameters:
    #         - tracks - a list of spotify URIs, URLs or IDs
    #         - market - an ISO 3166-1 alpha-2 country code.
    # '''

    tlist = [spot_cnx$_get_id('track', t) for t in tracks]
    return spot_cnx$_get('tracks/?ids=' + ','.join(tlist), market = market)
}

artist <- function(spot_cnx, artist_id) {
    # ''' returns a single artist given the artist's ID, URI or URL

    #     Parameters:
    #         - artist_id - an artist ID, URI or URL
    # '''

    trid = spot_cnx$_get_id('artist', artist_id)
    return spot_cnx$_get('artists/' + trid)
}

artists <- function(spot_cnx, artists) {
    # ''' returns a list of artists given the artist IDs, URIs, or URLs

    #     Parameters:
    #         - artists - a list of  artist IDs, URIs or URLs
    # '''

    tlist = [spot_cnx$_get_id('artist', a) for a in artists]
    return spot_cnx$_get('artists/?ids=' + ','.join(tlist))
}

artist_albums <- function(spot_cnx, artist_id, album_type=NA, country=NA, limit=20,
                    offset=0) {
    # ''' Get Spotify catalog information about an artist's albums

    #     Parameters:
    #         - artist_id - the artist ID, URI or URL
    #         - album_type - 'album', 'single', 'appears_on', 'compilation'
    #         - country - limit the response to one particular country.
    #         - limit  - the number of albums to return
    #         - offset - the index of the first album to return
    # '''

    trid = spot_cnx$_get_id('artist', artist_id)
    return spot_cnx$_get('artists/' + trid + '/albums', album_type=album_type,
                        country=country, limit=limit, offset=offset)
}

artist_top_tracks <- function(spot_cnx, artist_id, country='US') {
    # ''' Get Spotify catalog information about an artist's top 10 tracks
    #     by country.

    #     Parameters:
    #         - artist_id - the artist ID, URI or URL
    #         - country - limit the response to one particular country.
    # '''

    trid = spot_cnx$_get_id('artist', artist_id)
    return spot_cnx$_get('artists/' + trid + '/top-tracks', country=country)
}

artist_related_artists <- function(spot_cnx, artist_id) {
    # ''' Get Spotify catalog information about artists similar to an
    #     identified artist. Similarity is based on analysis of the
    #     Spotify community's listening history.

    #     Parameters:
    #         - artist_id - the artist ID, URI or URL
    # '''
    trid = spot_cnx$_get_id('artist', artist_id)
    return spot_cnx$_get('artists/' + trid + '/related-artists')
}

album <- function(spot_cnx, album_id) {
    # ''' returns a single album given the album's ID, URIs or URL

    #     Parameters:
    #         - album_id - the album ID, URI or URL
    # '''

    trid = spot_cnx$_get_id('album', album_id)
    return spot_cnx$_get('albums/' + trid)
}

album_tracks <- function(spot_cnx, album_id, limit=50, offset=0) {
    # ''' Get Spotify catalog information about an album's tracks

    #     Parameters:
    #         - album_id - the album ID, URI or URL
    #         - limit  - the number of items to return
    #         - offset - the index of the first item to return
    # '''

    trid = spot_cnx$_get_id('album', album_id)
    return spot_cnx$_get('albums/' + trid + '/tracks/', limit=limit,
                        offset=offset)
}

albums <- function(spot_cnx, albums) {
    # ''' returns a list of albums given the album IDs, URIs, or URLs

    #     Parameters:
    #         - albums - a list of  album IDs, URIs or URLs
    # '''

    tlist = [spot_cnx$_get_id('album', a) for a in albums]
    return spot_cnx$_get('albums/?ids=' + ','.join(tlist))
}

search <- function(spot_cnx, q, limit=10, offset=0, type='track', market=NA) {
    # ''' searches for an item

    #     Parameters:
    #         - q - the search query
    #         - limit  - the number of items to return
    #         - offset - the index of the first item to return
    #         - type - the type of item to return. One of 'artist', 'album',
    #                  'track' or 'playlist'
    #         - market - An ISO 3166-1 alpha-2 country code or the string from_token.
    # '''
    return spot_cnx$_get('search', q=q, limit=limit, offset=offset, type=type, market=market)
}

user <- function(spot_cnx, user) {
    # ''' Gets basic profile information about a Spotify User

    #     Parameters:
    #         - user - the id of the usr
    # '''
    return spot_cnx$_get('users/' + user)
}

current_user_playlists <- function(spot_cnx, limit=50, offset=0) {
    # """ Get current user playlists without required getting his profile
    #     Parameters:
    #         - limit  - the number of items to return
    #         - offset - the index of the first item to return
    # """
    return spot_cnx$_get("me/playlists", limit=limit, offset=offset)
}

user_playlists <- function(spot_cnx, user, limit=50, offset=0) {
    # ''' Gets playlists of a user

    #     Parameters:
    #         - user - the id of the usr
    #         - limit  - the number of items to return
    #         - offset - the index of the first item to return
    # '''
    return spot_cnx$_get("users/%s/playlists" % user, limit=limit,
                        offset=offset)
}

user_playlist <- function(spot_cnx, user, playlist_id=NA, fields=NA) {
    # ''' Gets playlist of a user
    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - fields - which fields to return
    # '''
    if playlist_id is None:
        return spot_cnx$_get("users/%s/starred" % (user), fields=fields)
    plid = spot_cnx$_get_id('playlist', playlist_id)
    return spot_cnx$_get("users/%s/playlists/%s" % (user, plid), fields=fields)
}

user_playlist_tracks <- function(spot_cnx, user, playlist_id=NA, fields=NA,
                            limit=100, offset=0, market=NA) {
    # ''' Get full details of the tracks of a playlist owned by a user.

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - fields - which fields to return
    #         - limit - the maximum number of tracks to return
    #         - offset - the index of the first track to return
    #         - market - an ISO 3166-1 alpha-2 country code.
    # '''
    plid = spot_cnx$_get_id('playlist', playlist_id)
    return spot_cnx$_get("users/%s/playlists/%s/tracks" % (user, plid),
                        limit=limit, offset=offset, fields=fields,
                        market=market)
}

user_playlist_create <- function(spot_cnx, user, name, public=True) {
    # ''' Creates a playlist for a user

    #     Parameters:
    #         - user - the id of the user
    #         - name - the name of the playlist
    #         - public - is the created playlist public
    # '''
    data = {'name': name, 'public': public}
    return spot_cnx$_post("users/%s/playlists" % (user,), payload=data)
}

user_playlist_change_details(
        self, user, playlist_id, name=NA, public=NA,
        collaborative=NA) {
    # ''' Changes a playlist's name and/or public/private state

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - name - optional name of the playlist
    #         - public - optional is the playlist public
    #         - collaborative - optional is the playlist collaborative
    # '''
    data = {}
    if isinstance(name, six.string_types) {
        data['name'] = name
    if isinstance(public, bool) {
        data['public'] = public
    if isinstance(collaborative, bool) {
        data['collaborative'] = collaborative
    return spot_cnx$_put("users/%s/playlists/%s" % (user, playlist_id),
                        payload=data)
}

user_playlist_unfollow <- function(spot_cnx, user, playlist_id) {
    # ''' Unfollows (deletes) a playlist for a user

    #     Parameters:
    #         - user - the id of the user
    #         - name - the name of the playlist
    # '''
    return spot_cnx$_delete("users/%s/playlists/%s/followers" % (user, playlist_id))
}

user_playlist_add_tracks <- function(spot_cnx, user, playlist_id, tracks,
                                position=NA) {
    # ''' Adds tracks to a playlist

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - tracks - a list of track URIs, URLs or IDs
    #         - position - the position to add the tracks
    # '''
    plid = spot_cnx$_get_id('playlist', playlist_id)
    ftracks = [spot_cnx$_get_uri('track', tid) for tid in tracks]
    return spot_cnx$_post("users/%s/playlists/%s/tracks" % (user, plid),
                        payload=ftracks, position=position)
}

user_playlist_replace_tracks <- function(spot_cnx, user, playlist_id, tracks) {
    # ''' Replace all tracks in a playlist

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - tracks - the list of track ids to add to the playlist
    # '''
    plid = spot_cnx$_get_id('playlist', playlist_id)
    ftracks = [spot_cnx$_get_uri('track', tid) for tid in tracks]
    payload = {"uris": ftracks}
    return spot_cnx$_put("users/%s/playlists/%s/tracks" % (user, plid),
                        payload=payload)
}

user_playlist_reorder_tracks(
        self, user, playlist_id, range_start, insert_before,
        range_length=1, snapshot_id=NA) {
    # ''' Reorder tracks in a playlist

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - range_start - the position of the first track to be reordered
    #         - range_length - optional the number of tracks to be reordered (default: 1)
    #         - insert_before - the position where the tracks should be inserted
    #         - snapshot_id - optional playlist's snapshot ID
    # '''
    plid = spot_cnx$_get_id('playlist', playlist_id)
    payload = {"range_start": range_start,
                "range_length": range_length,
                "insert_before": insert_before}
    if snapshot_id:
        payload["snapshot_id"] = snapshot_id
    return spot_cnx$_put("users/%s/playlists/%s/tracks" % (user, plid),
                        payload=payload)
}

user_playlist_remove_all_occurrences_of_tracks(
        self, user, playlist_id, tracks, snapshot_id=NA) {
    # ''' Removes all occurrences of the given tracks from the given playlist

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - tracks - the list of track ids to add to the playlist
    #         - snapshot_id - optional id of the playlist snapshot

    # '''

    plid = spot_cnx$_get_id('playlist', playlist_id)
    ftracks = [spot_cnx$_get_uri('track', tid) for tid in tracks]
    payload = {"tracks": [{"uri": track} for track in ftracks]}
    if snapshot_id:
        payload["snapshot_id"] = snapshot_id
    return spot_cnx$_delete("users/%s/playlists/%s/tracks" % (user, plid),
                        payload=payload)
}

user_playlist_remove_specific_occurrences_of_tracks(
        self, user, playlist_id, tracks, snapshot_id=NA) {
    # ''' Removes all occurrences of the given tracks from the given playlist

    #     Parameters:
    #         - user - the id of the user
    #         - playlist_id - the id of the playlist
    #         - tracks - an array of objects containing Spotify URIs of the tracks to remove with their current positions in the playlist.  For example:
    #             [  { "uri":"4iV5W9uYEdYUVa79Axb7Rh", "positions":[2] },
    #                { "uri":"1301WleyT98MSxVHPZCA6M", "positions":[7] } ]
    #         - snapshot_id - optional id of the playlist snapshot
    # '''

    plid = spot_cnx$_get_id('playlist', playlist_id)
    ftracks = []
    for tr in tracks:
        ftracks.append({
            "uri": spot_cnx$_get_uri("track", tr["uri"]),
            "positions": tr["positions"],
        })
    payload = {"tracks": ftracks}
    if snapshot_id:
        payload["snapshot_id"] = snapshot_id
    return spot_cnx$_delete("users/%s/playlists/%s/tracks" % (user, plid),
                        payload=payload)
}

user_playlist_follow_playlist <- function(spot_cnx, playlist_owner_id, playlist_id) {
    # '''
    # Add the current authenticated user as a follower of a playlist.

    # Parameters:
    #     - playlist_owner_id - the user id of the playlist owner
    #     - playlist_id - the id of the playlist

    # '''
    return spot_cnx$_put("users/{}/playlists/{}/followers".format(playlist_owner_id, playlist_id))
}

user_playlist_is_following <- function(spot_cnx, playlist_owner_id, playlist_id, user_ids) {
    # '''
    # Check to see if the given users are following the given playlist

    # Parameters:
    #     - playlist_owner_id - the user id of the playlist owner
    #     - playlist_id - the id of the playlist
    #     - user_ids - the ids of the users that you want to check to see if they follow the playlist. Maximum: 5 ids.

    # '''
    return spot_cnx$_get("users/{}/playlists/{}/followers/contains?ids={}".format(playlist_owner_id, playlist_id, ','.join(user_ids)))
}

me <- function(spot_cnx) {
    # ''' Get detailed profile information about the current user.
    #     An alias for the 'current_user' method.
    # '''
    return spot_cnx$_get('me/')
}

current_user <- function(spot_cnx) {
    # ''' Get detailed profile information about the current user.
    #     An alias for the 'me' method.
    # '''
    return spot_cnx$me()
}

current_user_saved_albums <- function(spot_cnx, limit=20, offset=0) {
    # ''' Gets a list of the albums saved in the current authorized user's
    #     "Your Music" library

    #     Parameters:
    #         - limit - the number of albums to return
    #         - offset - the index of the first album to return

    # '''
    return spot_cnx$_get('me/albums', limit=limit, offset=offset)
}

current_user_saved_tracks <- function(spot_cnx, limit=20, offset=0) {
    # ''' Gets a list of the tracks saved in the current authorized user's
    #     "Your Music" library

    #     Parameters:
    #         - limit - the number of tracks to return
    #         - offset - the index of the first track to return

    # '''
    return spot_cnx$_get('me/tracks', limit=limit, offset=offset)
}

current_user_followed_artists <- function(spot_cnx, limit=20, after=NA) {
    # ''' Gets a list of the artists followed by the current authorized user

    #     Parameters:
    #         - limit - the number of tracks to return
    #         - after - ghe last artist ID retrieved from the previous request

    # '''
    return spot_cnx$_get('me/following', type='artist', limit=limit,
                        after=after)
}

current_user_saved_tracks_delete <- function(spot_cnx, tracks=NA) {
    # ''' Remove one or more tracks from the current user's
    #     "Your Music" library.

    #     Parameters:
    #         - tracks - a list of track URIs, URLs or IDs
    # '''
    tlist = []
    if tracks is not None:
        tlist = [spot_cnx$_get_id('track', t) for t in tracks]
    return spot_cnx$_delete('me/tracks/?ids=' + ','.join(tlist))
}

current_user_saved_tracks_contains <- function(spot_cnx, tracks=NA) {
    # ''' Check if one or more tracks is already saved in
    #     the current Spotify user’s “Your Music” library.

    #     Parameters:
    #         - tracks - a list of track URIs, URLs or IDs
    # '''
    tlist = []
    if tracks is not None:
        tlist = [spot_cnx$_get_id('track', t) for t in tracks]
    return spot_cnx$_get('me/tracks/contains?ids=' + ','.join(tlist))
}

current_user_saved_tracks_add <- function(spot_cnx, tracks=NA) {
    # ''' Add one or more tracks to the current user's
    #     "Your Music" library.

    #     Parameters:
    #         - tracks - a list of track URIs, URLs or IDs
    # '''
    tlist = []
    if tracks is not None:
        tlist = [spot_cnx$_get_id('track', t) for t in tracks]
    return spot_cnx$_put('me/tracks/?ids=' + ','.join(tlist))
}

current_user_top_artists <- function(spot_cnx, limit=20, offset=0,
                                time_range='medium_term') {
    # ''' Get the current user's top artists

    #     Parameters:
    #         - limit - the number of entities to return
    #         - offset - the index of the first entity to return
    #         - time_range - Over what time frame are the affinities computed
    #           Valid-values: short_term, medium_term, long_term
    # '''
    return spot_cnx$_get('me/top/artists', time_range=time_range, limit=limit,
                        offset=offset)
}

current_user_top_tracks <- function(spot_cnx, limit=20, offset=0,
                            time_range='medium_term') {
    # ''' Get the current user's top tracks

    #     Parameters:
    #         - limit - the number of entities to return
    #         - offset - the index of the first entity to return
    #         - time_range - Over what time frame are the affinities computed
    #           Valid-values: short_term, medium_term, long_term
    # '''
    return spot_cnx$_get('me/top/tracks', time_range=time_range, limit=limit,
                        offset=offset)
}

current_user_saved_albums_add <- function(spot_cnx, albums=[]) {
    # ''' Add one or more albums to the current user's
    #     "Your Music" library.
    #     Parameters:
    #         - albums - a list of album URIs, URLs or IDs
    # '''
    alist = [spot_cnx$_get_id('album', a) for a in albums]
    r = spot_cnx$_put('me/albums?ids=' + ','.join(alist))
    return r
}

featured_playlists <- function(spot_cnx, locale=NA, country=NA, timestamp=NA,
                        limit=20, offset=0) {
    # ''' Get a list of Spotify featured playlists

    #     Parameters:
    #         - locale - The desired language, consisting of a lowercase ISO
    #           639 language code and an uppercase ISO 3166-1 alpha-2 country
    #           code, joined by an underscore.

    #         - country - An ISO 3166-1 alpha-2 country code.

    #         - timestamp - A timestamp in ISO 8601 format:
    #           yyyy-MM-ddTHH:mm:ss. Use this parameter to specify the user's
    #           local time to get results tailored for that specific date and
    #           time in the day

    #         - limit - The maximum number of items to return. Default: 20.
    #           Minimum: 1. Maximum: 50

    #         - offset - The index of the first item to return. Default: 0
    #           (the first object). Use with limit to get the next set of
    #           items.
    # '''
    return spot_cnx$_get('browse/featured-playlists', locale=locale,
                        country=country, timestamp=timestamp, limit=limit,
                        offset=offset)
}

new_releases <- function(spot_cnx, country=NA, limit=20, offset=0) {
    # ''' Get a list of new album releases featured in Spotify

    #     Parameters:
    #         - country - An ISO 3166-1 alpha-2 country code.

    #         - limit - The maximum number of items to return. Default: 20.
    #           Minimum: 1. Maximum: 50

    #         - offset - The index of the first item to return. Default: 0
    #           (the first object). Use with limit to get the next set of
    #           items.
    # '''
    return spot_cnx$_get('browse/new-releases', country=country, limit=limit,
                        offset=offset)
}

categories <- function(spot_cnx, country=NA, locale=NA, limit=20, offset=0) {
    # ''' Get a list of new album releases featured in Spotify

    #     Parameters:
    #         - country - An ISO 3166-1 alpha-2 country code.
    #         - locale - The desired language, consisting of an ISO 639
    #           language code and an ISO 3166-1 alpha-2 country code, joined
    #           by an underscore.

    #         - limit - The maximum number of items to return. Default: 20.
    #           Minimum: 1. Maximum: 50

    #         - offset - The index of the first item to return. Default: 0
    #           (the first object). Use with limit to get the next set of
    #           items.
    # '''
    return spot_cnx$_get('browse/categories', country=country, locale=locale,
                        limit=limit, offset=offset)
}

category_playlists <- function(spot_cnx, category_id=NA, country=NA, limit=20,
                        offset=0) {
    # ''' Get a list of new album releases featured in Spotify

    #     Parameters:
    #         - category_id - The Spotify category ID for the category.

    #         - country - An ISO 3166-1 alpha-2 country code.

    #         - limit - The maximum number of items to return. Default: 20.
    #           Minimum: 1. Maximum: 50

    #         - offset - The index of the first item to return. Default: 0
    #           (the first object). Use with limit to get the next set of
    #           items.
    # '''
    return spot_cnx$_get('browse/categories/' + category_id + '/playlists',
                        country=country, limit=limit, offset=offset)
}

recommendations <- function(spot_cnx, seed_artists=NA, seed_genres=NA,
                    seed_tracks=NA, limit=20, country=NA, **kwargs) {
    # ''' Get a list of recommended tracks for one to five seeds.

    #     Parameters:
    #         - seed_artists - a list of artist IDs, URIs or URLs

    #         - seed_tracks - a list of artist IDs, URIs or URLs

    #         - seed_genres - a list of genre names. Available genres for
    #           recommendations can be found by calling recommendation_genre_seeds

    #         - country - An ISO 3166-1 alpha-2 country code. If provided, all
    #           results will be playable in this country.

    #         - limit - The maximum number of items to return. Default: 20.
    #           Minimum: 1. Maximum: 100

    #         - min/max/target_<attribute> - For the tuneable track attributes listed
    #           in the documentation, these values provide filters and targeting on
    #           results.
    # '''
    params = dict(limit=limit)
    if seed_artists:
        params['seed_artists'] = ','.join(
            [spot_cnx$_get_id('artist', a) for a in seed_artists])
    if seed_genres:
        params['seed_genres'] = ','.join(seed_genres)
    if seed_tracks:
        params['seed_tracks'] = ','.join(
            [spot_cnx$_get_id('track', t) for t in seed_tracks])
    if country:
        params['market'] = country

    for attribute in ["acousticness", "danceability", "duration_ms",
                        "energy", "instrumentalness", "key", "liveness",
                        "loudness", "mode", "popularity", "speechiness",
                        "tempo", "time_signature", "valence"]:
        for prefix in ["min_", "max_", "target_"]:
            param = prefix + attribute
            if param in kwargs:
                params[param] = kwargs[param]
    return spot_cnx$_get('recommendations', **params)
}

recommendation_genre_seeds <- function(spot_cnx) {
    # ''' Get a list of genres available for the recommendations function.
    # '''
    return spot_cnx$_get('recommendations/available-genre-seeds')
}

audio_analysis <- function(spot_cnx, track_id) {
    # ''' Get audio analysis for a track based upon its Spotify ID
    #     Parameters:
    #         - track_id - a track URI, URL or ID
    # '''
    trid = spot_cnx$_get_id('track', track_id)
    return spot_cnx$_get('audio-analysis/' + trid)
}

audio_features <- function(spot_cnx, tracks=[]) {
    # ''' Get audio features for one or multiple tracks based upon their Spotify IDs
    #     Parameters:
    #         - tracks - a list of track URIs, URLs or IDs, maximum: 50 ids
    # '''
    if isinstance(tracks, str) {
        trackid = spot_cnx$_get_id('track', tracks)
        results = spot_cnx$_get('audio-features/?ids=' + trackid)
    else:
        tlist = [spot_cnx$_get_id('track', t) for t in tracks]
        results = spot_cnx$_get('audio-features/?ids=' + ','.join(tlist))
    # the response has changed, look for the new style first, and if
    # its not there, fallback on the old style
    if 'audio_features' in results:
        return results['audio_features']
    else:
        return results
}

audio_analysis <- function(spot_cnx, id) {
    # ''' Get audio analysis for a track based upon its Spotify ID
    #     Parameters:
    #         - id - a track URIs, URLs or IDs
    # '''
    id = spot_cnx$_get_id('track', id)
    return spot_cnx$_get('audio-analysis/'+id)
}

_get_id <- function(spot_cnx, type, id) {
    fields = id.split(':')
    if len(fields) >= 3:
        if type != fields[-2]:
            spot_cnx$_warn('expected id of type %s but found type %s %s',
                        type, fields[-2], id)
        return fields[-1]
    fields = id.split('/')
    if len(fields) >= 3:
        itype = fields[-2]
        if type != itype:
            spot_cnx$_warn('expected id of type %s but found type %s %s',
                        type, itype, id)
        return fields[-1]
    return id
}

_get_uri <- function(spot_cnx, type, id) {
    return 'spotify:' + type + ":" + spot_cnx$_get_id(type, id)
}
