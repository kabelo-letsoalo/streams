%%%-------------------------------------------------------------------
%% @doc ask app
%% @end
%%%-------------------------------------------------------------------

-module(ask_app).
-behaviour(application).
-export([start/2, stop/1]).

%% Application callbacks
start(_StartType, _StartArgs) ->
    start_http_server(),
    ask_sup:start_link().

stop(_State) ->
    ok.

%% Internal functions
start_http_server() ->
    Dispatch = cowboy_router:compile([
		{'_', [
			{"/playlists/[:name]", ask_handler, [{op, list}]}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 3000}], #{
		env => #{dispatch => Dispatch}
    }).
