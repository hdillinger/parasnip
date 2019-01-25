try:
    paraview.simple
except:
    from paraview.simple import *
paraview.simple._DisableFirstRenderCameraReset()

from vtk.numpy_interface import dataset_adapter as dsa

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# create a new 'Table To Points'
#tableToPoints1 = TableToPoints(Input=FindSource('centerline.csv'))
# Properties modified on tableToPoints1
#tableToPoints1.XColumn = 'Points:0'
#tableToPoints1.YColumn = 'Points:1'
#tableToPoints1.ZColumn = 'Points:2'

# create a new 'Poly Line Source'
polyLineSource1 = PolyLineSource()

# Properties modified on polyLineSource1
polyLineSource1.Points = [-0.00847,-0.017387,0.020139,-0.0060182,-0.024332,0.02058,-0.00091149,-0.029671,0.020351,0.0054278,-0.033431,0.019416,0.012427,-0.035866,0.018837,0.01977,-0.036945,0.018679,0.027179,-0.037336,0.018894,0.034535,-0.037144,0.019736,0.041911,-0.036823,0.020693,0.049323,-0.036378,0.02121,0.056722,-0.03565,0.021514,0.062055,-0.035352,0.022581,0.062245,-0.035059,0.022174,0.062477,-0.033866,0.024756,0.061999,-0.027826,0.024603,0.06124,-0.0186,0.024215,0.060114,-0.0090826,0.023513,0.058487,-0.0022265,0.022242,0.053328,-0.0011116,0.017092,0.047177,0.00010448,0.013266,0.041144,0.0026897,0.010131,0.03498,0.0046349,0.0064537,0.027965,0.0060295,0.0046628,0.020565,0.0061793,0.0052813,0.013323,0.0056625,0.0068864,0.0063567,0.0044176,0.0091776,4.0885e-05,0.0017727,0.012002,-0.0049482,-0.0028069,0.015028,-0.0078971,-0.008961,0.017825,-0.0086997,-0.016037,0.019873]

foamfoam = FindSource('foam.foam')

for i in range(0, 90, 6):
    # create a new 'Slice'
    slice1 = Slice(Input=foamfoam)
    slice1.SliceType = 'Plane'
    #slice1.SliceOffsetValues = [0.0]

    # get display properties
    slice1Display = GetDisplayProperties(slice1, view=renderView1)

    # set scalar coloring
    ColorBy(slice1Display, ('POINTS', 'U', 'Magnitude'))

    # init the 'Plane' selected for 'SliceType'
    slice1.SliceType.Origin = [polyLineSource1.Points[i], polyLineSource1.Points[i+1], polyLineSource1.Points[i+2]]
    slice1.SliceType.Normal = [polyLineSource1.Points[i+3] - polyLineSource1.Points[i], polyLineSource1.Points[i+4] - polyLineSource1.Points[i+1], polyLineSource1.Points[i+5] - polyLineSource1.Points[i+2]]

    # create a new 'Connectivity'
    connectivity3 = Connectivity(Input=slice1)

    # Properties modified on connectivity3
    connectivity3.ExtractionMode = 'Extract Closest Point Region'
    connectivity3.ClosestPoint = [polyLineSource1.Points[i], polyLineSource1.Points[i+1], polyLineSource1.Points[i+2]]

    # show data in view
    connectivity3Display = Show(connectivity3, renderView1)
    # set scalar coloring
    ColorBy(connectivity3Display, ('POINTS', 'U', 'Magnitude'))

    # create a new 'Extract Cells By Region'
    #extractCellsByRegion1 = ExtractCellsByRegion(Input=slice1)
    #extractCellsByRegion1.IntersectWith = 'Plane'

    # init the 'Plane' selected for 'IntersectWith'
    #extractCellsByRegion1.IntersectWith.Origin = [polyLineSource1.Points[i], polyLineSource1.Points[i+1], polyLineSource1.Points[i+2]]
    # Properties modified on extractCellsByRegion1.IntersectWith
    #extractCellsByRegion1.IntersectWith.Normal = [polyLineSource1.Points[i+3] - polyLineSource1.Points[i], polyLineSource1.Points[i+4] - polyLineSource1.Points[i+1], polyLineSource1.Points[i+5] - polyLineSource1.Points[i+2]]

    Hide(slice1)

# update the view to ensure updated data information
renderView1.Update()

#point_array = []
#coords = vtk.vtkDoubleArray()
#coords.SetName("Coordinates")
#coords.SetNumberOfComponents(3)
#n = len(tableToPoints1.XColumn)

#field_info = tableToPoints1.PointData
#narrays = len(field_info)

#print(field_info.GetFieldData())

#field_info[i]for i in range(narrays):
#    print()

#for p in range(n):
	#polyLineSource1.Points.append(tableToPoints1.XColumn[p], tableToPoints1.YColumn[p], tableToPoints1.ZColumn[p])
#    point_array.append(tableToPoints1.PointData)

Render()
