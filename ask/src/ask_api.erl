%%%-------------------------------------------------------------------
%% @doc ask public API
%% @end
%%%-------------------------------------------------------------------

-module(ask_api).
-export([playlist/0, playlist/1]).

% API
playlist() ->
    file:list_dir_all(home_dir()).

playlist(N) ->
    {S, IoDevice} = file:open(home_dir() ++ N, [read]),
    case S of
        error -> {S, IoDevice};
        ok -> read_lines("", IoDevice)
    end.

home_dir() -> "/home/kb/Music/playlists/".

read_lines(Lines, IoDevice) ->
    {S, Data} = file:read_line(IoDevice),
    case S of
        error -> {S, Data};
        eof -> io:format(Lines),Lines;
        ok -> read_lines(Lines ++ Data ++ ",", IoDevice)
    end.