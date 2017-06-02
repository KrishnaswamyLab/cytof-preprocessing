function plotDNA1DNA2Plot(data, prefixFilename, varargin);

    columnDNA1 = find(ismember(data.channelNames, 'Ir191Di'));
    columnDNA2 = find(ismember(data.channelNames, 'Ir193Di'));

    % parsing of variable argument list
    for i=1:length(varargin)-1
        if (strcmp(varargin{i}, 'maxDNA1'))
            maxDNA1 = varargin{i+1};
        end
        if (strcmp(varargin{i}, 'maxDNA2'))
            maxDNA2 = varargin{i+1};
        end
    end

    if (~exist('maxDNA1'))
        maxDNA1 = max(data.dataTransformed(:, columnDNA1));
    end
    if (~exist('maxDNA2'))
        maxDNA2 = max(data.dataTransformed(:, columnDNA2));
    end

    figure
    hold on
    plotData = data.dataTransformed(:, [columnDNA1 columnDNA2]);
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
    xlabel('DNA_1 (191ir)');
    ylabel('DNA_2 (193ir)');
    xlim([0 maxDNA1]);
    ylim([0 maxDNA2]);
    set(gca, 'fontsize', 18);
    grid
    if (exist('export_fig', 'file'))
        export_fig(strcat(prefixFilename, '_intercalation.png'));
    end
    hold off
end
