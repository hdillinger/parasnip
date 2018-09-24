import matplotlib.pyplot as plt
from scipy.interpolate import griddata
import numpy as np
import vtk
from vtk.util.numpy_support import vtk_to_numpy
import scipy.io as sio

# load a vtk file as input
# reader = vtk.vtkXMLUnstructuredGridReader()
# reader.SetFileName("testunstruct.vtu")

reader = vtk.vtkXMLPolyDataReader()
reader.SetFileName('testpoly.vtp')
reader.Update()

# Get the coordinates of nodes in the mesh
nodes_vtk_array = reader.GetOutput().GetPoints().GetData()

# The "Temperature" field is the third scalar in my vtk file
temperature_vtk_array = reader.GetOutput().GetPointData().GetArray('p')

# Get the coordinates of the nodes and their temperatures
nodes_nummpy_array = np.asarray(vtk_to_numpy(nodes_vtk_array))
x, y, z = nodes_nummpy_array[:, 0], nodes_nummpy_array[:, 1], nodes_nummpy_array[:, 2]

temperature_numpy_array = vtk_to_numpy(temperature_vtk_array)
T = temperature_numpy_array

# Draw contours
npts = 100
xmin, xmax = min(x), max(x)
ymin, ymax = min(y), max(y)

# define grid
xi = np.linspace(xmin, xmax, npts)
yi = np.linspace(ymin, ymax, npts)
# grid the data
Ti = griddata((x, y), T, (xi[None, :], yi[:, None]), method='cubic')

# CONTOUR: draws the boundaries of the isosurfaces
CS = plt.contour(xi, yi, Ti, 10, linewidths=3)

# CONTOUR ANNOTATION: puts a value label
plt.clabel(CS, inline=1, inline_spacing=3, fontsize=12, colors='k', use_clabeltext=1)

plt.colorbar()
plt.show()

sio.savemat('vtk.mat', {'p': Ti, 'x': xi, 'y': yi})
