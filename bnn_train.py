from __future__ import print_function

import sys
import os
import time

import numpy as np
np.random.seed(1234)  # for reproducibility

# specifying the gpu to use
# import theano.sandbox.cuda
# theano.sandbox.cuda.use('gpu1') 
import theano
import theano.tensor as T

import lasagne

import cPickle as pickle
import gzip

import binary_net

from pylearn2.datasets.mnist import MNIST
from pylearn2.utils import serial

from collections import OrderedDict

if __name__ == "__main__":
    
    # BN parameters
    batch_size = int(sys.argv[1])
    print("batch_size = "+str(batch_size))
    # alpha is the exponential moving average factor
    alpha = .1
    print("alpha = "+str(alpha))
    epsilon = 1e-4
    print("epsilon = "+str(epsilon))
    
    # MLP parameters
    num_units = int(sys.argv[2])
    outs = int(sys.argv[3])
    print("num_units = "+str(num_units))
    n_hidden_layers = int(sys.argv[4])
    print("n_hidden_layers = "+str(n_hidden_layers))
    
    # Training parameters
    num_epochs = int(sys.argv[5])
    print("num_epochs = "+str(num_epochs))
    
    # Dropout parameters
    dropout_in = 0#.2 # 0. means no dropout
    print("dropout_in = "+str(dropout_in))
    dropout_hidden = 0#.5
    print("dropout_hidden = "+str(dropout_hidden))
    
    # BinaryOut
    activation = binary_net.binary_tanh_unit
    print("activation = binary_net.binary_tanh_unit")
    # activation = binary_net.binary_sigmoid_unit
    # print("activation = binary_net.binary_sigmoid_unit")
    
    # BinaryConnect
    binary = True
    print("binary = "+str(binary))
    stochastic = False
    print("stochastic = "+str(stochastic))
    # (-H,+H) are the two binary values
    # H = "Glorot"
    H = 1.
    print("H = "+str(H))
    # W_LR_scale = 1.    
    W_LR_scale = "Glorot" # "Glorot" means we are using the coefficients from Glorot's paper
    print("W_LR_scale = "+str(W_LR_scale))
    
    # Decaying LR 
    LR_start = .003
    print("LR_start = "+str(LR_start))
    LR_fin = 0.0000003
    print("LR_fin = "+str(LR_fin))
    LR_decay = (LR_fin/LR_start)**(1./num_epochs)
    print("LR_decay = "+str(LR_decay))
    # BTW, LR decay might good for the BN moving average...
    
    save_path = "trained_params.npz"
    print("save_path = "+str(save_path))
    
    shuffle_parts = 1
    print("shuffle_parts = "+str(shuffle_parts))

    file = open(sys.argv[6],'r')
    l = np.loadtxt(file)
    lshap = l.shape
    ins  = lshap[1]-outs
    vals = lshap[0]
    class ContainerClass_valid:
      def __init__(self):
        self.X = np.empty([vals, ins])
        self.y = np.empty([vals, outs])
    print('\nValid size:')
    print(lshap)
    valid_set = ContainerClass_valid()	
    valid_set.X = 2*l[:,0:ins]-1.
    valid_set.y = 2*l[:,ins:]-1.
    #valid_set.y = (valid_set.y[np.newaxis]).T
    print('Valid data size:')
    print((valid_set.X.shape))
    print('Valid label size:')
    print((valid_set.y.shape))
    file.close()
	
    file = open(sys.argv[7],'r')
    l = np.loadtxt(file)
    lshap = l.shape
    ins  = lshap[1]-outs
    tras = lshap[0]
    class ContainerClass_train:
      def __init__(self):
        self.X = np.empty([tras, ins])
        self.y = np.empty([tras, outs])
    print('\nTrain size:')
    print(lshap)
    train_set = ContainerClass_train()
    train_set.X = 2*l[:,0:ins]-1.
    train_set.y = 2*l[:,ins:]-1.
    #train_set.y = (train_set.y[np.newaxis]).T
    print('Train data size:')
    print((train_set.X.shape))
    print('Train label size:')
    print((train_set.y.shape))
    file.close()	
	
    file = open(sys.argv[8],'r')
    l = np.loadtxt(file)
    lshap = l.shape
    ins  = lshap[1]-outs
    tess = lshap[0]
    class ContainerClass_test:
      def __init__(self):
        self.X = np.empty([tess, ins])
        self.y = np.empty([tess, outs])
    print('\nTest size:')
    print((l.shape))
    test_set = ContainerClass_test()
    test_set.X = 2*l[:,0:ins]-1.
    test_set.y = 2*l[:,ins:]-1.
    #test_set.y = (test_set.y[np.newaxis]).T
    print('Test data size:')
    print((test_set.X.shape))
    print('Test label size:')
    print((test_set.y.shape))
    file.close()	
		
    #sys.exit()
	
    print('Building the MLP...') 
    
    # Prepare Theano variables for inputs and targets
    #input = T.tensor4('inputs')
    input = T.matrix('inputs')
    target = T.matrix('targets')
    LR = T.scalar('LR', dtype=theano.config.floatX)

    #mlp = lasagne.layers.InputLayer(
    #        shape=(None, 1, 28, 28),
    #        input_var=input)
    mlp = lasagne.layers.InputLayer(
             shape=(None, ins),
             input_var=input)
            
    mlp = lasagne.layers.DropoutLayer(
            mlp, 
            p=dropout_in)
    
    for k in range(n_hidden_layers):

        mlp = binary_net.DenseLayer(
                mlp, 
                binary=binary,
                stochastic=stochastic,
                H=H,
                W_LR_scale=W_LR_scale,
                nonlinearity=lasagne.nonlinearities.identity,
                num_units=num_units)      #/(k+1) Dont divide, its here for a somesort of an autoencoder            
        
        mlp = lasagne.layers.BatchNormLayer(
                mlp,
                epsilon=epsilon, 
                alpha=alpha)

        mlp = lasagne.layers.NonlinearityLayer(
                mlp,
                nonlinearity=activation)
                
        mlp = lasagne.layers.DropoutLayer(
                mlp, 
                p=dropout_hidden)
    
    mlp = binary_net.DenseLayer(
                mlp, 
                binary=binary,
                stochastic=stochastic,
                H=H,
                W_LR_scale=W_LR_scale,
                nonlinearity=lasagne.nonlinearities.identity,
                num_units=1)    
    
    mlp = lasagne.layers.BatchNormLayer(
            mlp,
            epsilon=epsilon, 
            alpha=alpha)

    train_output = lasagne.layers.get_output(mlp, deterministic=False)
    
    # squared hinge loss
    loss = T.mean(T.sqr(T.maximum(0.,1.-target*train_output)))
    
    if binary:
        
        # W updates
        W = lasagne.layers.get_all_params(mlp, binary=True)
        W_grads = binary_net.compute_grads(loss,mlp)
        updates = lasagne.updates.adam(loss_or_grads=W_grads, params=W, learning_rate=LR)
        updates = binary_net.clipping_scaling(updates,mlp)
        
        # other parameters updates
        params = lasagne.layers.get_all_params(mlp, trainable=True, binary=False)
        updates = OrderedDict(updates.items() + lasagne.updates.adam(loss_or_grads=loss, params=params, learning_rate=LR).items())
        
    else:
        params = lasagne.layers.get_all_params(mlp, trainable=True)
        updates = lasagne.updates.adam(loss_or_grads=loss, params=params, learning_rate=LR)

    test_output = lasagne.layers.get_output(mlp, deterministic=True)
    test_loss = T.mean(T.sqr(T.maximum(0.,1.-target*test_output)))
    #test_err = T.mean(T.neq(T.argmax(test_output, axis=1), T.argmax(target, axis=1)),dtype=theano.config.floatX)
    test_err = T.mean((T.maximum(0.,1.-target*test_output))/2.)
    
    # Compile a function performing a training step on a mini-batch (by giving the updates dictionary) 
    # and returning the corresponding training loss:
    train_fn = theano.function([input, target, LR], loss, updates=updates)

    # Compile a second function computing the validation loss and accuracy:
    val_fn = theano.function([input, target], [test_loss, test_err])

    print('Training...')
    
    binary_net.train(
            train_fn,val_fn,
            mlp,
            batch_size,
            LR_start,LR_decay,
            num_epochs,
            train_set.X,train_set.y,
            valid_set.X,valid_set.y,
            test_set.X,test_set.y,
            save_path,
            shuffle_parts)