%% Nuclear Plants
include "globals.mzn";

int : no_plants;
int : problems;
set of int: PLANTS = 1..no_plants;
set of int: PROBLEMS = 1..problems;
set of int: TIME = 0..100;
array[PLANTS] of int: supply;
array[PLANTS] of int: needs;
array[PROBLEMS,1..2] of PLANTS: not_sim; 

%Your code here
%Creating the necessary arrays for the problem
array[PLANTS] of var int: durations;
array[PLANTS] of var TIME: start;
array[PLANTS] of var TIME: end;

%The variable we want to minimize
var int: end_of_supply;

int: total_supply = 120;

%The duration array will be the result that comes from deviding an element of needs with the same element from supply,
% because, by the time we start providing water supply in a factory, we can't stop. 
constraint forall(m in PLANTS)(durations[m] = needs[m]/supply[m]);

% Creating the 'end' array
constraint forall(m in PLANTS) (end[m] = start[m] + durations[m]);

%We must use the cumulative function, as long as there is a max cap of water flow we want to provide simultaneously
constraint cumulative(start,durations,supply,total_supply);   

%We must use the disjunctive function because we cant provide with water, the factories that are presented in a row of the array not_sim. 
%With this constraint we iterate through every row of not_sim, to denote that we can't have simultaneous flows, using array notation to pick the correct elements from every row
constraint forall (m in PROBLEMS )(disjunctive([start[not_sim[m,j]]|j in 1..2],[durations[not_sim[m,j]] | j in 1..2]));

% Finally, we create the variable end_of_supply which is the max cxompletition time and we want to minimize it
constraint end_of_supply = max(end);
solve minimize end_of_supply;

%Output Code
output ["starts = \(start); \nend_of_supply = \(end_of_supply);"];


