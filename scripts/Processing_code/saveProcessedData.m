function saveProcessedData(data,experiments,file_suffix)
% Saves the processed data in the folder ProcessedData. Allows the option
% for a different file suffix

% Written by Kevin Moon, June 2017


if (~isdir('ProcessedData'))
    mkdir('ProcessedData');
end

if isempty(file_suffix)
    file_suffix='_processed';
end
    

fprintf('%s\n','Saving Processed Files')
for i=1:length(experiments)
    savefile=['./ProcessedData/' experiments(i).name(1:end-4) file_suffix '.fcs'];
    data{i}.writeData(savefile);
end
