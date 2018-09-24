%% Voxelization
nx = 96;
ny = 100;
nz = 19;

addpath('voxelization\');
% [OUTPUTgrid] = VOXELISE(nx, ny, nz, 'myRegionBin.stl', 'xyz');
[OUTPUTgrid] = VOXELISE(nx, ny, nz, 'geometry_not_smoothed.stl', 'xyz');

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

mask = rot90(mask, 1);

% mask = permute(mask, [3,1,2,4,5]);
mask = flip(mask,3);
% mask = ipermute(mask, [3,1,2,4,5]);

I_mask = mask.*I;
addpath(genpath('C:\Program Files (x86)\MRecon'))
image_slide(I_mask)