function [assignment, cost] = matchClusters(populationsA, populationsB, clusterAssignmentA, clusterAssignmentB)
    distanceMatrix = [];
    clustersA = unique(clusterAssignmentA);
    clustersB = unique(clusterAssignmentB);
    numClustersA = length(clustersA);
    numClustersB = length(clustersB);
    for i=1:numClustersA
        for j=1:numClustersB
            distanceMatrix(i, j) = calcDistancePopulations(populationsA(clusterAssignmentA == clustersA(i), :), ...
                                                           populationsB(clusterAssignmentB == clustersB(j), :));
        end
    end

    %figure
    %imagesc(mapColors(distanceMatrix, 'ysm'));
    %xlabel('Cluster ID B')
    %ylabel('Cluster ID A')
    %set(gcf, 'Color', 'w');
    %set(gcf, 'Position', [2367 1 900 800]);
    %set(gca, 'fontsize', 18);
    %colormap(customColormap(-2, 2, 'presetColors', 'ysm'))
    %colorbar('Ticks', [0,1], ...
    %         'TickLabels', {'Similar', 'Different'});
    %if (exist('export_fig', 'file'))
    %    export_fig('distance_matrix.png');
    %end

    distanceMatrixSelf = [];
    for i=1:numClustersA
        for j=1:numClustersA
            distanceMatrixSelf(i, j) = calcDistancePopulations(populationsA(clusterAssignmentA == clustersA(i), :), ...
                                                               populationsA(clusterAssignmentA == clustersA(j), :));
        end
    end

    %figure
    %imagesc(mapColors(distanceMatrixSelf, 'ysm'));
    %xlabel('Cluster ID A')
    %ylabel('Cluster ID A')
    %set(gcf, 'Color', 'w');
    %set(gcf, 'Position', [2367 1 900 800]);
    %set(gca, 'fontsize', 18);
    %colormap(customColormap(-2, 2, 'presetColors', 'ysm'))
    %colorbar('Ticks', [0,1], ...
    %         'TickLabels', {'Similar', 'Different'});
    %if (exist('export_fig', 'file'))
    %    export_fig('distance_matrix_self.png');
    %end

    for i = 1:numClustersA
        distanceMatrixSelf(i, i) = nan;
    end
    minDistanceMatrixSelf = min(min(distanceMatrixSelf));
    maxDistanceMatrix = max(max(distanceMatrix));
    distanceMatrix(distanceMatrix > minDistanceMatrixSelf) = maxDistanceMatrix;

    %figure
    %imagesc(mapColors(distanceMatrix, 'ysm'));
    %xlabel('Cluster ID B')
    %ylabel('Cluster ID A')
    %set(gcf, 'Color', 'w');
    %set(gcf, 'Position', [2367 1 900 800]);
    %set(gca, 'fontsize', 18);
    %colormap(customColormap(-2, 2, 'presetColors', 'ysm'))
    %colorbar('Ticks', [0,1], ...
    %         'TickLabels', {'Similar', 'Different'});
    %if (exist('export_fig', 'file'))
    %    export_fig('distance_matrix_fixed.png');
    %end

    [assignment, cost] = munkres(distanceMatrix);
    for i=1:length(assignment)
        if (assignment(i) == 0)
            cost = cost + maxDistanceMatrix;
        else
            if (distanceMatrix(i, assignment(i)) >= maxDistanceMatrix)
                assignment(i) = 0;
            end
        end
    end

    %combinedPopulations = [];
    %combinedClusterAssignment = [];
    %clustersBMatched = [];
    %for i=1:length(assignment)
    %    if (assignment(i) ~= 0)
    %        combinedPopulations = [ combinedPopulations ;  populationsA(clusterAssignmentA == i, :) ];
    %        combinedClusterAssignment = [ combinedClusterAssignment ; [repmat(i, sum(clusterAssignmentA == i), 1) repmat(1, sum(clusterAssignmentA == i), 1) ] ];
    %        combinedPopulations = [ combinedPopulations ; populationsB(clusterAssignmentB == assignment(i), :) ];
    %        combinedClusterAssignment = [ combinedClusterAssignment ; [repmat(i, sum(clusterAssignmentB == assignment(i)), 1) repmat(2, sum(clusterAssignmentB == assignment(i)), 1) ] ];
    %        clustersBMatched = [ clustersBMatched assignment(i) ];
    %    else
    %        combinedPopulations = [ combinedPopulations ;  populationsA(clusterAssignmentA == i, :) ];
    %        combinedClusterAssignment = [ combinedClusterAssignment ; [repmat(i, sum(clusterAssignmentA == i), 1) repmat(1, sum(clusterAssignmentA == i), 1) ] ];
    %    end
    %end
    %clustersBUnmatched = setdiff(clustersB, clustersBMatched);
    %for i = 1:length(clustersBUnmatched)
    %    combinedPopulations = [ combinedPopulations ;  populationsB(clusterAssignmentB == clustersBUnmatched(i), :) ];
    %    combinedClusterAssignment = [ combinedClusterAssignment ; [repmat(i+numClustersA, sum(clusterAssignmentB == clustersBUnmatched(i)), 1) repmat(2, sum(clusterAssignmentB == clustersBUnmatched(i)), 1) ] ];
    %end
    %figure
    %hierarchicalHeatmap(combinedPopulations, ...
    %                    combinedClusterAssignment);
    %set(gcf, 'Color', 'w');
    %set(gcf, 'Position', [2367 1 1400 1400]);
    %set(gca, 'fontsize', 18);
    %if (exist('export_fig', 'file'))
    %    export_fig('clusters_mapped_heatmap.png');
    %end

end
