% Prereq: This script requires having successfully executed runNormalization.m to
% generate DerivedData with bead correction and bead removal

% Purpose: This script filters for single-nucleated, living cells


addpath('../Infrastructure/Source/');
%% read w/ arcsin transform of (:,3:42)
[data, experiments] = readData();
keys = experiments.keys();
%% intercalation
%intervalDNA1 = [4.2 5.56 ; 2.38 3.7 ; 3.4 5.46 ; 3.08 4.25; 3.76 5.15; 2.67 4.50; 3.76 5.43; 3.03 4.69; 4.57 6.07; 4.43 6.12; 4.80 6.51; 4.32 6.00; 3.99 5.55; 2.35 4.00; 2.75 4.13; 2.07 4.27;  3.06 4.82; 3.2 4.8  ; 2.18 3.84; 4.57 5.76; 4.25 5.63; 1.35 3.34; 1.91 3.79; 4.66 5.97; 4.56 5.60; 4.23 5.38];
%intervalDNA2 = [5 6.23   ; 3 4.45   ; 4.2 6.2  ; 3.72 4.94; 4.45 5.87; 3.44 5.19; 4.36 6.08; 3.72 5.38; 5.18 6.73; 5.08 6.79; 5.47 7.15; 4.90 6.66; 4.65 6.26; 2.94 4.62; 3.44 4.76; 2.75 4.93;  3.74 5.50; 3.9 5.43 ; 2.83 4.49; 5.28 6.42; 4.95 6.37; 2.05 3.98; 2.51 4.46; 5.30 6.64; 5.28 6.29; 4.90 6.13];
inter = loadIntercalationIntervals(keys);
intervalDNA1 = squeeze(inter(1,:,:))';
intervalDNA2 = squeeze(inter(2,:,:))';
%%
mingledX = [];


for experiment = 1:length(experiments) 
    keys(experiment)
    data{experiment} = data{experiment}.filterSingleNucleated(intervalDNA1(experiment,:), intervalDNA2(experiment,:), false, ['PlotsIntercalation/' keys{experiment}]);
%     data{experiment} = data{experiment}.filterSingleNucleated(intervalDNA1, intervalDNA2, true, ['PlotsIntercalation/' keys{experiment}]);
% 	pause(10);
%     close all;
end

%% live/dead
%intervalCisplatin = [6.35, 5.4, 6.3, 6.2, 5.9, 5.125, 5.7, 5.4, 4.7, 5.0, 5.4, 5.1, 5.6, 5.4, 4.7, 6.1, 4.5, 5.2, 4.4, 5.3, 5.7, 4.8, 4.8, 6.2, 5.2, 6];
% intervalCisplatin = [5.45,6.5,5.75,4.8,6.05,6,5.6,6.1,6,4.3,5.8,4.7,4.7];
% intervalCisplatin=4.3;
intervalCisplatin=[eps, eps, eps, eps, eps, eps, eps, eps, eps, eps, eps, eps, eps, eps, eps]; 
for experiment = 1:length(experiments)
    keys(experiment)
    data{experiment} = data{experiment}.filterLive(intervalCisplatin(experiment), true, ['PlotsLive/' keys{experiment}]);
end

%% writing processed files
if true
    fprintf('%s\n','Saving Processed Files')
    for i=1:length(keys)
        data{i}.writeData(strcat('./ProcessedData', '/', keys{i}, '_processed.fcs'));
    end
end
%}
%{
    
relData = data{experiment}.filterSingleNucleated(true, 40, 41, intervalDNA1(experiment, :), intervalDNA2(experiment, :), false, ['PlotsIntercalation/' keys{experiment}]);
relData = relData.filterLive(true, 42, 6, false, ['PlotsLive/' keys{experiment}]);


data = data.filterSingleNucleated(false,40,41,[4,5.6],[4.65,6.3],true,'Int_Dengue_');


% [4.2 5.56] [5 6.23]
% [2.38 3.7] [3 4.45]
% [3.4 5.46] [4.2 6.2]
% [3  4.4]    [3.7 5.2]
% [3.7 5.35]    [4.4 6]
% [2.75 4.6] [3.5 5.3]
% [3.2 4.8] [3.9 5.43]
% [1.68 3.77]   [2.31 4.38]
%%
% filter live / dead
data = data.filterLive(false,42,6.3,true,'DL_Dengue_');
%data = data.filterLive(false,42,5.2,true,'DL_Dengue_');
%data = data.filterLive(false,42,4.5,true,'DL_Dengue_');
% static method, be sure not to transform event length or runtime
data.data(:,3:end) = CyTOFData.transform(data.data(:,3:end),1);
%% filter T cells
thresholdCD3 = 5.7;
columnCD3 = data.name2Channel('cd3');

figure;histogram(data.data(:,columnCD3))
indicesTCells = data.data(:,columnCD3) > thresholdCD3;
T_cells = data.data(indicesTCells,:);
%%

columnCD4 = data.name2Channel('cd4');
columnCD8 = data.name2Channel('cd8a');
thresholdCD4 = 4.1;
thresholdCD8 = 4.6;

indicesCD4pCD8m =    (T_cells(:, columnCD4) > thresholdCD4) ...
                       & (T_cells(:, columnCD8) < thresholdCD8);
indicesCD4mCD8p =    (T_cells(:, columnCD4) < thresholdCD4) ...
                       & (T_cells(:, columnCD8) > thresholdCD8);
plotData = T_cells(:,[columnCD4,columnCD8]);
figure;
hold on
scatterX([NaN, NaN], 'colorAssignment', [1 0 0], 'transparency', 1);
scatterX([NaN, NaN], 'colorAssignment', [0 0 1], 'transparency', 1);
scatterX([NaN, NaN], 'colorAssignment', [0 0 0], 'transparency', 1);
legend({'CD4^+', 'CTL', 'rest'}, 'Location', 'northwest');

scatterX(plotData(indicesCD4pCD8m, :), ...
         'colorAssignment', repmat([1 0 0], sum(indicesCD4pCD8m), 1), ...
         'sizeAssignment', 0.5*ones(sum(indicesCD4pCD8m), 1), ...
         'transparency', 0.4, ...
         'addJitter', false);
scatterX(plotData(indicesCD4mCD8p, :), ...
         'colorAssignment', repmat([0 0 1], sum(indicesCD4mCD8p), 1), ...
         'sizeAssignment', 0.5*ones(sum(indicesCD4mCD8p), 1), ...
         'transparency', 0.4, ...
         'addJitter', false);
indicesRest = ~(indicesCD4mCD8p | indicesCD4pCD8m);
scatterX(plotData(indicesRest, :), ...
         'colorAssignment', repmat([0 0 0], sum(indicesRest), 1), ...
         'sizeAssignment', 0.5*ones(sum(indicesRest), 1), ...
         'transparency', 0.4, ...
         'addJitter', false);
     
[n,c] = hist3(plotData, [200 200]);
n(:,1) = 0;
n(1,:) = 0;
[X,Y] = meshgrid(c{1}, c{2});
n = conv2(n, 1/36 * ones(6,6), 'same');
contour(X, Y, n', 'LineWidth', 2, 'LevelStep', 11);
set(gcf, 'Color', 'w');
set(gcf, 'Position', [1367 1 1000 1000]);
xlabel('CD4 (145nd)');
ylabel('CD8 (146nd)');
set(gca, 'fontsize', 18);     

%}
%}