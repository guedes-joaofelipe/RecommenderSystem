def saveVariable(results_path, dataset, filename, variable, compression_parameter = 9, verbose = False):
    import os.path
    
    compression_parameter = 9;
    
    filepath = results_path+"Variables/"+dataset+filename
    
    if (verbose):    
        print ("[*] Saving variable to {} file".format(filepath))
        
    #Check if file already exists
    if os.path.isfile(filepath): 
        if (verbose):
            print ("[*] Removing existing file")            
        os.remove(filepath);
      
    #joblib.dump(value, filename, compress=0, protocol=None, cache_size=None)
    joblib.dump(variable, filepath, compress = compression_parameter);
    
    if (verbose):
        print ("[+] File saved.")   

def saveFigure(results_path, dataset, filename, fig, verbose = False):
    fullpath = results_path + 'Figures/' + dataset + filename
    
    if (verbose):
        print "[*] Saving plot to {} folder",format(fullpath)
        
    fig.savefig(fullpath)
    
    if (verbose):
        print "[+] Results saved."
        
def loadVariable(results_path, dataset, filename, compression_parameter = 9, verbose = False):
    filepath = results_path+"Variables/"+dataset+filename
    if (verbose):
        print ("Loading variable from {}".format(filepath))
    
    variable = joblib.load(filepath)
    
    if (verbose):
        print ("Variable loaded")
    
    return variable
        
def main():
    print ("Insert here the main program")

if __name__ == "__main__":
    main()