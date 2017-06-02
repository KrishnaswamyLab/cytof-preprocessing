function [ intercalationIntervals ] = loadIntercalationIntervals(keys)
    intercalationIntervals = [];
    for i = 1:size(keys, 2)
        M = dlmread(strcat('IntercalationIntervals/', keys{i}, '.txt'));
        intercalationIntervals(:, :, i) = M;
    end
end
