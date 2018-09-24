########################################################################
#
# readVTKXML.py
# Reader for VTK XML files
#
# Implemented in Python 3.5
#
########################################################################
#
# Published under the MIT License. See the file LICENSE for details.
#
# Copyright 2018 by Hannes Dillinger
#
########################################################################

import vtk
from vtk.util import numpy_support
import numpy as np
import scipy.io as sio
from scipy.interpolate import griddata

########################################################################
# Read vtkXMLUnstructuredGrid file
########################################################################

filename = './data/pitzdaily_80.vtu'

reader = vtk.vtkXMLUnstructuredGridReader()
reader.SetFileName(filename)
reader.Update()

mapper = vtk.vtkDataSetMapper()
mapper.SetInputConnection(reader.GetOutputPort())

actor = vtk.vtkActor()
actor.SetMapper(mapper)

########################################################################
# Read vtkXMLPolyData file
########################################################################

filename2 = './data/polydata_0.vtp'

reader2 = vtk.vtkXMLPolyDataReader()
reader2.SetFileName(filename2)
reader2.Update()

mapper2 = vtk.vtkDataSetMapper()
mapper2.SetInputConnection(reader2.GetOutputPort())

actor2 = vtk.vtkActor()
actor2.SetMapper(mapper2)

########################################################################
# Read vtkXMLMultiBlock file
########################################################################

filename3 = './data/multiBlock.vtm'

reader3 = vtk.vtkXMLMultiBlockDataReader()
reader3.SetFileName(filename3)
reader3.Update()

mapper3 = vtk.vtkDataSetMapper()
# mapper3.SetInputConnection(reader3.GetOutputPort())
mapper3.SetInputData(reader3.GetOutputAsDataSet())

actor3 = vtk.vtkActor()
actor3.SetMapper(mapper3)

########################################################################
# Read vtkXMLUnstructuredGrid file
########################################################################

filename4 = './data/resample.vtk'

reader4 = vtk.vtkStructuredGridReader()
reader4.SetFileName(filename4)
reader4.Update()

mapper4 = vtk.vtkDataSetMapper()
mapper4.SetInputConnection(reader4.GetOutputPort())

actor4 = vtk.vtkActor()
actor4.SetMapper(mapper4)

########################################################################
# Read vtkXMLStructuredGrid file
########################################################################

filename5 = './data/image.vti'

reader5 = vtk.vtkXMLImageDataReader()
reader5.SetFileName(filename5)
reader5.Update()

mapper5 = vtk.vtkDataSetMapper()
mapper5.SetInputConnection(reader5.GetOutputPort())

actor5 = vtk.vtkActor()
actor5.SetMapper(mapper5)

########################################################################
# Display data in VTK window
########################################################################

renderer = vtk.vtkRenderer()
renderWindow = vtk.vtkRenderWindow()
renderWindow.AddRenderer(renderer)

renderWindowInteractor = vtk.vtkRenderWindowInteractor()
renderWindowInteractor.SetRenderWindow(renderWindow)

# renderer.AddActor(actor)
# renderer.AddActor(actor2)
# renderer.AddActor(actor3)
# renderer.AddActor(actor4)
renderer.AddActor(actor5)

########################################################################
# Render VTK window
########################################################################

renderWindow.Render()
renderWindowInteractor.Start()

# ########################################################################
# # Save to MATLAB File
# ########################################################################
#
# data = reader.GetOutput()
# points = data.GetPoints().GetData()
#
# mapper = vtk.vtkCellDataToPointData()
# mapper.AddInputData(data)
# mapper.Update()
#
# press = mapper.GetOutput().GetPointData().GetArray('p')
# vels = mapper.GetOutput().GetPointData().GetArray('U')
#
# press = numpy_support.vtk_to_numpy(press)
# vels = numpy_support.vtk_to_numpy(vels)
# points = numpy_support.vtk_to_numpy(points)
#
# x = points[:, 0]
# y = points[:, 1]
# z = points[:, 2]
#
# # grid
# npts = 100
# xmin, xmax = min(x)-1, max(x)+1
# ymin, ymax = min(y)-1, max(y)+1
# zmin, zmax = min(z)-1, max(z)+1
#
# # define grid
# xi = np.linspace(xmin, xmax, npts)
# yi = np.linspace(ymin, ymax, npts)
# zi = np.linspace(zmin, zmax, npts)
#
# grid_x, grid_y, grid_z = np.meshgrid(xi, yi, zi)
#
# points = np.column_stack((x, y, z))
# # grid the data
# # 3D data method linear
# # pi = griddata((x, y, z), press, (xi[None, :], yi[:, None], zi[:, None]), method='linear')
# # pi = griddata(points, press, (xi[None, None, :], yi[None, :, None], zi[:, None, None]), method='nearest')
# pi = griddata(points, press, (grid_x, grid_y, grid_z), method='nearest')
# # 1D and 2D: cubic method possible
# # pi = griddata((x, y), press, (xi[None, :], yi[:, None]), method='cubic')
# # pi = griddata((x, y), press, (xi[None, :], yi[:, None]), method='nearest')
#
# # save new data
# sio.savemat('pitzdaily_80.mat', {'p': pi, 'x': grid_x, 'y': grid_y, 'z': grid_z})
