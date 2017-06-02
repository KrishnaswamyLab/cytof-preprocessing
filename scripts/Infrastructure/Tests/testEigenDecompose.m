addpath('../Source');

%% Test 1 (normal mode, i.e. exact eigendecomposition.)
samples = repmat(magic(3), 2, 1);
[distanceMatrix, zeroIndicatorMatrix] = calcDistanceMatrix(samples);
affinityMatrix = calcAffinityMatrix(distanceMatrix, zeroIndicatorMatrix, 'sigma', 2, 'exponent', 1);
[eigenvectors, eigenvalues] = eigenDecompose(affinityMatrix);
affinityMatrixComposed = eigenvectors * eigenvalues * eigenvectors';
assert(sum(sum(abs(affinityMatrixComposed-affinityMatrix))) < 0.0000001);

%% Test 2 (nystroem mode but with full parameter n, should yield exact results as well.)
[eigenvectors, eigenvalues] = eigenDecompose(affinityMatrix, 'mode', 'nystroem', 'nystroemN', 6);
affinityMatrixComposed = eigenvectors * eigenvalues * eigenvectors';
assert(sum(sum(abs(affinityMatrixComposed-affinityMatrix))) < 0.0000001);

%% Test 3 (nystroem mode with parameter n=3, again, this should yield the exact result, but
%%         only because the affinity matrix is redundant.)
[eigenvectors, eigenvalues] = eigenDecompose(affinityMatrix, 'mode', 'nystroem', 'nystroemN', 3);
affinityMatrixComposed = eigenvectors * eigenvalues * eigenvectors';
assert(sum(sum(abs(affinityMatrixComposed - affinityMatrix))) < 0.0000001);

%% Test 4 (nystroem mode with parameter n=2, should yield a composition for \hat W.
[eigenvectors, eigenvalues] = eigenDecompose(affinityMatrix, 'mode', 'nystroem', 'nystroemN', 2);
approximationAffinityMatrix = eigenvectors * eigenvalues * eigenvectors';
A = full(affinityMatrix(1:2, 1:2));
B = full(affinityMatrix(1:2, 3:6));
oracleApproximationAffinityMatrix = [A ; B'] * pinv(A) * [A B];
assert(sum(sum(abs(approximationAffinityMatrix - oracleApproximationAffinityMatrix))) < 0.0000001);

%% Test 5 (nystroem mode with parameter n>size(M), should yield an exact eigen decomposition.
[eigenvectors, eigenvalues] = eigenDecompose(affinityMatrix, 'mode', 'nystroem', 'nystroemN', 200);
affinityMatrixComposed = eigenvectors * eigenvalues * eigenvectors';
assert(sum(sum(abs(affinityMatrixComposed - affinityMatrix))) < 0.0000001);
