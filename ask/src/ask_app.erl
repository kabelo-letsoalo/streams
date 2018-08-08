%%%-------------------------------------------------------------------
%% @doc ask public API
%% @end
%%%-------------------------------------------------------------------

-module(ask_app).
-import(file,[list_dir_all/1]).

-behaviour(application).
-export([start/2, stop/1, list_all_playlists/1]).

%% Application callbacks
start(_StartType, _StartArgs) ->
    start_http_server(),
    ask_sup:start_link().

stop(_State) ->
    ok.

% API
list_all_playlists(Playlist) ->
    file:list_dir_all(Playlist).

%% Internal functions
start_http_server() ->
    Dispatch = cowboy_router:compile([
		{'_', [
			{"/", ask_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 3000}], #{
		env => #{dispatch => Dispatch}
    }).
