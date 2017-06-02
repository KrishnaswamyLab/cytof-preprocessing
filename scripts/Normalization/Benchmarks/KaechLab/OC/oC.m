addpath('../../../Source/');

options = OptionsNormalization();
options.emitPlots = true;
options.emitNormalizedData = true;
options.prefix = 'oC';
options.expId = '0';
options.method = 'splorm';
data = NormalizationCyTOFData('~/Dropbox/DataSets/KaechLab/OC/June 30-SK2_01.FCS', options);

data = normalize(data);
