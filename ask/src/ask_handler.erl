%%%-------------------------------------------------------------------
%% @doc ask handler
%% @end
%%%-------------------------------------------------------------------

-module(ask_handler).

-export([init/2,content_types_provided/2]).
-export([get/2]).

-record(state, {op, response}).

init(Req, Opts) ->
	[{op, Op}] = Opts,
	State = #state{op=Op, response=none},
	{cowboy_rest, Req, State}.

content_types_provided(Req, State) ->
	{[
		{<<"text/plain">>, get}
	], Req, State}.

get(Req, State) when State#state.op == get ->
	N = cowboy_req:binding(name, Req),
	case N of
		_ -> handle_response(ask_api:playlist(N), Req, State);
		undefined -> handle_response(ask_api:playlist(), Req, State)
	end.

handle_response({error, Reason}, Req, State) -> {parse_resp({error, Reason}), Req, State};
handle_response({ok, Filenames}, Req, State) -> {parse_resp(Filenames, ""), Req, State}.

parse_resp({error, _Reason}) -> "Server error".
parse_resp([], Acc) -> Acc;
parse_resp([H|T], Acc) -> parse_resp(T, Acc ++ H ++ ",").