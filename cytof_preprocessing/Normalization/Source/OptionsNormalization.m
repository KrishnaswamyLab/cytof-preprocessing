classdef OptionsNormalization
    properties
        method = 'standard';
        expId = '';
        prefix = 'norm';
        smoothingWindow = 300;
        thresholdDNA1;
        intervalBeads = [];
        labelsBeads = {};
        emitPlots = true;
        plotOutputFolder = './PlotsNormalization';
        emitNormalizedData = true;
        dataOutputFolder = './DerivedData';
        verbosityLevel = 1;
        indentationLevel = 0;
        smoothingParam = 0.1;
        automaticMassToChannelMap = true;
        beadChannelNames = [];
        beadMedians = [];
        validationMarkers = {};
        labelsValidationMarkers = {};
        beadStandard = '4El';
    end
    methods
        function obj = OptionsNormalization(varargin)
            % parsing of variable argument list
            for i=1:length(varargin)-1
                if (strcmp(varargin{i}, 'BeadStandard'))
                     obj.beadStandard = varargin{i+1};
                end
            end
            switch (obj.beadStandard)
                case '4El'
                    obj.intervalBeads(1, :) = [5.5 9.4];
                    obj.intervalBeads(2, :) = [4   9.5];
                    obj.intervalBeads(3, :) = [5.5 9.4];
                    obj.intervalBeads(4, :) = [5.5 9.4];
                    obj.intervalBeads(5, :) = [5.5 9.4];
                    obj.intervalBeads(6, :) = [5.5 9.4];
%                     7th bead?
%                     obj.intervalBeads(7, :) = [5.5 9.4];
                    obj.labelsBeads = {'Beads 1 (140ce)', 'Beads 2 (142ce)', 'Beads 3 (151eu)', ...
                                                               'Beads 4 (153eu)', 'Beads 5 (165ho)', 'Beads 6 (175lu)'};
%                         'Beads 4 (153eu)', 'Beads 5 (165ho)', 'Beads 6 (175lu)', 'Beads 7 (176Lu)'};

                                        
                case '1El'
                    obj.intervalBeads(1, :) = [5.5 9.4];
                    obj.intervalBeads(2, :) = [5.5 9.4];
                    obj.labelsBeads = {'Beads 1 (151eu)', 'Beads 2 (153eu)'};
            end
            obj.thresholdDNA1 = 4;
        end
        function str = asString(obj)
            str = [obj.prefix '_' ...
                   obj.method '_' ...
                   obj.expId];
        end
    end
end
