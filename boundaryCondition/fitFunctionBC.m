%% LOAD DATASET

% data extracted from Paraview (load Nifti plugin before) using slice and spreasheetview (use data
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

% rotate patch
theta = -pi/2;
% x_trans_rot = x_trans;
% y_trans_rot = y_trans * cos(theta) + z_trans * sin(theta);
% z_trans_rot = -y_trans * sin(theta) + z_trans * cos(theta);

x_trans_rot = x_trans * cos(theta) + y_trans * sin(theta);
y_trans_rot = -x_trans * sin(theta) + y_trans * cos(theta);
z_trans_rot = z_trans;

% size of patch according to paraview
p_r_x = max(abs(x_trans_rot));
p_r_y = max(abs(y_trans_rot));
p_r_z = max(abs(z_trans_rot));
x_trans_rot = (x_trans_rot / p_r_x + 1) / 2;
y_trans_rot = (y_trans_rot / p_r_y + 1) / 2;
z_trans_rot = (z_trans_rot / p_r_z + 1) / 2;

%% FIT SURFACE USING POLYFITN TOOLBOX
p = polyfitn([x_trans_rot, y_trans_rot], mag_vec, 4);
mag_vec_fit = polyvaln(p, [x_trans_rot, y_trans_rot]);

%% SHOW RESULTS
tri = delaunay(x_trans_rot, y_trans_rot);
figure;
hold on;
scatter3(x_trans_rot, y_trans_rot, mag_vec, 10);
trisurf(tri, x_trans_rot, y_trans_rot, mag_vec);
alpha(0.5);
scatter3(x_trans_rot, y_trans_rot, mag_vec_fit, 10);
trisurf(tri, x_trans_rot, y_trans_rot, mag_vec_fit);

%% PRINT IN TEXT FORMAT
n = size(p.ModelTerms,1);
output = [];
for i = 1:(n-1)
  output = strcat(output, '(', num2str(p.Coefficients(i), '%10.5e\n'), ')','*pow(y,',int2str(p.ModelTerms(i, 1)), ')','*pow(z,',int2str(p.ModelTerms(i, 2)),')', '+');
end
i = i + 1;
output = strcat(output, '(', num2str(p.Coefficients(i), '%10.5e\n'), ')', '*pow(y,',int2str(p.ModelTerms(i, 1)), ')', '*pow(z,',int2str(p.ModelTerms(i, 2)), ')')