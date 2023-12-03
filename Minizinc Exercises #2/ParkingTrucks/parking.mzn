%%% Trucks to Lanes
include "globals.mzn";
%%% Parking %%%%

% Total number of lanes
int: number_of_parking_lanes;
% Length of each parking_lane.
int: parking_lane_length;
% parking_lane Types
enum LANETYPES = {laneA, laneB};
array[LANES] of LANETYPES: parking_lane_type;

%% TRUCKS
% Total number of trucks
int: number_of_trucks;
array[TRUCKS] of int: truck_length;
array[TRUCKS] of LANETYPES: truck_type;

%%% the necessary sets
set of int: TRUCKS = 1..number_of_trucks;
set of int: LANES = 1..number_of_parking_lanes;

%%% At whick parking lane is each truck parked.
array[TRUCKS] of var LANES: at_parking_lane;
%%% number of lanes used. 
var LANES: used_lanes;

%%%% Add your code here
% Creating allocations to know in which lane we can place a truck
array[TRUCKS] of var set of LANES: allocations;
constraint forall( i in TRUCKS)( allocations[i] = {j| j in LANES where truck_type[i] = parking_lane_type[j]});

% The array at_parking_lane must take values from each set used in allocations for each truck
constraint forall(i in TRUCKS)(at_parking_lane[i] in allocations[i]);

% The sum of the length of trucks in a lane must be lower than the total lane length
constraint forall(i in LANES) ( sum( [truck_length[j]| j in TRUCKS where at_parking_lane[j] == i]) <= parking_lane_length); 

% We create a set that holds the unique numbers of lanes used
var set of int: lanes_used = {i |i in at_parking_lane};

% And now we say that the number of lanes we used is equal to the cardinality of the above set
constraint used_lanes = card(lanes_used); 

% Finally we want to minimize the used_lanes
solve minimize used_lanes;


%%% Output
output ["at_parking_lane = \(at_parking_lane); \nused_lanes = \(used_lanes);"];

