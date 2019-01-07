#BSD 3-Clause License
#=======
#
#Copyright (c) 2017, Xilinx
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#
#* Redistributions of source code must retain the above copyright notice, this
import numpy as np
import os
import sys

def convertFCNetwork(npzFile, targetDirBin, numLayers):
  if not os.path.exists(targetDirBin):
    os.mkdir(targetDirBin)

  r = BNNWeightReader(npzFile)

  for l in range(numLayers):
    # read out weights and thresholds
    (w,t) = r.readFCBNComplex()
    mat = np.matrix(w)
    print(mat.size)
    with open(targetDirBin+'\dump_w_'+str(l)+'.txt','w') as f:
      for line in mat:
        np.savetxt(f, line, fmt='%d')
    mat = np.matrix(t)		
    with open(targetDirBin+'\dump_t_'+str(l)+'.txt','w') as f:
      for line in mat:
        np.savetxt(f, line, fmt='%-d')	     
		   

# the binarization function, basically the sign encoded as 1 for positive and
# 0 for negative
def binarize(w):
    return 1 if w >=0 else 0

# note that the neurons are assumed to be in the columns of the weight
# matrix
def makeFCBNComplex(weights, beta, gamma, mean, invstd):
  ins = weights.shape[0]
  outs = weights.shape[1]
  
  print "Extracting FCBN complex, ins = %d outs = %d" % (ins, outs)
  
  w_bin = range(ins*outs)
  thresholds = range(outs)
  
  for neuron in range(outs):
    # compute a preliminary threshold from the batchnorm parameters
    thres = mean[neuron] - (beta[neuron] / (gamma[neuron]*invstd[neuron]))
    need_flip = 0

    if gamma[neuron]*invstd[neuron] < 0: # Potential bug?????????? If all negative , flip or threshold 0?
        need_flip = 1
        thres = -thres
    
    thresholds[neuron] = int((ins + thres) / 2)

    # binarize the synapses
    for synapse in range(ins):
      dest_ind = neuron*ins+synapse
      if need_flip:
        w_bin[dest_ind] = binarize(-weights[synapse][neuron])
      else:
        w_bin[dest_ind] = binarize(weights[synapse][neuron])

  w_bin = np.asarray(w_bin).reshape((outs, ins))
  
  return (w_bin, thresholds)

# pull out data from a numpy archive containing layer parameters
# this should ideally be done using Lasagne, but this is simpler and works
class BNNWeightReader:
  def __init__(self, paramFile):
    self.paramDict = np.load(paramFile)
    self.currentParamInd = 0
    
  def __getCurrent(self):
    ret =  self.paramDict["arr_" + str(self.currentParamInd)]
    self.currentParamInd += 1
    return ret
    
  def readFCLayerRaw(self):
    w = self.__getCurrent()
    b = self.__getCurrent()
    return (w, b)
    
  def readConvLayerRaw(self):
    w = self.__getCurrent()
    b = self.__getCurrent()
    return (w, b)
    
  def readBatchNormLayerRaw(self):
    beta = self.__getCurrent()
    gamma = self.__getCurrent()
    mean = self.__getCurrent()
    invstd = self.__getCurrent()
    return (beta, gamma, mean, invstd)
    
  def readFCBNComplex(self):
    (w,b) = self.readFCLayerRaw()
    (beta, gamma, mean, invstd) = self.readBatchNormLayerRaw()
    (Wb, T) = makeFCBNComplex(w, beta, gamma, mean, invstd)   
    return (Wb, T)
    	
