addpath('../../Source/');

options = OptionsNormalization();
options.emitPlots = true;
options.emitNormalizedData = true;
options.prefix = 'lC';
options.expId = '0';
options.method = 'splorm';
data = NormalizationCyTOFData('~/Dropbox/DataSets/LC/Khadir-SK RD3435 Healthy-60216_run 1.FCS', options);

data = normalize(data);
