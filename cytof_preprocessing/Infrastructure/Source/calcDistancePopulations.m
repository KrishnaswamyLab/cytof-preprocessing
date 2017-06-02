function distance = calcDistancePopulations(populationA, populationB)
    assert(size(populationA, 2) == size(populationB, 2));
    numDimensions = size(populationA, 2);
    distanceDensityEstimates = [];
    for i = 1:numDimensions
        maxValue = max(max(populationA(:, i)), max(populationB(:, i)));
        minValue = min(min(populationA(:, i)), min(populationB(:, i)));
        edges = [minValue:((maxValue-minValue)/100):maxValue];
        densityEstimateA = histcounts(populationA(:, i), edges, 'Normalization', 'probability');
        densityEstimateB = histcounts(populationB(:, i), edges, 'Normalization', 'probability');
        distanceDensityEstimates(i) = calcEarthMoverDistance(densityEstimateA, densityEstimateB);
    end
    distance = sum(distanceDensityEstimates);
end
