%%%-------------------------------------------------------------------
%%% @author Ammar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Sep 2022 5:21 PM
%%%-------------------------------------------------------------------
-module(project).
-author("Ammar").

%% API
-export([server/1, hasher/1, check/2, hasherloop/4, serverloop/1, starthasher/1, start_local_hashers/2]).


check(CoinNeeded, Orignal_str) ->
  ComparisonStr = "0000000000000000000000000000000000000000000000000000000000000000",
  New_string = string:left(ComparisonStr, CoinNeeded - 1) ++ "1" ++ string:sub_string(ComparisonStr, CoinNeeded + 1),
  Hash = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Orignal_str))]),
  {Hash < New_string, Hash}.

hasherloop(CoinNeeded, ServerNode, Orignal_String, Name) ->
  {Check, Hash} = check(CoinNeeded, Orignal_String),
  %%  return if hash found else keep looking
  case Check of
    true  ->
      {server, ServerNode} ! {hashfound, Orignal_String, Hash, self()};
    false ->
      NamedHash = Name ++ string:sub_string(Hash, length(Name) + 1),
      hasherloop(CoinNeeded, ServerNode, NamedHash, Name)
  end.

hasher(ServerNode) ->
  {server, ServerNode} ! {hasherinitiated, self()},
  receive
    {servermsg, CoinNeeded, String, Name} ->
      hasherloop(CoinNeeded, ServerNode, String, Name)
  end.

starthasher(ServerNode) ->
  spawn(project, hasher, [ServerNode]).

serverloop(CoinNeeded) ->
  receive
    {hasherinitiated, HasherNode} ->
      %% Generate string
      String = "aamjad;" ++ binary_to_list(base64:encode(crypto:strong_rand_bytes(12))),
      io:fwrite("Hasher Started:\n"),
      %% Send String and 0's requirement to new Hasher
      HasherNode ! {servermsg, CoinNeeded, String, "aamjad;"},
      serverloop(CoinNeeded);

    {hashfound, Orignal_str, Hash, HasherNode} ->
      HasherNode ! terminate,
      io:fwrite("\nOriginal Msg: " ++ Orignal_str ++ "\n"), io:fwrite("Hash: " ++ Hash ++ "\n"),
      {_, CPU_Time} = erlang:statistics(runtime),
      {_, Run_Time} = erlang:statistics(wall_clock),
      io:format("Total CPU Time: ~p \n", [CPU_Time]),
      io:format("Total Run Time: ~p \n", [Run_Time]),
      io:format("Total Cores Used: ~p \n", [CPU_Time/Run_Time]),
      unregister(server)
  end.

start_local_hashers(0, _SNode) -> done;
start_local_hashers(N, SNode) ->
  spawn(project, hasher, [SNode]),
  start_local_hashers(N - 1, SNode).

server(CoinNeeded) ->
  erlang:system_flag(scheduler_wall_time, true),
  SID = self(),
  register(server, SID),
  %% Starting N - 1 parallel local processes on server
  start_local_hashers(erlang:system_info(logical_processors_available) - 1, node(SID)),
  %% Server to monitor and respond to new incoming connectings
  serverloop(CoinNeeded).








%%For Linux:
%%Linux machine 1:
%%erl -name freebsd_node1@10.20.23.44 -setcookie 'mycookie'
%%Linux machine 2:
%%erl -name freebsd_node2@10.20.23.37 -setcookie 'mycookie'

%%Linux machine 1:
%%net_kernel:connect_node('freebsd_node2@10.20.23.37').
%%Linux machine 2:
%%net_kernel:connect_node('freebsd_node1@10.20.23.44').

%%------------------

%%Windows machine 1:
%%werl -name windows_node1@10.20.23.44 -setcookie 'mycookie'
%%Windows machine 2:
%%werl -name windows_node2@10.20.23.37 -setcookie 'mycookie'
%%Windows machine 1:
%%net_adm:ping('windows_node2@10.20.23.37').
%%Windows machine 2:
%%net_adm:ping('windows_node1@10.20.23.44').

%%nodes( ). on both windows machine in administrator mode


