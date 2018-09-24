import vtk
from numpy import zeros
import matplotlib.pyplot as plt

filename = 'test.vtk'

reader = vtk.vtkUnstructuredGridReader()
reader.SetFileName(filename)
reader.Update()

# plane = vtk.vtkPlane()
# plane.SetOrigin(0, 0, 0.5)
# plane.SetNormal(0, 0, 1)

# cutter = vtk.vtkFiltersCorePython.vtkCutter()
# cutter.SetCutFunction(plane)
# cutter.SetInputConnection(reader.GetOutputPort())
# cutter.Update()

# data = cutter.GetOutput()
data = reader.GetOutput()

# triangles = data.GetPolys().GetData()
points = data.GetPoints()

mapper = vtk.vtkCellDataToPointData()
mapper.AddInputData(data)
mapper.Update()

vels = mapper.GetOutput().GetPointData().GetArray(1)
press = mapper.GetOutput().GetPointData().GetArray(2)

# ntri = triangles.GetNumberOfTuples() / 4
npts = points.GetNumberOfPoints()
nvls = vels.GetNumberOfTuples()
npress = press.GetNumberOfTuples()

# tri = zeros((ntri, 3))
x = zeros(npts)
y = zeros(npts)
ux = zeros(nvls)
uy = zeros(nvls)
px = zeros(npress)
py = zeros(npress)

# for i in xrange(0, ntri):
#     tri[i, 0] = triangles.GetTuple(4 * i + 1)[0]
#     tri[i, 1] = triangles.GetTuple(4 * i + 2)[0]
#     tri[i, 2] = triangles.GetTuple(4 * i + 3)[0]

for i in xrange(npts):
    pt = points.GetPoint(i)
    x[i] = pt[0]
    y[i] = pt[1]

for i in xrange(0, nvls):
    U = vels.GetTuple(i)
    ux[i] = U[0]
    uy[i] = U[1]

for i in xrange(0, npress):
    p = vels.GetTuple(i)
    px[i] = p[0]
    py[i] = p[1]

print('test')

# # Mesh
# plt.figure(figsize=(8, 8))
# plt.triplot(x, y, tri)
# plt.gca().set_aspect('equal')

# # Velocity x-component
# plt.figure(figsize=(8, 8))
# plt.tricontourf(x, y, tri, ux, 16)
# plt.tricontour(x, y, tri, ux, 16)
