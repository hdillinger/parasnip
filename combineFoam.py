try: paraview.simple
except: from paraview.simple import *
paraview.simple._DisableFirstRenderCameraReset()

import random

procs = 20

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

path = 'C:\salome\processor'

for proc in range(procs):
 print proc
 foamfile=path+str(proc)+'\processor'+str(proc)+'.foam' 
 processor0_foam = OpenFOAMReader(FileName = foamfile)
 # hide data in view
 # Hide(processor0_foam, renderView1)

 processor0_foam.CellArrays = []
 processor0_foam.LagrangianArrays = []
 processor0_foam.MeshRegions = ['internalMesh']
 processor0_foam.PointArrays = []
 # Properties modified on processor0_foam
 processor0_foam.CellArrays = ['U', 'U_0', 'k', 'k_0', 'nuSgs', 'p']
 mr0 = GetDisplayProperties(processor0_foam)
 mr0.DiffuseColor = [random.random(), random.random(), random.random() ]

# Hide all data objects 
ss = GetSources()
for s in ss:
  Hide(ss[s])

openFOAMReaderlist = []
for proc in range(1, procs+1):
	# find source
	print("proc{0}".format(proc))
	# openFOAMReader["proc{0}".format(proc)] = FindSource('OpenFOAMReader'+str(proc))
	openFOAMReaderlist.append(FindSource('OpenFOAMReader'+str(proc)))
	#openFOAMReader = GetSources('OpenFOAMReader'+str(proc))
	
# create a new 'Group Datasets'
groupDatasets1 = GroupDatasets(Input=openFOAMReaderlist)

# show data in view
groupDatasets2Display = Show(groupDatasets1, renderView1)

Render()