%% LOAD DATASET

% data extracted from Paraview using slice and spreasheetview (use data
% selection tool)
load('inlet.mat');
x = inlet(:, 5);
y = inlet(:, 6);
z = inlet(:, 7);

u = inlet(:, 1);
v = inlet(:, 2);
w = inlet(:, 3);

%% PREPARE COORDINATES

% slice normal from paraview
a = [0.9757683004992092, -0.12181290545086497, 0.18176314204619098]';

% normal vector to xy axis
b = [0,0,1]';

% calculate rotation matrix that transforms points from oblique slice to xy
% plane
GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0; norm(cross(A,B)) dot(A,B)  0; 0 0 1];
FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
UU = @(Fi,G) Fi*G*inv(Fi);
U = UU(FFi(a,b), GG(a,b));

coord = (U*[x,y,z]')';

%% THRESHOLD DATA
mag_vec = sqrt(u.^2 + v.^2 + w.^2);

coord((mag_vec < 0.1), :) = [];
mag_vec((mag_vec < 0.1), :) = [];

x_trans = coord(:,1) - mean(coord(:,1));
y_trans = coord(:,2) - mean(coord(:,2));
z_trans = coord(:,3) - mean(coord(:,3));

%% FIT SURFACE USING POLYFITN TOOLBOX
p = polyfitn([x_trans, y_trans], mag_vec, 6);
mag_vec_fit = polyvaln(p, [x_trans, y_trans]);

%% SHOW RESULTS
tri = delaunay(x_trans, y_trans);
figure;
hold on;
scatter3(x_trans, y_trans, mag_vec, 10);
trisurf(tri, x_trans, y_trans, mag_vec);
alpha(0.5);
scatter3(x_trans, y_trans, mag_vec_fit, 10);
trisurf(tri, x_trans, y_trans, mag_vec_fit)