function [ data ] = normalize(data, varargin)
    data = data.populateBeadIndices();
    data = data.populateBeadValues();

    numBeads = sum(data.indicesBeads);
    numEvents = size(data.data, 1);
    percentageBeads = round(100*sum(data.indicesBeads)/size(data.data, 1), 1);

    disp([indent(data.options.indentationLevel) ...
          'Normalization: Identified ' ...
          num2str(numBeads) ...
          ' singlet beads among ' ...
          num2str(numEvents) ...
          ' events (' ...
          num2str(percentageBeads) ...
          '%).' ...
         ]);
    disp([indent(data.options.indentationLevel) ...
          'Normalization: Analysis interval: [' ...
          num2str(round(min(data.data(:,1)/1000))) ...
          's, ' ...
          num2str(round(max(data.data(:, 1)/1000))) ...
          's].' ...
         ]);

    if (data.options.emitPlots)
        emitBeadVsDNA1Plots(data, true);
    end

    data = data.smoothBeadValues();

    if (data.options.emitPlots)
        emitTimeVsBeadValuesPlot(data, true);
    end

    data = data.populateValidationValues();

    data = data.applyNormalization();

    if (data.options.emitPlots)
        emitTimeVsBeadValuesPlot(data, false);
        emitCorrectionMap(data);
    end

    if (data.options.emitPlots)
        data.plotValidationValuesBeforeAndAfter();
    end

    data = data.discardBeadEvents();

    if (data.options.emitPlots)
        emitBeadVsDNA1Plots(data, false);
    end

    if (data.options.emitNormalizedData)
        data.writeData(strcat(data.options.dataOutputFolder, '/', data.options.asString(), '_normalized.fcs'));
    end
end

