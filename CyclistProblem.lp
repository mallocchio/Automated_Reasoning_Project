1{requiredDaysToVisitAllRoads(D) : day(D)}1.

1{travel(D, R, I1, I2) : road(I1, I2, _)}1 :- roadsTraveledPerDay(R), day(D), roadVisitedPerDay(D, V), R <= V.

1{roadVisitedPerDay(D,R) : roadsTraveledPerDay(R)}1 :- requiredDaysToVisitAllRoads(ND), day(D), D <= ND.

visited(I1, I2) :- travel(_, _, I1, I2).

kmTravelledPerDay(KM, D) :- day(D), requiredDaysToVisitAllRoads(ND), D <= ND, 
                            KM = #sum{Length, R : travel(D, R, A, B), road(A, B, Length)}.

:- day(D), travel(D, 1, S, _), roadVisitedPerDay(D, R), travel(D, R, _, F), S != F.

:- travel(D, R, _, F), travel(D, R+1, S, _), F != S.

:- day(D), kmTravelledPerDay(KM, D), KM > max_km_per_day.

:- not visited(I1, I2), not visited(I2, I1), road(I1, I2, _).

#minimize {D:requiredDaysToVisitAllRoads(D)}.

#show travel/4.
#show requiredDaysToVisitAllRoads/1.