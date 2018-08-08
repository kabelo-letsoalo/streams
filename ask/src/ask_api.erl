%%%-------------------------------------------------------------------
%% @doc ask public API
%% @end
%%%-------------------------------------------------------------------

-module(ask_api).
-export([playlist/0, playlist/1]).

% API
playlist() ->
    case playlist_dir() of
        {error, R} -> {error, R};
        {ok, Dir} -> file:list_dir_all(Dir)
    end.

playlist(N) ->
    case playlist_dir() of
        {error, R} -> {error, R};
        {ok, Dir} -> read_lines("", file:open(Dir ++ binary_to_list(N), [read]))
    end.

playlist_dir() ->
    case file:get_cwd() of
        {error, R} -> {error, R};
        {ok, Dir} -> {ok, Dir ++ "/resource/playlists/"}
    end.

read_lines(Acc, {_, IoDevice}) ->
    case file:read_line(IoDevice) of
        eof -> Acc;
        {error, R} -> {error, R};
        {ok, Line} -> read_lines(Acc ++ Line ++ ",", {ok, IoDevice})
    end.