%%% loewess one shot solution
%%x = repmat(timeBeads(1:5000), 6, 1);
%%%y = reshape(repmat(beadMasses', sum(indicesBeads), 1), [], 1);
%%y = reshape(repmat(beadMasses', 5000, 1), [], 1);
%%z = reshape(correctionFactors(1:5000, :), [], 1);
%%f = fit([x,y], z, 'lowess'); 
%%disp('DONE FITTING');
%%return
%%
%%xFull = repmat(relData.data(:,1), 176-140, 1);
%%yFull = reshape(repmat(140:175, size(relData.data, 1), 1), [], 1);
%%normFactorI = reshape(f(xFull, yFull), sum(relData.data, 1), []);
%%disp('DONE LOOKING UP');
%
%if (splorm)
%    for i = [10000 10500]
%        f = fit(beadMasses, correctionFactors(i, :)', 'smoothingspline', 'SmoothingParam', 0.1)
%        figure
%        plot(f, beadMasses, correctionFactors(i, :)');
%        set(gcf, 'Color', 'w');
%        set(gcf, 'Position', [1 1 700 500]);
%        set(gca, 'fontsize', 18);
%        xlabel('Channel Mass');
%        ylabel('Correction Factor');
%        hold on
%        corrFactorStandard = mean(correctionFactors(i, :));
%        plot([140 175], [corrFactorStandard corrFactorStandard], 'g');
%        legend({'data', 'splorm', 'standard'});
%        export_fig(strcat('lc_correction_per_channel_', num2str(i), '.png'));
%    end
%end

function emitBeadVsDNA1Plots(data, beforeNormalization)
    numSamples = size(data.data, 1);
    if (numSamples > 500000)
        toPlot = randsample(numSamples, 500000);
        indicesToPlot = zeros(numSamples, 1);
        indicesToPlot(toPlot) = 1;
    else
        indicesToPlot = ones(numSamples, 1);
    end
    transparency = 1;
    if (numSamples > 150000)
        transparency = 0.01;
    elseif (numSamples > 50000)
        transparency = 0.1;
    end

    indicesToPlot = logical(indicesToPlot);
    transformedBeadData = CyTOFData.transform(data.data(:, data.beadColumns), 1);
    transformedDNA1Data = CyTOFData.transform(data.data(:, data.dNA1Column), 1);
    for i = 1:length(data.beadColumns)
        figure
        hold on
        if (beforeNormalization)
            scatterX([NaN, NaN], 'colorAssignment', [1 0 0], 'transparency', 1);
            scatterX([NaN, NaN], 'colorAssignment', [0 0 0], 'transparency', 1);
            numBeads = sum(data.indicesBeads);
            numEvents = size(data.data, 1);
            percentageBeads = round(100*sum(data.indicesBeads)/size(data.data, 1), 1);
            legend({['singlet beads (' num2str(percentageBeads) '%)'], ['rest (' num2str(100-percentageBeads) '%)']}, ...
                   'location', 'northeast' ...
                  );
            scatterX([transformedBeadData(data.indicesBeads & indicesToPlot, i) transformedDNA1Data(data.indicesBeads & indicesToPlot)], ...
                     'colorAssignment', repmat([1 0 0], sum(data.indicesBeads & indicesToPlot), 1), ...
                     'sizeAssignment', 0.1*ones(sum(data.indicesBeads & indicesToPlot), 1), ...
                     'addJitter', false, ...
                     'transparency', transparency);
            scatterX([transformedBeadData(~data.indicesBeads & indicesToPlot, i) transformedDNA1Data(~data.indicesBeads & indicesToPlot)], ...
                     'colorAssignment', repmat([0 0 0], sum(~data.indicesBeads & indicesToPlot), 1), ...
                     'sizeAssignment', 0.1*ones(sum(~data.indicesBeads & indicesToPlot), 1), ...
                     'addJitter', false, ...
                     'transparency', transparency);
        else
            scatterX([transformedBeadData(indicesToPlot, i) transformedDNA1Data(indicesToPlot)], ...
                     'colorAssignment', repmat([0 0 0], sum(indicesToPlot), 1), ...
                     'sizeAssignment', 0.1*ones(sum(indicesToPlot), 1), ...
                     'addJitter', false, ...
                     'transparency', transparency);
        end
        xlabel(data.options.labelsBeads{i});
        if (i == 1)
            ylabel('DNA_1 (191ir)');
        else
            set(gca, 'YTick', []);
        end
        set(gcf, 'Color', 'w');
        set(gcf, 'Position', [1367+(i-1)*350 1 350 350]);
        set(gca, 'fontsize', 18);
        if (beforeNormalization)
            suffix = 'beforeNormalization';
        else
            suffix = 'afterNormalization';
        end
        if (exist('export_fig', 'file'))
            export_fig(strcat(data.options.plotOutputFolder, '/', data.options.asString(), '_dna1_vs_bead_', num2str(i), '_', suffix, '.png'));
        end
    end
end

function emitTimeVsBeadValuesPlot(data, beforeNormalization)
    figure
    plot(data.beadTimes/1000, data.beadValues/diag(data.beadValues(1,:)));
    xlabel('Time (s)');
    ylabel('Expression Channel (smoothed, normalized)');
    legend(data.options.labelsBeads, 'location', 'eastoutside');
    set(gcf, 'Color', 'w');
    set(gcf, 'Position', [1367+(~beforeNormalization)*800 351 800 550]);
    set(gca, 'fontsize', 18);
    if (beforeNormalization)
        suffix = 'beforeNormalization';
    else
        suffix = 'afterNormalization';
    end
    if (exist('export_fig', 'file'))
        export_fig(strcat(data.options.plotOutputFolder, '/', data.options.asString(), '_time_vs_bead_values_', suffix, '.png'));
    end
end

function emitCorrectionMap(data)
    ax = figure;
    myColors = customColormap(min(min(data.normFactorPerMass))-1, max(max(data.normFactorPerMass))-1, 'presetColors', 'ysm');
    colormap(ax, myColors);
    ax = imagesc(data.normFactorPerMass');
    colorbar;
    ax = gca;
    ax.YTick = 1:5:37;
    ax.YTickLabel = 140:5:175;
    xrange = xlim();
    ax.XTick = xrange(1):(xrange(2)-xrange(1))/5:xrange(2);
    ax.XTickLabel = round(data.data(1,1)/1000:((data.data(end,1)-data.data(1,1))/5)/1000:data.data(end,1)/1000);
    set(gcf, 'Color', 'w');
    set(gcf, 'Position', [1367 901 1000 550]);
    set(gca, 'fontsize', 18);
    xlabel('Time (s)');
    ylabel('Channel Mass');
    if (exist('export_fig', 'file'))
        export_fig(strcat(data.options.plotOutputFolder, '/', data.options.asString(), '_correction_map.png'));
    end
end
