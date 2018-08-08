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
	{Status, Content} = ask_app:list_all_playlists("/home/kb/Music/playlists"),
	case Status == error of
		true -> {parse_resp(), Req, State};
		false -> {parse_resp(Content, ""), Req, State}
	end.


parse_resp() -> "Server error".
parse_resp([], Msg) -> Msg;
parse_resp([H|T], Msg) -> parse_resp(T, Msg ++ H ++ ",").