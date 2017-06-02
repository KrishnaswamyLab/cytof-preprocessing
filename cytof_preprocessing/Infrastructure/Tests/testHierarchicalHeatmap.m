addpath('../Source');

% Test 1: 20 dimensional heatmap of randomly generated data, three levels of hierarchy.

% Generate cluster assignments
clusterAssignments = zeros(1000, 3);
clusterAssignments(1:400, 1) = 1;
clusterAssignments(401:1000, 1) = 2;
clusterAssignments(1:150, 2) = 1;
clusterAssignments(151:400, 2) = 2;
clusterAssignments(401:900, 2) = 3;
clusterAssignments(901:1000, 2) = 4;
clusterAssignments(1:50, 3) = 1;
clusterAssignments(51:150, 3) = 2;
clusterAssignments(151:400, 3) = 3;
clusterAssignments(401:550, 3) = 4;
clusterAssignments(551:900, 3) = 5;
clusterAssignments(901:1000, 3) = 6;

%Generate datapoints data at random
rng(021082);
dataPoints = zeros(1000, 9);
dataPoints(1:400, 1) = rand(1) + 0.25*rand(400, 1);
dataPoints(401:1000, 1) = rand(1) + 0.05*rand(600, 1);
dataPoints(1:400, 2) = rand(1) + 0.05*rand(400, 1);
dataPoints(401:1000, 2) = rand(1) + 0.05*rand(600, 1);
dataPoints(1:400, 3) = rand(1) + 0.08*rand(400, 1);
dataPoints(401:1000, 3) = rand(1) + 0.05*rand(600, 1);
dataPoints(1:150, 4) = rand(1) + 0.05*rand(150, 1);
dataPoints(151:400, 4) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:900, 4) = rand(1) + 0.05*rand(500, 1);
dataPoints(901:1000, 4) = rand(1) + 0.05*rand(100, 1);
dataPoints(1:150, 5) = rand(1) + 0.05*rand(150, 1);
dataPoints(151:400, 5) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:900, 5) = rand(1) + 0.05*rand(500, 1);
dataPoints(901:1000, 5) = rand(1) + 0.05*rand(100, 1);
dataPoints(1:150, 6) = rand(1) + 0.01*rand(150, 1);
dataPoints(151:400, 6) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:900, 6) = rand(1) + 0.05*rand(500, 1);
dataPoints(901:1000, 6) = rand(1) + 0.05*rand(100, 1);
dataPoints(1:50, 7) = rand(1) + 0.05*rand(50, 1);
dataPoints(51:150, 7) = rand(1) + 0.15*rand(100, 1);
dataPoints(151:400, 7) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:550, 7) = rand(1) + 0.05*rand(150, 1);
dataPoints(551:900, 7) = rand(1) + 0.05*rand(350, 1);
dataPoints(901:1000, 7) = rand(1) + 0.05*rand(100, 1);
dataPoints(1:50, 8) = rand(1) + 0.05*rand(50, 1);
dataPoints(51:150, 8) = rand(1) + 0.05*rand(100, 1);
dataPoints(151:400, 8) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:550, 8) = rand(1) + 0.05*rand(150, 1);
dataPoints(551:900, 8) = rand(1) + 0.05*rand(350, 1);
dataPoints(901:1000, 8) = rand(1) + 0.05*rand(100, 1);
dataPoints(1:50, 9) = rand(1) + 0.05*rand(50, 1);
dataPoints(51:150, 9) = rand(1) + 0.05*rand(100, 1);
dataPoints(151:400, 9) = rand(1) + 0.05*rand(250, 1);
dataPoints(401:550, 9) = rand(1) + 0.05*rand(150, 1);
dataPoints(551:900, 9) = rand(1) + 0.05*rand(350, 1);
dataPoints(901:1000, 9) = rand(1) + 0.05*rand(100, 1);

hierarchicalHeatmap(dataPoints, clusterAssignments, 'colorsHeatMap', 'ysm');
