function [ data, experiments ] = readNormalizedData()
% Reads in bead normalized data from the directory /Normalized and does the
% arcsin transform

% Author: Kevin Moon
% Created: June 2017
    experiments=dir('Normalized/*.fcs');
    

    disp('Reading data...');
    data = {};
    for i=1:length(experiments)
        disp(['    Experiment: ' experiments(i).name]);
        filename = experiments(i).name;

%         Read data
        data{i} = CyTOFData(['Normalized/' filename]);

%         Transform data
        data{i} = data{i}.transformAllIsotopeChannels(1);

    end
end
