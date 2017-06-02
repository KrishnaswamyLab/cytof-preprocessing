addpath('../Source');

% Test 1: Trivial test.
densityEstimateA = [0 1 0 0 0 0 0 2];
densityEstimateB = [0 0 1 0 0 1 1 0];
assert(calcEarthMoverDistance(densityEstimateA, densityEstimateB) == 4);

% Test 2: Shifted gaussian distributions, the larger the shift, the large the
%         distance should be.
rng(021088);
distances = [];
shifts = 0:0.5:4;
for i = 1:length(shifts)
    populationA = normrnd(5, 1, [10000, 1]);
    populationB = normrnd(5 + shifts(i), 1, [10000, 1]);
    edges = [0:0.1:15];
    densityEstimateA = histcounts(populationA, edges, 'Normalization', 'probability');
    densityEstimateB = histcounts(populationB, edges, 'Normalization', 'probability');
    %figure
    %hold on
    %histogram(populationA, edges, 'Normalization', 'probability');
    %histogram(populationB, edges, 'Normalization', 'probability');
    %hold off
    distances(i) = calcEarthMoverDistance(densityEstimateA, densityEstimateB);
    if (i > 1)
        assert(distances(i) > distances(i-1));
    end
end
