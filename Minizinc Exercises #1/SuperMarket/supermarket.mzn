include "alldifferent_except_0.mzn";

%% The number of offers
int: ofrs = 10;
set of int: OFFERS = 0..ofrs; 
%% The set of categories 
set of int: CATEGORIES = 1..7;

set of int:BUYS = 1..4;
int : max_money = 100;

%% There is always a "dummy offer" ({}) with 0 quality and 0 price.
array[OFFERS] of set of int : package = array1d(OFFERS,[{},{1,2,3},{4,7},{3,6},{1,4,5},{3,4,7},{1,2,5},{4,6},{3,7},{3,7,5},{2,3}]);
array[OFFERS] of  int: package_price  =  array1d(OFFERS,[0,10,5,15,20,23,40,12,45,54,20]);
array[OFFERS] of int: package_quality = array1d(OFFERS,[0,5,2,3,2,3,1,4,5,6,5]);

%%% The decision variables required (see end of the file).
array[BUYS] of var OFFERS: basket;
var int: quality;
var int: price;

%%% Add your code here
%All packages must be different 
include "all_different.mzn";
constraint all_different(basket);

%Two new arrays including the cost and and the quality of each package that we are buying
array[BUYS] of var int: cost_of_packages;
array[BUYS] of var int: quality_of_packages;

%Giving each new array the appropriate value
constraint forall(t in BUYS)
  ( cost_of_packages[t] = package_price[basket[t]] /\ quality_of_packages[t] = package_quality[basket[t]]);
  
%Calculating quality and price by adding the values of the arrays
constraint quality = sum(t in BUYS)(quality_of_packages[t]);           
constraint price = sum(t in BUYS)(cost_of_packages[t]);

% We create an array that holds the offer we are picking, and then we must have different categories in each offer.
array[BUYS] of var set of int : basket_offer;
constraint forall (t in BUYS) 
      (basket_offer[t] = package[basket[t]]);
constraint forall (i,j in 1..4 where i!=j)( (basket_offer[i] intersect basket_offer[j]) ={} );

%Price of packages must be lower than max money
constraint  price < max_money ;

%Solving the problem
solve maximize quality; 

%%% Output Code (do not change)
output["%%% Just for Debuging: "]++["\(package[basket[b]]) "| b in BUYS] 
      ++ ["\nbasket = \(basket);"]
      ++ ["\nquality = \(quality);\n"] 
      ++ ["price = \(price);\n"]  
      ; 

