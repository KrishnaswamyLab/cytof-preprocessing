function contourX(M)
    [n,c] = hist3(M, [200 200]);
    n(:,1) = 0;
    n(1,:) = 0;
    [X,Y] = meshgrid(c{1}, c{2});
    n = conv2(n, 1/81 * ones(9,9), 'same');
    contour(X, Y, n', 'LineWidth', 1);
end
