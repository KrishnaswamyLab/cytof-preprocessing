function [ data, experiments ] = readData()
    experiments = containers.Map('UniformValues', false);
    
    experiments('162024 ZIKV MOI 5_10Jan2017_01')=strcat('162024 ZIKV MOI 5_10Jan2017_01_standard_0_normalized.fcs');
    experiments('162024 MOCK_10Jan2017_01')=strcat('162024 MOCK_10Jan2017_01_standard_0_normalized.fcs');
    experiments('NYC102516 ZIKV MOI 5_10Jan2017_01')=strcat('162024 ZIKV MOI 5_10Jan2017_01_standard_0_normalized.fcs');
    experiments('NYC102516 MOCK_10Jan2017_01')=strcat('NYC102516 MOCK_10Jan2017_01_standard_0_normalized.fcs');
%      experiments('110164_DENV-MOI 5_14Oct2016_01')=strcat('110164_DENV-MOI 5_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('110164_Mock-DENV_14Oct2016_01')=strcat('110164_Mock-DENV_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('110164_Mock_14Oct2016_01')=strcat('110164_Mock_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('110164_ZIKV-MOI 1_14Oct2016_01')=strcat('110164_ZIKV-MOI 1_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('110164_ZIKV-MOI 5_14Oct2016_01')=strcat('110164_ZIKV-MOI 5_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('NY110315_DENV-MOI 5_14Oct2016_01')=strcat('NY110315_DENV-MOI 5_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('NY110315_Mock-DENV_14Oct2016_01')=strcat('NY110315_Mock-DENV_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('NY110315_Mock_14Oct2016_01')=strcat('NY110315_Mock_14Oct2016_01_standard_0_normalized.fcs');
%     experiments('NY110315_Mock_14Oct2016_02')=strcat('NY110315_Mock_14Oct2016_02_standard_0_normalized.fcs');
%     experiments('NY110315_Mock_14Oct2016_03')=strcat('NY110315_Mock_14Oct2016_03_standard_0_normalized.fcs');
%     experiments('NY110315_Mock_14Oct2016_04')=strcat('NY110315_Mock_14Oct2016_04_standard_0_normalized.fcs');
%     experiments('NY110315_ZIKV-MOI 1_14Oct2016_03')=strcat('NY110315_ZIKV-MOI 1_14Oct2016_03_standard_0_normalized.fcs');
%     experiments('NY110315_ZIKV-MOI 1_14Oct2016_04')=strcat('NY110315_ZIKV-MOI 1_14Oct2016_04_standard_0_normalized.fcs');
%     experiments('NY110315_ZIKV-MOI 5_14Oct2016_04')=strcat('NY110315_ZIKV-MOI 5_14Oct2016_04_standard_0_normalized.fcs');
%     experiments('NY110315_ZIKV-MOI 5_14Oct2016_05')=strcat('NY110315_ZIKV-MOI 5_14Oct2016_05_standard_0_normalized.fcs');


    %{
    experiments('NVP14-12-mock') = strcat('NVP14-12-mock_splorm_0_normalized.fcs');
    experiments('NVP14-12F-mock')= strcat('NVP14-12F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-25-mock') = strcat('NVP14-25-mock_splorm_0_normalized.fcs');
    experiments('NVP14-25F-mock')= strcat('NVP14-25F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-27-mock') = strcat('NVP14-27-mock_splorm_0_normalized.fcs');
    experiments('NVP14-27F-mock')= strcat('NVP14-27F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-29-mock') = strcat('NVP14-29-mock_splorm_0_normalized.fcs');
    experiments('NVP14-29F-mock')= strcat('NVP14-29F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-30-mock') = strcat('NVP14-30-mock_splorm_0_normalized.fcs');
    experiments('NVP14-30F-mock')= strcat('NVP14-30F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-33-mock') = strcat('NVP14-33-mock_splorm_0_normalized.fcs');
    experiments('NVP14-33F-mock')= strcat('NVP14-33F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP14-35-mock') = strcat('NVP14-35-mock_splorm_0_normalized.fcs');
    experiments('NVP14-35F-mock')= strcat('NVP14-35F-mock_splorm_0_normalized.fcs');
   
    experiments('NVP15-01-mock') = strcat('NVP15-01-mock_splorm_0_normalized.fcs');
    experiments('NVP15-01F-mock') = strcat('NVP15-01F-mock_splorm_0_normalized.fcs');
    
    experiments('NVP15-02-mock') = strcat('NVP15-02-mock_splorm_0_normalized.fcs');
    experiments('NVR15-02-mock') = strcat('NVR15-02-mock_splorm_0_normalized.fcs');
    
    experiments('NVP15-03-mock') = strcat('NVP15-03-mock_splorm_0_normalized.fcs');
    experiments('NVR15-03-mock') = strcat('NVR15-03-mock_splorm_0_normalized.fcs');
    
    experiments('NVP15-03-mock') = strcat('NVP15-03-mock_splorm_0_normalized.fcs');
    experiments('NVR15-03-mock') = strcat('NVR15-03-mock_splorm_0_normalized.fcs');
    
    experiments('NVP15-08-mock') = strcat('NVP15-08-mock_splorm_0_normalized.fcs');
	experiments('NVR15-08-mock') = strcat('NVR15-08-mock_splorm_0_normalized.fcs');
    
    experiments('NVP15-17-mock') = strcat('NVP15-17-mock_splorm_0_normalized.fcs');
	experiments('NVR15-17-mock') = strcat('NVR15-17-mock_splorm_0_normalized.fcs');
    
	experiments('NVP15-18-mock') = strcat('NVP15-18-mock_splorm_0_normalized.fcs');
	experiments('NVR15-18-mock') = strcat('NVP15-18-mock_splorm_0_normalized.fcs');

    experiments('NVP15-23-mock') = strcat('NVP15-23-mock_splorm_0_normalized.fcs');
	experiments('NVR15-23-mock') = strcat('NVR15-23-mock_splorm_0_normalized.fcs');
%}
%     panel = containers.Map('UniformValues', false);
%     panel('89') = 'CD45';
%     panel('141') = 'CD27';
%     panel('142') = 'CD19';
%     panel('143') = 'CD45RA';
%     panel('144') = 'TNFa';
%     panel('145') = 'CD16';
%     panel('146') = 'CD8a';
%     panel('147') = 'HLA-DR';
%     panel('148') = 'CCR4';
%     panel('149') = 'CD25';
%     panel('150') = 'MIP-1B';
%     panel('151') = 'CD123';
%     panel('152') = 'CD14';
%     panel('153') = 'CD69';
%     panel('154') = 'CD185';
%     panel('155') = 'CD4';
%     panel('156') = 'IL6';
%     panel('158') = 'CD3';
%     panel('159') = 'CC11c';
%     panel('160') = 'IFNg';
%     panel('161') = 'CD152';
%     panel('162') = 'CD56';
%     panel('163') = 'CD183';
%     panel('164') = 'CD45RO';
%     panel('165') = 'Foxp3';
%     panel('166') = 'CD24';
%     panel('167') = 'CD38';
%     panel('168') = 'IFNb';
%     panel('169') = 'TCRgd';
%     panel('170') = 'CCR7';
%     panel('171') = 'CCR6';
%     panel('172') = 'IgM';
%     panel('173') = 'CD57';
%     panel('174') = 'CD86';
%     panel('175') = 'CD279';
%     panel('176') = 'Perforin';
%     panel('191') = 'DNA1';
%     panel('193') = 'DNA2';
%     panel('195') = 'Dead-cell';
    

    disp('Reading data...');
    data = {};
    keys = experiments.keys();
    for i=1:length(keys)
        disp(['    Experiment: ' keys{i}]);
        filename = experiments(keys{i});
        data{i} = CyTOFData(['./DerivedData/' filename]);
        data{i} = data{i}.transformAllIsotopeChannels(1);
%         for channel = panel.keys();
%             columnChannel = [];
%             for j = 1:length(data{i}.channelNames)
%                 if (~isempty(strfind(data{i}.channelNames{j}, strcat(channel{1}, 'Di'))))
%                     columnChannel = j;
%                     break;
%                 end
%             end
%             if (isempty(columnChannel))
%                 %if (strcmp(channel{1},'172'))
%                 %    warning(['Channel 172 not available in dataset ', keys{i}])
%                 %    continue
%                 %elseif (strcmp(channel{1},'209'))
%                 %    warning(['Channel 209 not available in dataset ', keys{i}])
%                 %    continue
%                 %else
%                     channel{1}
%                     assert(~isempty(columnChannel));
%                 %end
%             end
%             oldName = data{i}.channel2Name(columnChannel);
%             newName = panel(channel{1});
%             %disp(['Cannel ' num2str(columnChannel) ' : ' oldName{1} ' -> ' newName])
%             remove(data{i}.name2Channel, oldName{1});
%             data{i}.channel2Name(columnChannel) = {newName};
%             data{i}.name2Channel(newName) = columnChannel;
%         end
    end
end
