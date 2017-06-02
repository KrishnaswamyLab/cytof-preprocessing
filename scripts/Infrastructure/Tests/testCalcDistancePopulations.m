addpath('../Source');

% Test 1: Trivial test.
populationA = [ 1 1; 2 98 ; 2 98 ; 3 99 ; 100 100];
populationB = [ 1 1; 2 98 ; 3 99 ; 3 100; 100 100];
assert(abs(calcDistancePopulations(populationA, populationB)-0.6) < 0.00001);

% Test 2: Statistic test.
rng(021088);
populationA = [normrnd(5, 1, [1000, 1]) normrnd(-7, 2, [1000, 1])];
populationB = [normrnd(5.5, 1, [1000, 1]) normrnd(-6.2, 1, [1000, 1])];
populationC = [normrnd(5.5, 1, [1000, 1]) normrnd(6.2, 1, [1000, 1])];
distanceAB = calcDistancePopulations(populationA, populationB);
distanceAC = calcDistancePopulations(populationA, populationC);
assert(distanceAB < distanceAC);
