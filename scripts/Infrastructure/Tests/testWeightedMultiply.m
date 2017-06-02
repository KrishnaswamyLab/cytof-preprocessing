addpath('../Source');

%% Test 1
lHS = [1/2 1/4 ; 1/5 2/5];
rHS = [1 0 1; 1 1 1];
weights = [1, 2];
weightedProduct = weightedMultiply(lHS, rHS, weights);
oracle = [1 1/2 1 ; 1 4/5 1];
assert(isequal(weightedProduct, oracle));
