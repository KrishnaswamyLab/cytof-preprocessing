addpath('../Source');

%% Test 1
samples = [1 1 1; 1 1 1; 1 1 2];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples);
oracleDistanceMatrix = [0 0 1; 0 0 1; 1 1 0];
oracleZeroIndicatorMatrix = [1 1 0; 1 1 0; 0 0 1];
assert(isequal(oracleDistanceMatrix, distanceMatrix));
assert(isequal(oracleZeroIndicatorMatrix, zeroIndicatorMatrix));

%% Test 2
samples = [1 ; 2 ; 2 ; 101 ; 102 ; 102];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 3);
oracleDistanceMatrix = [0 1 1 0 0 0; 1 0 0 0 0 0; 1 0 0 0 0 0; 0 0 0 0 1 1; 0 0 0 1 0 0; 0 0 0 1 0 0];
oracleZeroIndicatorMatrix = [1 0 0 0 0 0; 0 1 1 0 0 0; 0 1 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 1; 0 0 0 0 1 1];
assert(isequal(oracleDistanceMatrix, distanceMatrix));
assert(isequal(oracleZeroIndicatorMatrix, zeroIndicatorMatrix));

%% Test 3
samples = [1 ; 2 ; 2 ; 101 ; 102 ; 102];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 8);
oracleDistanceMatrix = [0 1 1 100 101 101; 1 0 0 99 100 100; 1 0 0 99 100 100; ...
                        100 99 99 0 1 1; 101 100 100 1 0 0; 101 100 100 1 0 0];
oracleZeroIndicatorMatrix = [1 0 0 0 0 0; 0 1 1 0 0 0; 0 1 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 1; 0 0 0 0 1 1];
assert(isequal(oracleDistanceMatrix, distanceMatrix));
assert(isequal(oracleZeroIndicatorMatrix, zeroIndicatorMatrix));

%% Test 4
samples = [ 1 1 1 1 1 ; 2 1 1 1 1 ];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 8, 'n_pca', 3);
oracleDistanceMatrix = [0 1; 1 0];
assert(sum(sum(abs(oracleDistanceMatrix-distanceMatrix))) < 0.000001);

%% Test 5: Partitioning
samples = [ 0 0 ; 1 0 ; 0 1 ; 1 1 ; 4 2 ; 3 3 ];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 3, 'mode', 'partitioning', 'lengthPartitions', 1);
oracleDistanceMatrix = [0 1 1 0 0 0; 1 0 0 1 0 0; 1 0 0 1 0 0; 0 1 1 0 0 0; 0 0 0 0 0 sqrt(2); 0 0 0 0 sqrt(2) 0];
oracleZeroIndicatorMatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
assert(sum(sum(abs(oracleDistanceMatrix-distanceMatrix))) < 0.000001);
assert(isequal(oracleZeroIndicatorMatrix, zeroIndicatorMatrix));

%% Test 6: Partitioning and doublets
samples = [ 0 0 ; 0 0 ; 0.5 -0.5 ; -0.5 0.5 ; 1 0 ; -1 0; -1 0 ];
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples, 'k_knn', 10, 'mode', 'partitioning', 'lengthPartitions', 0.5);
oracleDistanceMatrix = sqrt(0.5)*[0 0 1 1 0 0 0; 0 0 1 1 0 0 0; 1 1 0 0 1 0 0; 1 1 0 0 0 1 1; 0 0 1 0 0 0 0; 0 0 0 1 0 0 0; 0 0 0 1 0 0 0];
oracleZeroIndicatorMatrix = [1 1 0 0 0 0 0; 1 1 0 0 0 0 0; 0 0 1 0 0 0 0; 0 0 0 1 0 0 0; 0 0 0 0 1 0 0; 0 0 0 0 0 1 1; 0 0 0 0 0 1 1];
assert(sum(sum(abs(oracleDistanceMatrix-distanceMatrix))) < 0.000001);
assert(isequal(oracleZeroIndicatorMatrix, zeroIndicatorMatrix));
