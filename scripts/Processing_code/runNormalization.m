function prefixes = runNormalization(fcs_directory)

addpath('scripts/Normalization/Source');
addpath('scripts/Infrastructure/Source');
addpath('scripts/export_fig')

% Runs normalization on fcs files located in a specified folder
filenames = dir(fullfile(fcs_directory, '*.fcs'));
prefixes = cell(length(filenames));
for i=1:length(filenames)
    prefix = split(filenames(i).name, '.');
    prefix = prefix{1};
    prefixes{i} = prefix;
end

for i=1:size(prefixes)
    options = OptionsNormalization();
    options.emitPlots = true;
    options.plotOutputFolder = 'PlotsNormalization';
    options.emitNormalizedData = true;
    options.dataOutputFolder = 'Normalized';
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

if (~isdir(options.plotOutputFolder))
    mkdir(options.plotOutputFolder);
end

if (~isdir(options.dataOutputFolder))
    mkdir(options.dataOutputFolder);
end

for i=1:length(filenames)
    data{i}.options.beadMedians = beadMedianOverall;
    data{i} = normalize(data{i});
    
    pause(10);
    close all;
end
end