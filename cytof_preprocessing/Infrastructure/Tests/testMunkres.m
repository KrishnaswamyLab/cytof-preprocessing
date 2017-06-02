addpath('../Source')

% Test 1: Trivial case: 
costMatrix = [ 2 7 2 ; 3 3 3 ; 3 3 2];
[assignment, cost] = munkres(costMatrix);
assert(isequal(assignment, [1 2 3]));
assert(isequal(cost, 7));

% Test 2: Non-square case (more workers than jobs):
costMatrix = [ 3 10 ; 1 6 ; 1 5 ; 10 10];
[assignment, cost] = munkres(costMatrix);
assert(isequal(assignment, [0 1 2 0]));
assert(isequal(cost, 6));

% Test 3: Non-square case (more jobs than workers):
costMatrix = [ 1 10 2; 2 10 1];
[assignment, cost] = munkres(costMatrix)
assert(isequal(assignment, [1 3]));
assert(isequal(cost, 2));
