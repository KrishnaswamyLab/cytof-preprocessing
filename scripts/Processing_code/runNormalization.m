function prefixes = runNormalization(fcs_directory)
% Performs bead normalization on ALL fcs files in fcs_directory and normalizes all files to the same level. 
% Right now the code is written to do bead normalization with 4 elements. It needs to be modified if only 1 element is used.

% Based on code written by Tobias Welp
% Modified by Krishnan Srinivasan and Kevin Moon, June 2017

% Add the paths
addpath('scripts/Normalization/Source');
addpath('scripts/Infrastructure/Source');
addpath('scripts/export_fig')

% Add the appropriate output folders if they do not exist
plotOutputFolder='PlotsNormalization';
dataOutputFolder='Normalized';
if (~isdir(plotOutputFolder))
    mkdir(plotOutputFolder);
end

if (~isdir(dataOutputFolder))
    mkdir(dataOutputFolder);
end

% Runs normalization on fcs files located in a specified folder
filenames = dir(fullfile(fcs_directory, '*.fcs'));
prefixes = cell(length(filenames));
for i=1:length(filenames)
    prefix=filenames(i).name(1:end-4);
    prefixes{i} = prefix;
end

for i=1:size(prefixes)
    options = OptionsNormalization();
    options.emitPlots = true;
    options.plotOutputFolder = plotOutputFolder;
    options.emitNormalizedData = true;
    options.dataOutputFolder = dataOutputFolder;
    options.expId = '0';
%     options.method = 'splorm';
    options.method='standard';
    options.prefix = prefixes{i};
    options.automaticMassToChannelMap = true;
%     options.beadChannelNames={
%     options.beadStandard='1El';
%     options.beadChannelNames = {'Eu151Di', 'Eu153Di'};
    options.beadChannelNames = {'Ce140Di', 'Nd142Di', 'Eu151Di', 'Eu153Di', 'Ho165Di', 'Lu175Di'};
%     options.beadChannelNames = {'Ce140Di', 'Ce142Di', 'Eu151Di', 'Eu153Di', 'Ho165Di', 'Lu175Di', 'Lu176Di'};
    %options.dNA1ChannelName = 'dna1';
    data{i} = NormalizationCyTOFData(fullfile(fcs_directory, filenames(i).name), options);
    data{i} = data{i}.populateBeadIndices();
    data{i} = data{i}.populateBeadValues();
    pause(10);
    close all;
end

allBeadValues = [];
for i=1:length(filenames)
    allBeadValues = [ allBeadValues ; data{i}.beadValues ];
end
beadMedianOverall = median(allBeadValues);

for i=1:length(filenames)
    data{i}.options.beadMedians = beadMedianOverall;
    data{i} = normalize(data{i});
    
    pause(10);
    close all;
end
end
