rng(021082)
addpath('../Infrastructure/Source');

close all

[data, experiments] = readData();
keys = experiments.keys;

maxDNA1 = 0;
maxDNA2 = 0;
for experiment=1:size(data, 2)
    columnDNA1 = find(ismember(data{experiment}.channelNames, 'Ir191Di'));
    columnDNA2 = find(ismember(data{experiment}.channelNames, 'Ir193Di'));
    maxDNA1 = max(maxDNA1, max(data{experiment}.dataTransformed(:, columnDNA1)));
    maxDNA2 = max(maxDNA2, max(data{experiment}.dataTransformed(:, columnDNA2)));
end
%%
for experiment=1:length(experiments)
    plotDNA1DNA2Plot(data{experiment}, ['PlotsIntercalation/' keys{experiment}], 'maxDNA1', maxDNA1, 'maxDNA2', maxDNA2);
    b0 = brush(gcf);
    dataset = keys{experiment};
    title(dataset)
    set(b0, 'ActionPostCallBack', @(ohf, s) storeIntercalationInterval(ohf, s, dataset), 'enable', 'on');
end
