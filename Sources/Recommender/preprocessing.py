import numpy as np

def InitializeIds(df_ratings):
    #global usersIds;
    #global moviesIds;

    usersIds = np.array([]);
    itemsIds = np.array([]);
    
    for count in xrange(len(df_ratings['rating'])):

        if int(df_ratings['userId'][count]) not in usersIds:
            usersIds = np.append(usersIds, [int(df_ratings['userId'][count])]);   

        # Change here latter to itemId
        if int(df_ratings['itemId'][count]) not in itemsIds:
            itemsIds = np.append(itemsIds, [int(df_ratings['itemId'][count])]);
            
    return usersIds, itemsIds


def InitializeUtilityMatrix(usersIds, itemsIds):    
    return np.zeros((usersIds.shape[0], itemsIds.shape[0]));

def FillUtilityMatrix(df_ratings, usersIds, itemsIds):
    
    R = InitializeUtilityMatrix(usersIds, itemsIds)
    
    for register in xrange(len(df_ratings['userId'])):
        userId = df_ratings['userId'][register];
        itemId = df_ratings['itemId'][register];

        #Getting userIndex from usersIds
        #itemindex = numpy.where(array==item) --> Return an array with indexes found
        userIndex = np.where(usersIds == userId);
        
        if len(userIndex[0]) == 0: # If userIndex hasn't found any matching user id in usersIds array
            print "UserId", userId, "not found in usersIds array.";
            pass;
        else:
            try:
                if len(userIndex[0]) > 1:
                    print "UserId ", userId, "is double-counted in usersIds.";
                userIndex = userIndex[0][0]; #Get the first occurance of userId match
            except IndexError:
                print "Error with user index: ", userIndex[0] ;
                pass;

        #Getting itemIndex from itemsIds
        #itemindex = numpy.where(array==item) --> Return an array with indexes found
        itemIndex = np.where(itemsIds == itemId);
        if len(itemIndex[0]) == 0: # If userIndex hasn't found any matching user id in usersIds array
            print "ItemId", itemId, "not found in usersIds array.";
            pass;
        else:
            try:
                if len(itemIndex[0]) > 1:
                    print "ItemId ", itemId, "is double-counted in moviesIds.";
                itemIndex = itemIndex[0][0]; #Get the first occurance of movieId match
            except IndexError:
                print "Error with movie index: ", movieIndex[0] ;
                pass;            

        R[userIndex][itemIndex] = df_ratings['rating'][register];
        
    return R;

def LoadUtilityMatrix(df_ratings, verbose = False):    
    
    if (verbose):
        print ("[*] Initializing Users and Items Ids arrays")
        
    usersIds, itemsIds = InitializeIds(df_ratings = df_ratings)
    
    if (verbose):
        print ("[*] Filling Utility Matrix")
    
    R = FillUtilityMatrix(df_ratings, usersIds, itemsIds)
    
    if (verbose):
        print ("[+] Utility Matrix loaded with {0} users and {1} items.".format(usersIds.shape[0], itemsIds.shape[0]))
    
    return R, usersIds, itemsIds


def main():
    print ("Insert here your main program")
    
if __name__ == "__main__":
    main()


