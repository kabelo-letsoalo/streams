%%%-------------------------------------------------------------------
%% @doc ask public API
%% @end
%%%-------------------------------------------------------------------

-module(ask_app).

-behaviour(application).
%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    start_server(),
    ask_sup:start_link().

stop(_State) ->
    ok.

%% Internal functions
start_server() ->
    Dispatch = cowboy_router:compile([
		{'_', [
			{"/", ask_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 3000}], #{
		env => #{dispatch => Dispatch}
    }).
