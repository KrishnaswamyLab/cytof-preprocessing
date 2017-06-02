classdef NormalizationCyTOFData < CyTOFData
    properties
        options
        beadColumns = [];
        dNA1Column = [];
        indicesBeads = [];
        indicesWithBeads = [];
        beadValues = [];
        beadTimes = [];
        normFactorPerMass = [];
        normFactorPerChannel = [];
        validationValuesBefore = [];
    end
    methods
        function obj = NormalizationCyTOFData(filename, options)
            obj@CyTOFData(filename);
            obj.options = options;
            if (~isempty(obj.options.beadChannelNames))
                obj.beadColumns = find(ismember(obj.channelNames, obj.options.beadChannelNames));
                assert(size(obj.options.beadChannelNames, 2) == size(obj.beadColumns, 2));
            else
                switch (obj.options.beadStandard)
                case '4El'
                    beadChannels = {'Ce140Di', 'Ce142Di', 'Eu151Di', 'Eu153Di', 'Ho165Di', 'Lu175Di'};
                    obj.beadColumns = find(ismember(obj.channelNames, beadChannels));
                    if (size(beadChannels, 2) ~= size(obj.beadColumns, 2))
                        beadChannels = {'Ce140Di', 'Nd142Di', 'Eu151Di', 'Eu153Di', 'Ho165Di', 'Lu175Di'};
                        obj.beadColumns = find(ismember(obj.channelNames, beadChannels));
                    end
                case '1El'
                    beadChannels = {'Eu151Di', 'Eu153Di'};
                    obj.beadColumns = find(ismember(obj.channelNames, beadChannels));
                end
                assert(size(beadChannels, 2) == size(obj.beadColumns, 2));
            end
            obj.dNA1Column = find(ismember(obj.channelNames, 'Ir191Di'));
        end
        function obj = populateBeadIndices(obj)
            transformedBeadData = CyTOFData.transform(obj.data(:, obj.beadColumns), 1);
            transformedDNA1Data = CyTOFData.transform(obj.data(:, obj.dNA1Column), 1);
            obj.indicesBeads = (transformedDNA1Data < obj.options.thresholdDNA1);
            obj.indicesWithBeads = ones(size(obj.indicesBeads));
            for i = 1:length(obj.beadColumns)
                obj.indicesWithBeads = obj.indicesWithBeads & (transformedBeadData(:, i) > obj.options.intervalBeads(i, 1));
                obj.indicesBeads = obj.indicesBeads & (transformedBeadData(:, i) < obj.options.intervalBeads(i, 2));
            end
            obj.indicesBeads = obj.indicesBeads & obj.indicesWithBeads;
        end
        function obj = populateBeadValues(obj)
            obj.beadValues = obj.data(obj.indicesBeads, obj.beadColumns);
            obj.beadTimes = obj.data(obj.indicesBeads, 1);
        end
        function obj = smoothBeadValues(obj)
            beadDataOrg = obj.beadValues;
            for i = 1:sum(obj.indicesBeads)
                minIndex = max(1, i-ceil(obj.options.smoothingWindow/2));
                maxIndex = min(sum(obj.indicesBeads), i+ceil(obj.options.smoothingWindow/2));
                obj.beadValues(i, :) = median(beadDataOrg(minIndex:maxIndex, :));
            end
        end
        function obj = generalizeNormalizationFactor(obj, normFactor)
            %interpolate to get in between values.
            obj.normFactorPerMass = interp1(obj.beadTimes, ...
                                            normFactor, ...
                                            obj.data(:, 1), ...
                                            'linear');
            %extrapolate by adding the lowest/highest value
            tstart=find(~isnan(obj.normFactorPerMass(:,1)), 1, 'first');
            obj.normFactorPerMass(1:tstart, :) = repmat(obj.normFactorPerMass(tstart, :), ...
                                                        tstart, ...
                                                        1);
            tend=find(~isnan(obj.normFactorPerMass(:,1)), 1, 'last');
            obj.normFactorPerMass(tend:end, :) = repmat(obj.normFactorPerMass(tend, :), ...
                                                        size(obj.normFactorPerMass, 1)-tend+1, ...
                                                        1);
        end
        function obj = applyStandardNormalization(obj)
            if (isempty(obj.options.beadMedians))
                beadMedians = median(obj.beadValues);
            else
                beadMedians = obj.options.beadMedians;
            end
            normFactor = repmat(   sum(obj.beadValues.*repmat(beadMedians, sum(obj.indicesBeads), 1), 2) ...
                                ./ sum(obj.beadValues.^2, 2), 1, 176-140);
            obj = obj.generalizeNormalizationFactor(normFactor);
            obj = obj.mapPerMassNormalizationToChannels();
            obj.data = obj.data .* obj.normFactorPerChannel;
            if (obj.options.emitPlots)
                obj = obj.populateBeadValues();
                obj = obj.smoothBeadValues();
            end
        end
        function obj = applySplineNormalization(obj)
            if (isempty(obj.options.beadMedians))
                beadMedians = median(obj.beadValues);
            else
                beadMedians = obj.options.beadMedians;
            end
            beadMasses = [140; 142; 151; 153; 165; 175];
            numBeads = sum(obj.indicesBeads);
            normFactor = zeros(numBeads, 176-140);
            correctionFactors = repmat(beadMedians, numBeads, 1) ./ obj.beadValues;
            for i=1:numBeads
                if (obj.options.verbosityLevel > 0)
                    if (i==1)
                        nextStepToReport = 0;
                    end
                    if (i/numBeads > nextStepToReport)
                        disp([indent(obj.options.indentationLevel) ...
                              'SplineNormalization: Processing bead events [' ...
                              num2str(ceil(nextStepToReport*numBeads)) ...
                              ', ' ...
                              num2str(ceil((nextStepToReport+0.1)*numBeads)) ...
                              '] from a total of ' ...
                              num2str(numBeads) ...
                              '...']);
                        nextStepToReport = nextStepToReport + 0.1;
                    end
                end
                f = fit(beadMasses, ...
                        correctionFactors(i, :)', ...
                        'smoothingspline', ...
                        'SmoothingParam', obj.options.smoothingParam);
                normFactor(i, :) = f(140:175);
            end
            obj = obj.generalizeNormalizationFactor(normFactor);
            obj = obj.mapPerMassNormalizationToChannels();
            obj.data = obj.data .* obj.normFactorPerChannel;
            if (obj.options.emitPlots)
                obj = obj.populateBeadValues();
                obj = obj.smoothBeadValues();
            end
        end
        function obj = applyNormalization(obj)
            switch (obj.options.method)
                case 'standard'
                    obj = applyStandardNormalization(obj);
                case 'splorm'
                    obj = applySplineNormalization(obj);
            end
        end
        function obj = mapPerMassNormalizationToChannels(obj)
            obj.normFactorPerChannel = ones(size(obj.data));
            if (obj.options.automaticMassToChannelMap)
                for i=1:length(obj.masses)
                    if (~isnan(obj.masses(i)))
                        if (obj.masses(i) < 140)
                            obj.normFactorPerChannel(:, i) = obj.normFactorPerMass(:, 1);
                        elseif (obj.masses(i) > 175)
                            obj.normFactorPerChannel(:, i) = obj.normFactorPerMass(:, 36);
                        else
                            obj.normFactorPerChannel(:, i) = obj.normFactorPerMass(:, obj.masses(i)-139);
                        end
                    end
                end
            else
                % This map is dependent on the panel. The mapping should
                % be stored in a more concise format as option. It may also
                % be possible to infer the mapping (semi-)automatically from
                % the info in the .fcs-file
                % UPDATE: I think that the implementation above will outdate this
                %         as it should do everything that is required, but for now,
                %         I leave it in ...
                obj.normFactorPerChannel(:,  3) = obj.normFactorPerMass(:,  1); %89
                obj.normFactorPerChannel(:,  4) = obj.normFactorPerMass(:,  1); %102
                obj.normFactorPerChannel(:,  5) = obj.normFactorPerMass(:,  1); %104
                obj.normFactorPerChannel(:,  6) = obj.normFactorPerMass(:,  1); %105
                obj.normFactorPerChannel(:,  7) = obj.normFactorPerMass(:,  1); %106
                obj.normFactorPerChannel(:,  8) = obj.normFactorPerMass(:,  1); %108
                obj.normFactorPerChannel(:,  9) = obj.normFactorPerMass(:,  1); %110
                obj.normFactorPerChannel(:, 10) = obj.normFactorPerMass(:,  1); %140
                obj.normFactorPerChannel(:, 11) = obj.normFactorPerMass(:,  2); %141
                obj.normFactorPerChannel(:, 12) = obj.normFactorPerMass(:,  3); %142
                obj.normFactorPerChannel(:, 13) = obj.normFactorPerMass(:,  3); %142
                obj.normFactorPerChannel(:, 14) = obj.normFactorPerMass(:,  4); %143
                obj.normFactorPerChannel(:, 15) = obj.normFactorPerMass(:,  5); %144
                obj.normFactorPerChannel(:, 16) = obj.normFactorPerMass(:,  6); %145
                obj.normFactorPerChannel(:, 17) = obj.normFactorPerMass(:,  7); %146
                obj.normFactorPerChannel(:, 18) = obj.normFactorPerMass(:,  8); %147
                obj.normFactorPerChannel(:, 19) = obj.normFactorPerMass(:,  9); %148
                obj.normFactorPerChannel(:, 20) = obj.normFactorPerMass(:, 10); %149
                obj.normFactorPerChannel(:, 21) = obj.normFactorPerMass(:, 11); %150
                obj.normFactorPerChannel(:, 22) = obj.normFactorPerMass(:, 12); %151
                obj.normFactorPerChannel(:, 23) = obj.normFactorPerMass(:, 13); %152
                obj.normFactorPerChannel(:, 24) = obj.normFactorPerMass(:, 14); %153
                obj.normFactorPerChannel(:, 25) = obj.normFactorPerMass(:, 15); %154
                obj.normFactorPerChannel(:, 26) = obj.normFactorPerMass(:, 16); %155
                obj.normFactorPerChannel(:, 27) = obj.normFactorPerMass(:, 17); %156
                obj.normFactorPerChannel(:, 28) = obj.normFactorPerMass(:, 19); %158
                obj.normFactorPerChannel(:, 29) = obj.normFactorPerMass(:, 20); %159
                obj.normFactorPerChannel(:, 30) = obj.normFactorPerMass(:, 21); %160
                obj.normFactorPerChannel(:, 31) = obj.normFactorPerMass(:, 22); %161
                obj.normFactorPerChannel(:, 32) = obj.normFactorPerMass(:, 23); %162
                obj.normFactorPerChannel(:, 33) = obj.normFactorPerMass(:, 24); %163
                obj.normFactorPerChannel(:, 34) = obj.normFactorPerMass(:, 25); %164
                obj.normFactorPerChannel(:, 35) = obj.normFactorPerMass(:, 26); %165
                obj.normFactorPerChannel(:, 36) = obj.normFactorPerMass(:, 27); %166
                obj.normFactorPerChannel(:, 37) = obj.normFactorPerMass(:, 28); %167
                obj.normFactorPerChannel(:, 38) = obj.normFactorPerMass(:, 29); %168
                obj.normFactorPerChannel(:, 39) = obj.normFactorPerMass(:, 30); %169
                obj.normFactorPerChannel(:, 40) = obj.normFactorPerMass(:, 31); %170
                obj.normFactorPerChannel(:, 41) = obj.normFactorPerMass(:, 32); %171
                obj.normFactorPerChannel(:, 42) = obj.normFactorPerMass(:, 33); %172
                obj.normFactorPerChannel(:, 43) = obj.normFactorPerMass(:, 34); %173
                obj.normFactorPerChannel(:, 44) = obj.normFactorPerMass(:, 35); %174
                obj.normFactorPerChannel(:, 45) = obj.normFactorPerMass(:, 36); %175
                obj.normFactorPerChannel(:, 46) = obj.normFactorPerMass(:, 36); %176
                obj.normFactorPerChannel(:, 47) = obj.normFactorPerMass(:, 36); %191
                obj.normFactorPerChannel(:, 48) = obj.normFactorPerMass(:, 36); %193
                obj.normFactorPerChannel(:, 49) = obj.normFactorPerMass(:, 36); %195
                obj.normFactorPerChannel(:, 50) = obj.normFactorPerMass(:, 36); %209
            end
        end
        function obj = discardBeadEvents(obj)
            obj.data = obj.data(~obj.indicesWithBeads, :);
        end
        function obj = populateValidationValues(obj)
            obj.validationValuesBefore = [];
            for marker = obj.options.validationMarkers
                obj.validationValuesBefore = [ obj.validationValuesBefore obj.data(~obj.indicesWithBeads, obj.name2Channel(marker{1})) ];
            end
        end
        function obj = plotValidationValuesBeforeAndAfter(obj)
            validationValuesAfter = [];
            for marker = obj.options.validationMarkers
                validationValuesAfter = [ validationValuesAfter obj.data(~obj.indicesWithBeads, obj.name2Channel(marker{1})) ];
            end
            validationValuesBefore = CyTOFData.transform(obj.validationValuesBefore, 1);
            validationValuesAfter = CyTOFData.transform(validationValuesAfter, 1);
            time = obj.data(~obj.indicesWithBeads, 1)/1000;
            smoothingWindow = 10 * obj.options.smoothingWindow;
            for i = 1:(size(validationValuesAfter, 1)-smoothingWindow)
                validationValuesBefore(i, :) = median(validationValuesBefore(i:(i+smoothingWindow), :));
                validationValuesAfter(i, :) = median(validationValuesAfter(i:(i+smoothingWindow), :));
                time(i, :) = median(time(i:(i+smoothingWindow)));
            end
            validationValuesBefore = validationValuesBefore(1:(size(validationValuesBefore, 1)-smoothingWindow), :);
            validationValuesAfter = validationValuesAfter(1:(size(validationValuesAfter, 1)-smoothingWindow), :);
            time = time(1:(length(time)-smoothingWindow));
            for i = 1:size(validationValuesAfter, 2)
                figure
                plot(time, validationValuesBefore(:, i)/validationValuesBefore(1, i));
                yInt = ylim();
                xlabel('Time (s)');
                ylabel([obj.options.labelsValidationMarkers{i} ' (smoothed, normalized)']);
                set(gcf, 'Color', 'w');
                set(gcf, 'Position', [1367 351 800 550]);
                set(gca, 'fontsize', 18);
                figure
                plot(time, validationValuesAfter(:, i)/validationValuesAfter(1, i));
                ylim(yInt);
                xlabel('Time (s)');
                ylabel([obj.options.labelsValidationMarkers{i} ' (smoothed, normalized)']);
                set(gcf, 'Color', 'w');
                set(gcf, 'Position', [1367 351 800 550]);
                set(gca, 'fontsize', 18);
            end
        end
    end
end
