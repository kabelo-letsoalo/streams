%%%-------------------------------------------------------------------
%% @doc ask handler
%% @end
%%%-------------------------------------------------------------------

-module(ask_handler).

-export([init/2]).
-export([content_types_provided/2]).
-export([all_playlists/2]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
	{[{<<"text/plain">>, all_playlists}], Req, State}.

all_playlists(Req, State) ->
	{parse_resp("", 1, ask_app:list_all_playlists()), Req, State}.


parse_resp(_, _, {error, Reason}) -> Reason;
parse_resp(Resp, I, {ok, Filenames}) when I == length(Filenames) -> Resp;
parse_resp(Resp, I, {ok, Filenames}) when I /= length(Filenames) -> parse_resp(Resp  ++ "," ++ Resp, I + 1, {ok, Filenames}).