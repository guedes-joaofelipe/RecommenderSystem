import numpy as np

def MSE(target, predicted):
    from sklearn.metrics import mean_squared_error
    return mean_squared_error(target, predicted)

def RMSE(target, predicted):
    from sklearn.metrics import mean_squared_error    
    return np.sqrt(mean_squared_error(target, predicted))

def MAE(target, predicted):
    from sklearn.metrics import mean_absolute_error
    return mean_absolute_error(target, predicted)

def main():
    print ("Insert here the main program")

if __name__ == "__main__":
    main()