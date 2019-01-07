import os
import sys
import bin_set_util as bsu

if __name__ == "__main__":
    bnnRoot = "./"
    npzFile = bnnRoot + "trained_params.npz"
    targetDirBin = bnnRoot + sys.argv[1]
    
    numLayers = int(sys.argv[2]) + 1
	
    bsu.convertFCNetwork(npzFile, targetDirBin, numLayers)
    