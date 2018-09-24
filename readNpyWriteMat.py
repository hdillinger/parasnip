import numpy as np
import scipy.io as sio

filename = 'U.npy'

vels = np.load(filename)

sio.savemat('U.mat', {'U': vels})
