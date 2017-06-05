function data=gateData(dataInput,experiments,channel1,channel2)
% gateData(data,experiments,channel1,channel2)
% Allows the user to select points from  visualizing channel1 and
% channel2 in each dataset. Can be used to gate using dna1 and dna2, cd45,
% etc. 
% dataInput = output from readNormalizedData()
% experiments = second output from readNormalizedData()
% channel1 will give the x axis for the plot
% channel2 will give the y axis for the plot
% saveFCS indicates whether the processed data should be saved as .fcs file

% Author: Kevin Moon
% Created: June 2017

% Requires the following path to work
% addpath('../Infrastructure/Source');


% Closing all figures isn't strictly necessary but it does help prevent
% problems with the selectdata tool
close all 
data=dataInput;
% Find the maximum of the channels over all datasets. This gives a
% consistent range for all datasets
max1=0;
max2=0;

for m=1:size(data, 2)
    column1 = ismember(data{m}.channelNames, channel1);
    column2 = ismember(data{m}.channelNames, channel2);
    max1 = max(max1, max(data{m}.dataTransformed(:, column1)));
    max2 = max(max2, max(data{m}.dataTransformed(:, column2)));
end

% Select the cells from each dataset
for m=1:length(experiments)
    prefixFilename=['PlotsIntercalation/' experiments(m).name(1:end-4)];
    plotChannels(data{m},channel1,channel2,prefixFilename , 'max1', max1, 'max2', max2);
    pl=selectdata;
    data{m}.dataTransformed=data{m}.dataTransformed(pl{2},:);
    data{m}.data=data{m}.data(pl{2},:);
    
    
end
