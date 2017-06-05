function [ data, experiments ] = readProcessedData()
% Reads the processed data from the folder in ProcessedData into CyTOFData objects

% Author: Kevin Moon
% Created: June 2017

    experiments=dir('ProcessedData/*.fcs');
    

    disp('Reading data...');
    data = {};
    for i=1:length(experiments)
        disp(['    Experiment: ' experiments(i).name]);
        filename = experiments(i).name;
        data{i} = CyTOFData(['ProcessedData/' filename]);
    end
end