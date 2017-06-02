addpath('../Source');

%% Test 1
distanceMatrix = [0 0 1; 0 0 2; 2 1 0];
zeroIndicatorMatrix = [1 1 0; 1 1 0; 0 0 1];
affinityMatrix = calcAffinityMatrix(distanceMatrix, zeroIndicatorMatrix, 'sigma', 2, 'exponent', 2);
oracleAffinityMatrix = [1 1 exp(-1/8); 1 1 exp(-4/8); exp(-4/8) exp(-1/8) 1];
assert(sum(sum(abs(oracleAffinityMatrix-affinityMatrix))) < 0.000001);

%% Test 2
distanceMatrix = [0 0 1; 0 0 2; 2 1 0];
zeroIndicatorMatrix = [1 1 0; 1 1 0; 0 0 1];
affinityMatrix = calcAffinityMatrix(distanceMatrix, zeroIndicatorMatrix, 'sigma', 0, 'exponent', 2);
oracleAffinityMatrix = [1 1 0; 1 1 0; 0 0 1];
assert(sum(sum(abs(oracleAffinityMatrix-affinityMatrix))) < 0.000001);

%% Test 3
distanceMatrix = [0 1 2 0 0 0; 2 0 0 0 0 0; 2 0 0 0 0 0; 0 0 0 0 2 1; 0 0 0 1 0 0; 0 0 0 2 0 0];
zeroIndicatorMatrix = [1 0 0 0 0 0; 0 1 1 0 0 0; 0 1 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 1; 0 0 0 0 1 1];
affinityMatrix = calcAffinityMatrix(distanceMatrix, zeroIndicatorMatrix, 'sigma', 0.5, 'exponent', 1);
v1 = exp(-1/0.5);
v2 = exp(-2/0.5);
oracleAffinityMatrix = [1 v1 v2 0 0 0; v2 1 1 0 0 0; v2 1 1 0 0 0; 0 0 0 1 v2 v1; 0 0 0 v1 1 1; 0 0 0 v2 1 1];
assert(sum(sum(abs(oracleAffinityMatrix-affinityMatrix))) < 0.000001);

%% Test 4
samples = [1 ; 2 ; 2 ; 101 ; 102 ; 102];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 3);
affinityMatrix = calcAffinityMatrix(distanceMatrix, zeroIndicatorMatrix, 'sigma', 0.5, 'exponent', 1);
oracleAffinityMatrix = [1 v1 v1 0 0 0; v1 1 1 0 0 0; v1 1 1 0 0 0; 0 0 0 1 v1 v1; 0 0 0 v1 1 1; 0 0 0 v1 1 1];
assert(sum(sum(abs(oracleAffinityMatrix-affinityMatrix))) < 0.000001);
