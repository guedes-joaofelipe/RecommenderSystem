import numpy as np
import pandas as pd

class recommender:
    def __init__(self, algorithm):
        
        # Always call base method before doing anything.
        self.name = algorithm.lower() # SVD, NMF, SAE, LSTM
        self.surprise_algorithms = ['svd', 'nmf', 'knnbasic', 'knnmeans']
        
        '''
         To implement with surprise:
             - Matrix-Factorization Based:
                 SVDpp: The SVD++ algorithm, an extension of SVD taking into account implicit ratings.
             - Neighbourhood-based:
                 Coclustering
                 KNNWithZScore: A basic collaborative filtering algorithm, taking into account the z-score normalization of each user.
                 KNNBaseline: A basic collaborative filtering algorithm taking into account a baseline rating.
             - Random Predictor    
                 NormalPredictor: Algorithm predicting a random rating based on the distribution of the training set, which is assumed to be normal.
             - Baseline    
                 BaselineOnly: Algorithm predicting the baseline estimate for given user and item.
             - Slope One
                 SlopeOne: A simple yet accurate collaborative filtering algorithm.

        To implement using RNN:
            - LSTM 
            - GRU (Devooght, Bersini)
            - GRU with clustering (Devooght, Bersini)
            
        To extract latent factors:
            - Stacked Autoencoders
            - CNN
            - CNN with Stacked Autoencoders
        '''
        
        self.df_known_predictions = None
        self.df_unknown_predictions = None
        self.known_sequence_dict = None
        self.unknown_sequence_dict = None
        self.k = None
        self.k_min = None
        
    def get_name(self, verbose = False):
        return self.name

    def fit(self, 
            df_ratings = None, 
            columns = ['userId', 'itemId', 'rating'],             
            verbose = False,
           **kwargs):
        
        
        self.columns = np.array(columns)
        # If Surprise lib is the base package to fit, then df_ratings must be used. 
        # Algorithms that use Surprise Lib: NMF, SVD, KNN, SVDpp
        
        if (df_ratings is not None):
            self.df_ratings = df_ratings.copy()
        
        ###########################################
        # Convert Utility Matrix to df_ratings if utility matrix is passed
        #
        #
        ###########################################
        
        if self.name in self.surprise_algorithms:  # Surprise-based recommenders          
            from surprise import Dataset
            from surprise import Reader
            
            # A reader is still needed but only the rating_scale param is required.
            # The Reader class is used to parse a file containing ratings.
            reader = Reader(rating_scale=(0.5, 5.0))
            
            # Separating timestamp column
            if ('timestamp' in columns):
                self.df_timestamp = self.df_ratings['timestamp'].copy()
                self.df_ratings.drop(labels = 'timestamp', inplace = True, axis = 1)
                
            
            # The columns must correspond to user id, item id and ratings (in that order).
            data = Dataset.load_from_df(self.df_ratings[self.columns[np.where(self.columns != 'timestamp')]], reader)

            # Creting trainset variable to be used in prediction functions of Surprise
            self.trainset = data.build_full_trainset()

            
            # Creating Model
            if self.name == 'svd':                
                from surprise import SVD
                
                # Setting Number of Factors in Matrix Factorization
                if ('n_factors' in kwargs):
                    self.n_factors = kwargs['n_factors']
                else:
                    self.n_factors = 100
                    if (verbose):
                        print ("Using default number of factors: {}".format(self.n_factors))                                                
                
                # Setting number of epochs in stocastic gradient descent
                if ('n_epochs' in kwargs):
                    self.n_epochs = kwargs['n_epochs']
                else:
                    self.n_epochs = 20
                    if (verbose):
                        print ("Using default number of epochs: {}".format(self.n_epochs))                                                
                
                self.model = SVD(n_factors = self.n_factors, n_epochs = self.n_epochs, verbose = verbose)
                
                
            elif self.name == 'nmf':
                from surprise import NMF
                
                # Setting Number of Factors in Matrix Factorization
                if ('n_factors' in kwargs):
                    self.n_factors = kwargs['n_factors']
                else:
                    self.n_factors = 15
                    if (verbose):
                        print ("Using default number of factors: {}".format(self.n_factors))                                                
                
                # Setting number of epochs in stocastic gradient descent
                if ('n_epochs' in kwargs):
                    self.n_epochs = kwargs['n_epochs']
                else:
                    self.n_epochs = 50
                    if (verbose):
                        print ("Using default number of epochs: {}".format(self.n_epochs))                                                
                
                self.model = NMF(n_factors = self.n_factors, n_epochs = self.n_epochs, verbose = verbose)
               
                
            elif self.name == 'knnbasic':
                from surprise import KNNBasic
                
                # Setting number of neighbours
                if ('k' in kwargs):
                    self.k = kwargs['k']
                else:
                    self.k = 40
                    if (verbose):
                        print ("Using default k: {}".format(self.k))                                                
                     
                # Setting minimum number of neighbours
                if ('k_min' in kwargs):
                    self.k_min = kwargs['k_min']
                else:
                    self.k_min = 1
                    if (verbose):
                        print ("Using default k_min: {}".format(1))                         
                        
                self.model = KNNBasic(k = self.k, min_k = self.k_min, verbose = verbose)

                
            elif self.name == 'kmeans':
                from surprise import KNNWithMeans
                
                # Setting number of neighbours
                if ('k' in kwargs):
                    self.k = kwargs['k']
                else:
                    self.k = 40
                    if (verbose):
                        print ("Using default k: {}".format(40))                                                
                        
                # Setting minimum number of neighbours
                if ('k_min' in kwargs):
                    self.k_min = kwargs['k_min']
                else:
                    self.k_min = 1
                    if (verbose):
                        print ("Using default k_min: {}".format(1))                                                
                        
                self.model = KNNWithMeans(k = self.k, min_k = self.k_min, verbose=verbose)
                
            else:
                if (verbose):
                    print ("Algorithm not configured: {}".format(self.name))
                return 0

            # Train the algorithm on the trainset, and predict ratings for the testset
            self.model.train(self.trainset)
        else: # if self.name not in self.surprise_algorithms
            if (verbose): 
                print ("Invalid algorithm: {}".format(self.name))
            
    def get_model(self):
        return self.model
            
    def calculate_known_predictions(self):
        # Calculating all predictions for known items
        
        if self.name in self.surprise_algorithms:    
            # Calculating predictions dataframe as userId, itemId, rating, prediction
            # predictions return raw uid and iid           
            
            known_predictions = self.model.test(self.trainset.build_testset()) # Brings all predictions of existing ratings

            for prediction in known_predictions:    
                arr = np.array([int(prediction.uid), int(prediction.iid), prediction.r_ui, prediction.est])
                if prediction == known_predictions[0]:        
                    predictions = np.array([arr])
                else:
                    predictions = np.append(predictions, [arr], axis = 0)

            self.df_known_predictions = pd.DataFrame({'userId':predictions[:,0],'itemId':predictions[:,1], 'rating': predictions[:,2], 'prediction': predictions[:,3]})

            if ('timestamp' in self.columns):
                self.df_known_predictions = self.df_known_predictions.set_index(keys=['userId', 'itemId']).join(df_ratings.drop('rating', axis = 1).set_index(keys = ['userId', 'itemId' ])).reset_index()
            
            self.df_known_predictions['userId'] = self.df_known_predictions['userId'].astype(int)
            self.df_known_predictions['itemId'] = self.df_known_predictions['itemId'].astype(int)
            

    def get_known_predictions(self, calculate_predictions = False):
        if self.df_known_predictions is None or calculate_predictions == True:
            self.calculate_known_predictions()
        
        return self.df_known_predictions
    
    def calculate_unknown_predictions(self):
        # Calculating all predictions for known items
        # predictions return raw uid and iid
        
        if self.name in self.surprise_algorithms:            
            unknown_predictions = self.model.test(self.trainset.build_anti_testset()) # => Brings all predictions of non-existing ratings

            for prediction in unknown_predictions:    
                arr = np.array([int(prediction.uid), int(prediction.iid), 0, prediction.est])
                if prediction == unknown_predictions[0]:        
                    predictions = np.array([arr])
                else:
                    predictions = np.append(predictions, [arr], axis = 0)

            self.df_unknown_predictions = pd.DataFrame({'userId':predictions[:,0],'itemId':predictions[:,1], 'rating': predictions[:,2], 'prediction': predictions[:,3]})
            
    def get_unknown_predictions(self, calculate_predictions = False):
        if self.df_unknown_predictions is None or calculate_predictions == True:
            self.calculate_unknown_predictions()
        
        return self.df_unknown_predictions        
            
    def predict(self, userId, itemId, verbose = False):
        
        if self.name in self.surprise_algorithms:
            prediction = self.model.predict(uid = int(userId), iid = int(itemId)) # Take as input the raw user id and item id
            #ref: http://surprise.readthedocs.io/en/stable/algobase.html#surprise.prediction_algorithms.algo_base.AlgoBase.predict
            
            if prediction.details['was_impossible'] == True:
                if (verbose):
                    print ("Impossible to predict item {} rating for user {} (one of them may not have been in training step)".format(itemId, userId))
                return 0            
            else:
                return prediction.est
    
    def get_top_n(self, n=10, source = 'unknown', calculate_sequence = False):
        '''Return the top-N recommendation for each user from a set of predictions.
        Args:        
            n(int): The number of recommendation to output for each user. Default
                is 10.
        Returns:
        A dict where keys are user (raw) ids and values are lists of tuples:
            [(raw item id, rating estimation), ...] of size n. '''

        if (source.lower() == 'known'):
            
            # Checking if known predictions are calculated
            if (self.df_known_predictions is None):
                self.get_unknown_predictions(calculate_predictions = True)
            
            if (calculate_sequence == True or self.known_sequence_dict is None):
                self.known_sequence_dict = dict()

                for userId in self.df_known_predictions['userId'].unique():
                    # Selecting single user
                    df_user = self.df_known_predictions[self.df_known_predictions['userId'] == userId].copy()

                    # Sorting values by prediction
                    df_user.sort_values(by=['prediction'], ascending= False, inplace = True)

                    # Saving the first K in sequence dict
                    self.known_sequence_dict[userId] = np.array(df_user['itemId'].head(n))            
                
            return self.known_sequence_dict
    
