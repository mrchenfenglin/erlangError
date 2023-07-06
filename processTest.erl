%% @author Administrator
%% @doc @todo Add description to armyMod.

-module(processTest).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1,
testProcess/1]).

-record(state,{i = 0,time = 0}).


testProcess(N) when N < 1->
    ok;
testProcess(N) ->
    start(N),
    testProcess(N-1).


%% ====================================================================
%% Behavioural functions
%% ====================================================================

start(N) ->
    {ok, Pid} = gen_server:start(?MODULE, [N], []),
    Pid.

init([N]) ->
    %% 125ms 
    erlang:send_after(125, self(), {'loop', 0}),
    erlang:send_after(1000, self(), {'fightLoop'}),
    Time = long_unixtime(),
    State = #state{i = N,time = Time},
    {ok, State}.

handle_call(_Info, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info({'loop', Last}, State = #state{i = I,time = Time}) ->
    Last2 = Last + 1,
    Time2 = long_unixtime(),
    LoopTime = 25,
    case I == 1 andalso Last2 rem (1000 div LoopTime) of
        0 ->
            io:format("use time:~w~n",[Time2 - Time]),
            State2 = State#state{time = Time2};
        _ ->
            State2 = State
    end,
    erlang:send_after(LoopTime, self(), {'loop', Last2}),
    {noreply, State2};

handle_info({'fightLoop'}, State) ->
    erlang:send_after(1000, self(), {'fightLoop'}),
    {noreply, State}.


%% ====================================================================
terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


long_unixtime() ->
    {M,S,MM} = os:timestamp(),
    M * (1000000 * 1000) + S * 1000 + MM div 1000.
