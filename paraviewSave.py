from paraview.simple import *
import os

reader = GetActiveSource()
tsteps = reader.TimestepValues

"""Start Loop over all files """
for index in tsteps:
    out_filename = 'aortaProbe' + "%0.4d" % index +".csv"
    writefile = './' + out_filename
	
    writer = CreateWriter(writefile,reader)
    writer.FieldAssociation = "Points"
    writer.UpdatePipeline()

""" That's it. """"