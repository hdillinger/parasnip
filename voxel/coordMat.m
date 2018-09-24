function [ vol ] = coordMat( x, y, z, data )
%COORDMAT Summary of this function goes here
%   Detailed explanation goes here

% take only unique coordinates
% [xu, ~, xuidx] = unique(x);
% [yu, ~, yuidx] = unique(y);
% [zu, ~, zuidx] = unique(z);
xu = x;
yu = y;
zu = z;

% normalize data
xmin = min(xu);
xmax = max(xu);
ymin = min(yu);
ymax = max(yu);
zmin = min(zu);
zmax = max(zu);

xu = (xu - xmin) / (xmax - xmin);
yu = (yu - ymin) / (ymax - ymin);
zu = (zu - zmin) / (zmax - zmin);

dims = size(data, 2);

numPoints = 50;
vol = NaN(numPoints, numPoints, numPoints, dims);

% for i = 1:dims
for i = 1
    
    % interpolant
    % interpvec = [xu, yu, zu];
    
    % datavec = circshift(data, [0, -i]);
    datavec = data;
    F = scatteredInterpolant(xu, yu, zu, datavec(:, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), 'nearest');

    % new grid
%     gridvec = linspace(0, 1, numPoints);
%     [xq, yq, zq] = meshgrid(gridvec);
    xq = linspace(0, 1, numPoints);
    yq = linspace(0, 1, numPoints);
    zq = linspace(0, 1, numPoints);

    % new data
    volData = F({xq, yq, zq});
    
    % save data from dimension i to volume
    vol(:, :, :, i) = volData;

end

end
