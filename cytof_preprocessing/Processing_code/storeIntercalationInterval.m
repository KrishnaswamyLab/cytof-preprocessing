function storeIntercalationInterval(dummy, interval, dataSet)
    indices = interval.Axes.Children(2).BrushHandles.Children(1).VertexIndices;
    xMax = max(interval.Axes.Children(2).BrushHandles.Children(1).VertexData(1, indices));
    xMin = min(interval.Axes.Children(2).BrushHandles.Children(1).VertexData(1, indices));
    yMax = max(interval.Axes.Children(2).BrushHandles.Children(1).VertexData(2, indices));
    yMin = min(interval.Axes.Children(2).BrushHandles.Children(1).VertexData(2, indices));
    dlmwrite(strcat('IntercalationIntervals/', dataSet, '.txt'), [xMin xMax; yMin yMax]);
end
