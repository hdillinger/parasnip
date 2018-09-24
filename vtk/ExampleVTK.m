%% Read in ASCII VTK file

Mesh = ReadMeshFromVTKFile('../../../salome/testout.vtk')';

vtkwrite('mri_data.vtk','structured_grid',xMR,yMR,zMR,'vectors','vector_field',vx, vy, vz)