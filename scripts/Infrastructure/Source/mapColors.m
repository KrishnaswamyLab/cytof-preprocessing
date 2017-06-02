function colors = mapColors(dataPoints, colorsHeatMap)
    myColors = customColormap(-2, 2, 'presetColors', colorsHeatMap);
    colors = [];
    dataPoints = dataPoints-min(min(dataPoints))+eps; %Have the range be all positive.
    dataPoints = dataPoints/max(max(dataPoints)); %Have the range be between eps and 1.
    dataPoints = ceil(dataPoints*size(myColors,1)); %Make the range integers fit to the provided colormap.
    for i=1:size(dataPoints, 2)
        colors(:,i,:) = myColors(dataPoints(:,i), :); %Map to colors.
    end
end
