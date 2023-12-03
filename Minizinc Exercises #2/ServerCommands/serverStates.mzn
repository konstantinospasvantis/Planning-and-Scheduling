include "globals.mzn";
%% Server commands as an enumerated type.
enum  COMMANDS = {stay_off,initilize,runserv,shutdown,download,update};
%% Number of Servers and the associated set.
int: no_servers = 4;
set of int: SERVERS = 1..no_servers;
%% number of time_points to schedule.
int: no_time_points = 7;
set of int: TIME = 1..no_time_points;

%%% Decision Vars needed
array[SERVERS,TIME] of var COMMANDS: server_commands;
var int : max;

%%%% Add your code here.
% We have 4 states, each of them described in report
int: ns = 4;
set of int : STATE = 1..ns;

% Declaring the array 
array[SERVERS,COMMANDS] of int: allowed = 
                        %stay_off  initialize runserv shutdown download update 
                        [|1,          2,         0,      0,       0,      0
                         |0,          0,         2,      1,       3,      0
                         |0,          0,         3,      0,       0,      4
                         |0,          0,         0,      1,       0,      0|];


% Passing in the regular constraint
constraint forall(s in SERVERS) 
 (regular(row(server_commands,s),ns,card(COMMANDS), allowed, 1, STATE));                                                                                                                     

% Using function count to say that each server must be updated only once 
constraint forall(s in SERVERS)
 (sum([server_commands[s,d] == update | d in TIME]) == 1);

% Now for the constraint about simultaneous downloads 
constraint forall(d in TIME)
 (sum([server_commands[s,d] == download | s in SERVERS]) < 2);

% Now we say that we want each time_point to have at least one opperation runserv, except day number one, so we must iterate from day 2
constraint forall(d in 2..no_time_points)
 (sum([server_commands[s,d] == runserv | s in SERVERS]) >= 1);

% We say that max is the number of total runserv, when we iterate over the entire the array
constraint max = count([server_commands[s,t] | s in SERVERS, t in TIME], runserv);

% Last, we want to maximize the count of runserv.                                                                
solve maximize max;

%%% DO NOT CHANGE THIS LINE
output ["server_commands=array2d(\(SERVERS),\(TIME),\(server_commands)); \n max=\(max);"];
