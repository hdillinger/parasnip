%===========================================================================================
%Copyright (c) 2018 by Georgia Tech Research Corporation.
%All rights reserved.
%
%The files contain code and data associated with the paper titled
%"A Deep Learning Approach to Estimate Stress Distribution: A Fast and
%Accurate Surrogate of Finite Element Analysis".
%
%The paper is authored by Liang Liang, Minliang Liu, Caitlin Martin,
%and Wei Sun, and published at Journal of The Royal Society Interface, 2018.
%
%The file list: ShapeData.mat, StressData.mat, DLStress.py, im2patch.m,
%UnsupervisedLearning.m, ReadMeshFromVTKFile.m, ReadPolygonMeshFromVTKFile.m,
%WritePolygonMeshAsVTKFile.m, Visualization.m, TemplateMesh3D.vtk, TemplateMesh2D.vtk.
%Note: *.m and *.py files were converted to pdf files for documentation purpose.
%
%THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
%INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
%FOR A PARTICULAR PURPOSE.
%===========================================================================================
%%
function Mesh = ReadPolygonMeshFromVTKFile(FilePathAndName)

Mesh = ReadMeshFromVTKFile(FilePathAndName);
Mesh.Face=Mesh.Element;
Mesh=rmfield(Mesh, 'Element');
