%% Load STL mesh
% Stereolithography (STL) files are a common format for storing mesh data. STL
% meshes are simply a collection of triangular faces. This type of model is very
% suitable for use with MATLAB's PATCH graphics object.

% Import an STL mesh, returning a PATCH-compatible face-vertex structure
% fv = stlread('myRegionBin.stl');
fv = stlread('geometry_not_smoothed.stl');

%% Render
% The model is rendered with a PATCH graphics object. We also add some dynamic
% lighting, and adjust the material properties to change the specular
% highlighting.

patch(fv,'FaceColor',       [0.9 0.9 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15,          ...
         'EdgeColor', 'black',             ...
         'LineWidth', 0.1);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);

%% Voxelization
nx = 96;
ny = 100;
nz = 19;

addpath('voxelization\');
% [OUTPUTgrid] = VOXELISE(nx, ny, nz, 'myRegionBin.stl', 'xyz');
[OUTPUTgrid] = VOXELISE(nx, ny, nz, 'geometry_not_smoothed.stl', 'xyz');

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis tight

%% Load data from mat file
load('volume.mat');
% x = aorta0(:, 11);
% y = aorta0(:, 12);
% z = aorta0(:, 13);
% data = aorta(:, 1:3);


%% Query fields on new mesh

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

datavec = data;
F = scatteredInterpolant(xu, yu, zu, datavec(:, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), 'nearest');

xq = linspace(0, 1, nx);
yq = linspace(0, 1, ny);
zq = linspace(0, 1, nz);

% idx = find(OUTPUTgrid);
% [xq, yq, zq] = ind2sub(size(OUTPUTgrid), idx);

% new data
volData = F({xq, yq, zq});
volData = volData .* OUTPUTgrid;

%%

%Show the voxelised result:
figure;
subplot(1,3,1);
h1 = imagesc(squeeze(sum(OUTPUTgrid,1)));
ax1 = gca;
alpha(h1, 0.5)
colormap(ax1, gray(256));
hold on;
h2 = imagesc(squeeze(sum(volData,1)));
ax2 = gca;
alpha(h2, 0.5)
colormap(ax2, jet(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis tight

subplot(1,3,2);
h1 = imagesc(squeeze(sum(OUTPUTgrid,2)));
ax1 = gca;
alpha(h1, 0.5)
colormap(ax1, gray(256));
hold on;
h2 = imagesc(squeeze(sum(volData,2)));
ax2 = gca;
alpha(h2, 0.5)
colormap(ax2, jet(256));
xlabel('Z-direction');
ylabel('X-direction');
axis tight

subplot(1,3,3);
h1 = imagesc(squeeze(sum(OUTPUTgrid,3)));
ax1 = gca;
alpha(h1, 0.5)
colormap(ax1, gray(256));
hold on;
h2 = imagesc(squeeze(sum(volData,3)));
ax2 = gca;
alpha(h2, 0.5)
colormap(ax2, jet(256));
xlabel('Y-direction');
ylabel('X-direction');
axis tight

%% Check points
np = 100;
n = size(x, 1);
ns = n / np;

% idx = zeros(n, np);
% idx = zeros(n, 1);

idx = [];
parfor i = 1:np
    indnp = (i-1)*ns+1:i*ns;
    indnp = floor(indnp);
    idx(:, i) = inpolyhedron(fv, [x(indnp), y(indnp), z(indnp)]);
end

idx = reshape(idx, [np*floor(ns), 1]);

i = np*floor(ns)+1:n;
idx(i) = inpolyhedron(fv, [x(i), y(i), z(i)]);

figure;
scatter3(x(idx==1), y(idx==1), z(idx==1))

% fv.faces = fv.faces(idx, :);
% fv.vertices = fv.vertices(idx, :);

%% Render
% The model is rendered with a PATCH graphics object. We also add some dynamic
% lighting, and adjust the material properties to change the specular
% highlighting.

patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);

%%

trep = triangulation(tri, [x,y,z]);
[tri, Xb] = freeBoundary(trep);

figure;
hsurf = trisurf(tri, Xb(:,1), Xb(:,2), Xb(:,3), 'FaceColor',[0 .447 .741]);
% coordinates of convex hull
verts = hsurf.Vertices;