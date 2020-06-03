%% Voxelization
nx = size(I, 1);
ny = size(I, 2);
nz = size(I, 3);

% FOV_x = 249.32;
% FOV_y = 238.93;
% FOV_z = 40;

addpath('C:\git\parasnip\voxel\voxelization\');
% [OUTPUTgrid] = VOXELISE(nx, ny, nz, 'myRegionBin.stl', 'xyz');

% stl is given in image coordinates - not needed
% meshXmin = -FOV_x / 2;
% meshXmax = FOV_x / 2;
% meshYmin = -FOV_y / 2;
% meshYmax = FOV_y / 2;
% meshZmin = -FOV_z / 2;
% meshZmax = FOV_z / 2;
% 
% voxwidth  = (meshXmax-meshXmin)/(nx+1/2);
% gridCOx   = meshXmin+voxwidth/2 : voxwidth : meshXmax-voxwidth/2;
% voxwidth  = (meshYmax-meshYmin)/(ny+1/2);
% gridCOy   = meshYmin+voxwidth/2 : voxwidth : meshYmax-voxwidth/2;
% voxwidth  = (meshZmax-meshZmin)/(nz+1/2);
% gridCOz   = meshZmin+voxwidth/2 : voxwidth : meshZmax-voxwidth/2;
% [OUTPUTgrid] = VOXELISE(gridCOy, gridCOx, gridCOz, 'mask.stl', 'xyz');

% use image coordinates
[OUTPUTgrid] = VOXELISE(ny, nx, nz, 'mask.stl', 'xyz');

mask = repmat(OUTPUTgrid,[1,1,1,size(I,4),size(I,5)]);
% mask = permute(mask, [2,1,3,4,5]);
% mask = fliplr(mask);
% mask = rot90(mask);
% mask = permute(mask, [3,2,1,4,5]);
% mask = flipud(mask);
% mask = ipermute(mask, [3,2,1,4,5]);

% mask = permute(mask, [2,1,3,4,5]);
% mask = fliplr(mask);
% mask = flipud(mask);
% mask = rot90(mask, 1);
% mask = ipermute(mask, [2,1,3,4,5]);

% mask = permute(mask, [3,1,2,4,5]);
% mask = flipud(mask);
% mask = ipermute(mask, [3,1,2,4,5]);

mask = flip(mask, 3);
mask = rot90(mask, 1);

% mask = permute(mask, [3,1,2,4,5]);
% mask = flip(mask, 4);
% mask = ipermute(mask, [3,1,2,4,5]);

save('mask.mat','mask');

%% DISPLAY
I_mask = mask.*I;
addpath(genpath('C:\Program Files (x86)\MRecon'))
image_slide(I_mask)