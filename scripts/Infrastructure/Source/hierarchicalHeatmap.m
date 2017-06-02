function hierarchicalHeatmap(dataPoints, ...
                             clusterAssignments, ...
                             varargin)
    % HIERARCHIALHEATMAP Emits a heatmap of the data.
    %
    % Author : Tobias Welp
    % Year   : 2016

    populationStatistics = [];

    % parsing of variable argument list
    for i=1:length(varargin)-1
        if (strcmp(varargin{i}, 'labelsDimensions'))
            labelsDimensions = varargin{i+1};
        end
        if (strcmp(varargin{i}, 'colorsHeatMap'))
            colorsHeatMap = varargin{i+1};
        end
        if (strcmp(varargin{i}, 'populationStatistics'))
            populationStatistics = varargin{i+1};
        end
    end

    % populating default values unless values provided
    if (~exist('labelsDimensions'))
        labelsDimensions = {};
        for i=1:size(dataPoints, 2)
            labelsDimensions = [labelsDimensions ; ['Dimension_' num2str(i)] ];
        end
    end

    if (~exist('colorsHeatMap'))
        colorsHeatMap = 'ysm';
    end

    gapsBetweenClusters = ones(size(clusterAssignments, 2), 1);
    gapsBetweenClusters(1) = 5;
    if (size(clusterAssignments, 2) > 1)
        gapsBetweenClusters(2) = 3;
    end

    [dataPoints, clusterAssignments] = sortByClusterAssignments(dataPoints, clusterAssignments);

    numRows = calcNumberRows(clusterAssignments, gapsBetweenClusters);

    colors = mapColors(normalizeDataPoints(dataPoints, populationStatistics), colorsHeatMap);
    plotClusters(1, numRows, 1, size(clusterAssignments, 2)+30, clusterAssignments, colors, gapsBetweenClusters);
    plotLegend(labelsDimensions);
end

function [sortedDataPoints, sortedClusterAssignments] = sortByClusterAssignments(dataPoints, clusterAssignments);
    pivotClusters = unique(clusterAssignments(:, 1));
    numPivotClusters = length(pivotClusters);
    sortedDataPoints = [];
    sortedClusterAssignments = [];
    for i = 1:numPivotClusters
        indicesInCurrentCluster = (clusterAssignments(:, 1) == pivotClusters(i));
        if (size(clusterAssignments, 2) > 1)
            [sortedDataPointsCluster, sortedClusterAssignmentsCluster] = sortByClusterAssignments(dataPoints(indicesInCurrentCluster, :), ...
                                                                                                  clusterAssignments(indicesInCurrentCluster, 2:end));
            sortedDataPoints = [sortedDataPoints ; sortedDataPointsCluster ];
            sortedClusterAssignments = [ sortedClusterAssignments ; ...
                                         [repmat(pivotClusters(i), sum(indicesInCurrentCluster), 1) sortedClusterAssignmentsCluster] ];
        else
            sortedDataPoints = [sortedDataPoints ; dataPoints(indicesInCurrentCluster, :)];
            sortedClusterAssignments = [ sortedClusterAssignments ; clusterAssignments(indicesInCurrentCluster)];
        end
    end
end

function numRows = calcNumberRows(clusterAssignments, gapsBetweenClusters)
    numRows = size(clusterAssignments, 1);
    assert(size(clusterAssignments, 2) == length(gapsBetweenClusters));

    for i = 2:size(clusterAssignments, 1)
        for j = 1:size(clusterAssignments, 2)
            if (clusterAssignments(i-1, j) ~= clusterAssignments(i, j))
                numRows = numRows + gapsBetweenClusters(j);
                break;
            end
        end
    end
end

function dataPoints = normalizeDataPoints(dataPoints, populationStatistics)

    if (isempty(populationStatistics))
        dataPoints = zscore(dataPoints);
    else
        for i=1:size(dataPoints, 2)
            dataPoints(:, i) = (dataPoints(:, i)-populationStatistics(i, 1))/populationStatistics(i, 2);
        end
    end
    % normalize each column
    %for i = 1:size(dataPoints, 2)
    %    dataPoints(:,i) = mat2gray(dataPoints(:,i));
    %end
    for i = 1:size(dataPoints, 2)
        dataPoints(dataPoints(:,i)>2, i) = 2;
        dataPoints(dataPoints(:,i)<-2, i) = -2;
    end
    for i = 1:size(dataPoints, 2)
        dataPoints(:,i) = mat2gray(dataPoints(:,i));
    end
end

function plotClusters(rowStart, totalNumberRows, columnStart, totalNumberColumns, clusterAssignments, colors, gapsBetweenClusters)
    assert(size(clusterAssignments, 1) == size(colors, 1));
    pivotClusters = unique(clusterAssignments(:, 1));
    numPivotClusters = length(pivotClusters);
    for i = 1:numPivotClusters
        indicesInCurrentCluster = (clusterAssignments(:, 1) == pivotClusters(i));
        sizeCurrentCluster = calcNumberRows(clusterAssignments(indicesInCurrentCluster, 2:end), ...
                                             gapsBetweenClusters(2:end));
        plotIndicatorBar(rowStart, sizeCurrentCluster, totalNumberRows, columnStart, totalNumberColumns, pivotClusters(i));
        if (size(clusterAssignments, 2) > 1)
            plotClusters(rowStart, totalNumberRows, ...
                         columnStart+1, totalNumberColumns, ...
                         clusterAssignments(indicesInCurrentCluster, 2:end), colors(indicesInCurrentCluster, :, :), ...
                         gapsBetweenClusters(2:end));
        else
            plotDataPoints(rowStart, sizeCurrentCluster, totalNumberRows, columnStart+1, totalNumberColumns, colors(indicesInCurrentCluster, :, :));
        end
        rowStart = rowStart + sizeCurrentCluster + gapsBetweenClusters(1);
    end
end

function plotLegend(labelsDimensions)
    set(gca,'TickLength',[ 0 0 ]);
    set(gca,'xtick', 1:length(labelsDimensions));
    set(gca,'xticklabel', labelsDimensions);
    set(gca,'XTickLabelRotation', 45);
end

function plotIndicatorBar(rowStart, sizeCluster, totalNumberRows, columnStart, totalNumberColumns, idCluster)
    ax = subplot(totalNumberRows, totalNumberColumns, getSubplot(rowStart, sizeCluster, columnStart, totalNumberColumns));
    imagesc(zeros(sizeCluster, 1));
    text(1, sizeCluster/2, ...
         strcat(num2str(idCluster)), ...
         'Color', 'white', ...
         'HorizontalAlignment', 'center', ...
         'FontWeight', 'bold');
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    colormap(ax, [0 0 0]);
end

function plotDataPoints(rowStart, sizeCluster, totalNumberRows, columnStart, totalNumberColumns, colors)
    ax = subplot(totalNumberRows, totalNumberColumns, getSubplot(rowStart, sizeCluster, columnStart, totalNumberColumns));
    image(colors);
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
end

function indices = getSubplot(rowStart, sizeCluster, columnStart, totalNumberColumns)
    indices = [];
    if (columnStart <= totalNumberColumns-30)
        %cluster id
        for i=rowStart:(rowStart+sizeCluster-1)
            indices = [indices columnStart+(i-1)*totalNumberColumns];
        end
    else
        %sample space
        for i=rowStart:(rowStart+sizeCluster-1)
            indices = [indices columnStart+(i-1)*totalNumberColumns:(i*totalNumberColumns)];
        end
    end
end
