
# coding: utf-8

# In[395]:


# Importing Necessary Libs
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from keras.models import Sequential, load_model
from keras.layers import Dense
from keras import optimizers
from keras.callbacks import ModelCheckpoint, EarlyStopping
from sklearn.metrics import mean_absolute_error 

# Importing Extra Libs
import sys, os
import time
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def MRRE(matrix, predicted_matrix):
    sum_error = 0;
    eval_quantity = 0;
    
    for i in xrange(len(matrix)):
        for j in xrange(len(matrix[i])):
            if matrix[i][j] != 0:                
                sum_error += (matrix[i][j]-predicted_matrix[i][j])**2;
                eval_quantity += 1;
    
    return np.sqrt(sum_error/float(eval_quantity));

def RMSE(matrix, predicted_matrix):
    return np.sqrt(mean_squared_error(R, R_predicted))


class SAE:

    def __init__(self, input_matrix,
                 numNeurons = 16,                  
                 loss_metric = 'mse',
                 learning_rate = 0.001):
        
        # Always call base method before doing anything.
        self.input_matrix = input_matrix;
        self.num_neurons = numNeurons;                        
        self.loss_metric = loss_metric;
        self.learning_rate = learning_rate;  
        self.cv_metrics_values = {};
        self.x_train = 0;
        self.x_test = 0;
        
    def fit(self, verbose = False):
        
        # Splitting train and test set
        
        self.x_train, self.x_test = train_test_split(self.input_matrix);
        
        # Scaling input to range (-1,1)
        self.xNormScaler = MinMaxScaler(feature_range = (-1,1))
        self.xNormScaler.fit(self.x_train)

        self.x_norm_train = self.xNormScaler.transform(self.x_train)
        self.x_norm_test = self.xNormScaler.transform(self.x_test)

        #Setting autoencoder
        self.inputDim = self.x_norm_train.shape[1] #Number of items

        self.autoencoder = Sequential([Dense(self.num_neurons, activation = 'selu', kernel_initializer = 'uniform', input_dim = self.inputDim),
                                  Dense(self.inputDim, activation = 'tanh', kernel_initializer = 'uniform')
                                 ])

        #SGD = optimizers.SGD(lr=0.5, momentum=0.00, decay=0.0, nesterov=False)
        #Adam = optimizers.Adam(lr=0.0005, decay = 0.00001)
        self.Adam = optimizers.Adam(lr = self.learning_rate)

        self.autoencoder.compile(optimizer = self.Adam, loss = self.loss_metric, metrics=['mae'])
        #autoencoder.summary()
        
        self.earlyStopping = EarlyStopping(monitor = 'val_loss', patience = 10, mode = 'auto')

        time_zero = time.time()

        self.fitHistory = self.autoencoder.fit(
                                    self.x_norm_train, 
                                    self.x_norm_train, 
                                    epochs = 2000,
                                    verbose = 0,
                                    shuffle = True,
                                    validation_data = (self.x_norm_test, self.x_norm_test), 
                                    callbacks = [self.earlyStopping])

        self.predicted_matrix = self.predict(self.input_matrix);
        
        
        #print('Time to fit model: '+str(time.time()-time_zero)+' seconds')
        
        return self    
        
    def cross_validate(self, n_folds = 10, metrics = ['rmse', 'mae', 'mrre'], verbose = True):
        for metric in metrics:
            self.cv_metrics_values[metric] = [];
        
        for i in xrange(n_folds):
            time_zero = time.time();
            self.fit(self.input_matrix);            
            fold_mae = self.evaluate('mae');
            fold_rmse = self.evaluate('rmse');
            fold_mrre = self.evaluate('mrre');
            self.cv_metrics_values['rmse'].append(fold_rmse)
            self.cv_metrics_values['mae'].append(fold_mae)
            self.cv_metrics_values['mrre'].append(fold_mrre)
            
            
            #print "Elapsed time for fold " + str(i) + ": ", time.time()-time_zero;
        
        return self.cv_metrics_values;
        
    def evaluate(self, metric = 'rmse'):
        
        if metric == 'rmse':
            return sqrt(mean_squared_error(self.input_matrix, self.predict(self.input_matrix)));
        elif metric == 'mae':
            return mean_absolute_error (self.input_matrix, self.predict(self.input_matrix));
        elif metric == 'mrre':
            return MRRE(self.input_matrix, self.predict(self.input_matrix))
        
        else:
            return "Invalid Metric: " + str(metric);
        
        
    def predict(self, matrix):
        # Creating scaler model
        matrix_norm_scaler = MinMaxScaler(feature_range = (-1,1));        
        
        # Fitting scaler model
        matrix_norm_scaler.fit(matrix);        
        
        # Creating normalized matrix
        matrix_norm = matrix_norm_scaler.transform(matrix);

        # Predicting output for normalized input matrix
        output = self.autoencoder.predict(matrix_norm);

        # Denormalizing output
        output_denormal = matrix_norm_scaler.inverse_transform(output);

        # Rounding denormalized output to nearest integer
        matrix_predicted = np.rint(output_denormal);
        
        return matrix_predicted

        #print R_predicted
        
    def estimate(self, u, i): # Estimates an evaluation from a given user to an item        
        return self.predicted_matrix[u][i]
    



