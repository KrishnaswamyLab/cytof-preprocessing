% Gives an example of how to run the cytof preprocessing code
% Written by Kevin Moon, June 2017

%% Add paths
addpath('../Normalization/Source');
addpath('../Infrastructure/Source');
addpath('../export_fig')


%% bead normalization
% This performs bead normalization on all fcs files in the chosen directory
% and then saves the files to the folder Normalized
datafolder='RawData';
prefixes=runNormalization(datafolder);

%% Read in the normalized data
% This reads in ALL fcs files in the folder Normalized into a structure containing CyTOFData object. 
% This also transforms the data using arcsinh transform. You should delete
% all fcs files in this folder that you do not want to read
[ data, experiments ] = readNormalizedData();

%% The following can be used to do a linear normalization with regards to spike-in samples

% The exact channel used for spike-in cd45 may vary. But usually it's
% either 112cd or 114cd. Gating with cd45 also helps to remove debris in
% (all?) immune cells as cells should be high in cd45.

disp('Gate for the SAMPLE data')
dataSample=gateData(data,experiments,'Y89Di','Cd112Di');

disp('Gate for the SPIKE-IN data')
dataSpike=gateData(data,experiments,'Y89Di','Cd112Di');

% Linear normalization
data=linearNormSpikein(dataSample,dataSpike,experiments,[]);

%% Further standard gating

% Gate for doublets using DNA1 and DNA2. We usually want lower DNA or DNA
% around the main concentration. Doublets are expected to have higher DNA
% content while debris may have lower DNA content.
data=gateData(data,experiments,'Ir191Di','Ir193Di');

% Gate for live/dead cells using cisplatin. Live cells should usually have
% lower cisplatin. So either filter out the tale of the distribution if
% there is a single peak, or choose the lower peak if there are two peaks.
data=gateData(data,experiments,'Pt195Di','Ir191Di');

%% Save the processed data
% This saves the processed data into the folder ProcessedData as fcs files. 

file_suffix='_processed';
saveProcessedData(data,experiments,file_suffix)

%% Read the processed data
% This reads in ALL fcs files in the folder ProcessedData into a structure
% containing CyTOFData objects. You should delete all fcs files in this
% folder that you do not want to read.
[ data, experiments ] = readProcessedData();



