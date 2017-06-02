function [ data, experiments ] = readProcessedData()
    experiments = containers.Map('UniformValues', false);
    
%     experiments('NV14-01-mock') = strcat('NV14-01-mock_processed.fcs');
%     experiments('NV14-03-mock') = strcat('NV14-03-mock_processed.fcs');
%     experiments('NV14-04-mock') = strcat('NV14-04-mock_processed.fcs');
%     experiments('NV14-05-mock') = strcat('NV14-05-mock_processed.fcs');
%     experiments('NV14-06-mock') = strcat('NV14-06-mock_processed.fcs');
%     experiments('NV14-08-mock') = strcat('NV14-08-mock_processed.fcs');
%     experiments('NV14-17-mock') = strcat('NV14-17-mock_processed.fcs');
%     experiments('NV15-21-mock') = strcat('NV15-21-mock_processed.fcs');
%     experiments('NV15-22-mock') = strcat('NV15-22-mock_processed.fcs');
%     experiments('NV15-23-mock') = strcat('NV15-23-mock_processed.fcs');
%     experiments('NV15-31-mock') = strcat('NV15-31-mock_processed.fcs');
%     experiments('NVP15-24-mock') = strcat('NVP15-24-mock_processed.fcs');
%     experiments('NVP15-25-mock') = strcat('NVP15-25-mock_processed.fcs');
    experiments('110164_DENV-MOI 5_14Oct2016_01')=strcat('110164_DENV-MOI 5_14Oct2016_01_processed.fcs');
    experiments('110164_Mock-DENV_14Oct2016_01')=strcat('110164_Mock-DENV_14Oct2016_01_processed.fcs');
    experiments('110164_Mock_14Oct2016_01')=strcat('110164_Mock_14Oct2016_01_processed.fcs');
    experiments('110164_ZIKV-MOI 1_14Oct2016_01')=strcat('110164_ZIKV-MOI 1_14Oct2016_01_processed.fcs');
    experiments('110164_ZIKV-MOI 5_14Oct2016_01')=strcat('110164_ZIKV-MOI 5_14Oct2016_01_processed.fcs');
    experiments('NY110315_DENV-MOI 5_14Oct2016_01')=strcat('NY110315_DENV-MOI 5_14Oct2016_01_processed.fcs');
    experiments('NY110315_Mock-DENV_14Oct2016_01')=strcat('NY110315_Mock-DENV_14Oct2016_01_processed.fcs');
    experiments('NY110315_Mock_14Oct2016_01')=strcat('NY110315_Mock_14Oct2016_01_processed.fcs');
    experiments('NY110315_Mock_14Oct2016_02')=strcat('NY110315_Mock_14Oct2016_02_processed.fcs');
    experiments('NY110315_Mock_14Oct2016_03')=strcat('NY110315_Mock_14Oct2016_03_processed.fcs');
    experiments('NY110315_Mock_14Oct2016_04')=strcat('NY110315_Mock_14Oct2016_04_processed.fcs');
    experiments('NY110315_ZIKV-MOI 1_14Oct2016_03')=strcat('NY110315_ZIKV-MOI 1_14Oct2016_03_processed.fcs');
    experiments('NY110315_ZIKV-MOI 1_14Oct2016_04')=strcat('NY110315_ZIKV-MOI 1_14Oct2016_04_processed.fcs');
    experiments('NY110315_ZIKV-MOI 5_14Oct2016_04')=strcat('NY110315_ZIKV-MOI 5_14Oct2016_04_processed.fcs');
    experiments('NY110315_ZIKV-MOI 5_14Oct2016_05')=strcat('NY110315_ZIKV-MOI 5_14Oct2016_05_processed.fcs');
    

    disp('Reading data...');
    data = {};
    keys = experiments.keys();
    for i=1:length(keys)
        disp(['    Experiment: ' keys{i}]);
        filename = experiments(keys{i});
        data{i} = CyTOFData(['ProcessedData/' filename]);
    end
end