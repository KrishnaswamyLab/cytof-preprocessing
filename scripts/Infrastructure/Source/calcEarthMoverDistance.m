function distance = calcEarthMoverDistance(densityEstimateA, densityEstimateB)
    assert(length(densityEstimateA) == length(densityEstimateB));
    earthMoved = [ 0 ];
    for i = 1:length(densityEstimateA)
        earthMoved(i+1) = earthMoved(i) + densityEstimateA(i) - densityEstimateB(i);
    end
    distance = sum(abs(earthMoved));
end
