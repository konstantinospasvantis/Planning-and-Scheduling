%%% Compilation
include "globals.mzn";
%% The numbner of servers and the associated set.
int : servers;
set of int: SERVERS = 1..servers;

%% Enum type of Files to be compiled.
enum FILES;
%% The time needed for compilation and replication
enum TIME_NEEDED = {COMP,REPL}; 
array[FILES,TIME_NEEDED] of int: timeTo;
%% deadlines 
array[FILES] of int: deadline;

%% dependencies between files.
array[FILES] of set of FILES: dependencies;


%%%% Add your code here
% Create 2 arrays, duration and send_time, from the two columns of array timeTo
array[FILES] of int: durations = [timeTo[i,COMP] | i in FILES] ;
array[FILES] of int: send_time = [timeTo[i,REPL] | i in FILES];


set of int : TIME = 0..100;

%% Creating the arrays that contain the start and end time for each file
array[FILES] of var TIME: start;
array[FILES] of var TIME: end;

% Passing in our constraints 
% First of all the most basic constraint in time programming
constraint forall(j in FILES)(end[j] = start[j] + durations[j]);

% Creating the in_server array that contains the number of the server the file will be compiled
array[FILES] of var SERVERS: in_server;

% For each server, we have to satisfy the disjunctive constraint because a server can compile only one file at a specific time
constraint forall(s in SERVERS) (disjunctive( [start[j]| j in FILES where in_server[j]=s], [durations[j]| j in FILES ]));
 

% Finally we have to pass constraints that takes into account the dependencies of each file
% It is obvious that a file must start compiling after all of its dependency files end compiling
constraint forall(f in FILES)( forall(d in dependencies[f])(start[f] >= end[d])) ;

% And now the constraint about dependencies. We say that a file must begin compiling after all of its dependencies end compiling , if they are on the same server, or else the compilation must begin after the end time of its dependencies + the time needed for them to arrive on the same server
constraint forall(f in FILES)(forall(d in dependencies[f])(if in_server[f]!=in_server[d] then start[f]>= end[d]+ send_time[d] else start[f] >= end[d] endif));


% Creating the variable points that measures the sum of lateness that is defied as lateness = end - deadline, and we want to minimize it
var int: points;
constraint points = sum([end[i] - deadline[i]|i in FILES]);

% Basic
%solve minimize points;


%Different Heuristics #1
% solve ::seq_search(
%          [int_search([in_server[f]|f in FILES], input_order, indomain_random),
%           int_search([start[f]|f in FILES], first_fail, indomain_split)])
%       minimize points;

%Different Heuristics #2
solve ::seq_search(
         [int_search([in_server[f]|f in FILES], first_fail, indomain_median),
          int_search([start[f]|f in FILES], smallest, indomain_reverse_split)])
      minimize points;


%%% Do NOT change the following
output ["points = \(points) ; \n" ]++
       ["start = \(start) ; \n"] ++
       ["in_server = \(in_server) ;"]
       ;
