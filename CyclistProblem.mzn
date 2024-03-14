include "globals.mzn"; 

int: intersections;

int: max_km_per_day;

array [1..intersections, 1..intersections] of int: distance;

int: roads = (intersections * 2) - 1;

int: max_days = sum(i in 1..intersections, j in 1..intersections)(if distance[i,j] != 0 then 1 else 0 endif) div 2;

array [1..max_days, 1..roads] of var 0..intersections: path;  

var 1..max_days: days;

predicate backToStart(var int: d) =
  exists(j in 2..roads - 1)(path[d, 1] == path[d,j] /\ forall(k in j+1..roads)(path[d,k] == 0));

predicate pathExistance(var int: d) =
  forall(j in 1..roads - 1)(if path[d,j] != 0 /\ path[d,j+1] != 0 
    then path[d,j] != path[d,j+1] /\ distance[path[d,j], path[d,j+1]] != 0 endif);

predicate inMaxKm(var int: d) =
  sum(j in 1..roads - 1 where path[d, j+1] != 0)(distance[path[d,j], path[d,j+1]]) <= max_km_per_day;

predicate exploreAllRoads() =
  forall(i in 1..intersections, j in 1..intersections where i != j /\ distance[i,j] != 0)(
    exists(k in 1..max_days, l in 1..roads - 1)(
      (path[k,l] == i /\ path[k,l+1] == j) \/ 
      (path[k,l] == j /\ path[k,l+1] == i)
    )
  );


constraint forall(d in 1..max_days)(
  backToStart(d) /\ pathExistance(d) /\ inMaxKm(d));

constraint exploreAllRoads();

constraint days = max(i in 1..max_days)(if path[i,1] != 0 then i else 0 endif);

solve :: int_search(path, first_fail, indomain_max)
minimize days;







