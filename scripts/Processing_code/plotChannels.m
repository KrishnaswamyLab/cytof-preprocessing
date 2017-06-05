function plotChannels(data,channel1, channel2, prefixFilename, varargin)
% Plots a scatter plot of the two selected channels and a contour plot
% based on density. The plot can also be saved (I believe) if the right
% option is selected.

% Author: Kevin Moon
% Created: June 2017
    column1 = find(ismember(data.channelNames, channel1));
    column2 = find(ismember(data.channelNames, channel2));

    % parsing of variable argument list
    for i=1:length(varargin)-1
        if (strcmp(varargin{i}, 'max1'))
            max1 = varargin{i+1};
        end
        if (strcmp(varargin{i}, 'max2'))
            max2 = varargin{i+1};
        end
    end

    if (~exist('max1'))
        max1 = max(data.dataTransformed(:, column1));
    end
    if (~exist('max2'))
        max2 = max(data.dataTransformed(:, column2));
    end

    figure
    hold on
    plotData = data.dataTransformed(:, [column1 column2]);
    scatterX(plotData, ...
             'colorAssignment', 0.5*ones(size(plotData, 1), 3), ...
             'sizeAssignment', ones(size(plotData, 1), 1), ...
             'transparency', 0.05, ...
             'addJitter', false);
    [n,c] = hist3(plotData, [200 200]);
    n(:,1) = 0;
    n(1,:) = 0;
    [X,Y] = meshgrid(c{1}, c{2});
    n = conv2(n, 1/36 * ones(6,6), 'same');
    contour(X, Y, n', 'LineWidth', 2, 'LevelStep', 11);
    set(gcf, 'Color', 'w');
    set(gcf, 'Position', [1 1 800 800]);
    h=xlabel(data.channel2Name{column1});
    set(h,'interpreter','none')
    h=ylabel(data.channel2Name{column2});
    set(h,'interpreter','none')
    xlim([0 max1]);
    ylim([0 max2]);
    set(gca, 'fontsize', 18);
    grid
    if (exist('export_fig', 'file'))
        export_fig(strcat(prefixFilename, '_intercalation.png'));
    end
    hold off
end
