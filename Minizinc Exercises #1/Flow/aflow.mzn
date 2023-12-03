include "globals.mzn";
% number of devices
int: ndevices;
set of int: DEVICES = 1..ndevices;
%% the flow levels
set of 1..2: FLOWLEVELS = {1,2};
%% Two dimensional array stating the height of connections in devices (panels)
array[DEVICES,FLOWLEVELS] of int: device_levels;
 
 
%%% add your code here
%We store wich port is first and wich second of each row from device_levels
array[DEVICES] of var 1..2: second_port;
array[DEVICES] of var 1..2: first_port;

%The above matrices must have different elements in the same index
constraint forall (t in DEVICES) (first_port[t]!=second_port[t]);

%FInally, we caclulate the total_length by adding the device level of the first device's first port, and the sum of absolute differences between the device_levels of the first port of a device, and the device level of the second port of its next device. 
var int:total_length; 
constraint total_length = device_levels[1,first_port[1]] + sum(t in DEVICES where t < ndevices)
                                                               (abs(device_levels[t+1,first_port[t+1]] -device_levels[t,second_port[t]]));

%We want to minimize the total_length
solve minimize total_length;
 
%%% Do not change this line
output ["total_length =\(total_length);"]