import numpy as np


__author__ = 'Joao Felipe Guedes <guedes.joaofelipe@poli.ufrj.br>'

def partition_dataframe(df, mode = 'cicle', nodes = 5, index = False, sort_by = None, ascending=False):
    """ Partition a dataframe into N nodes according to a partitioning mode
        :params
        :df: pd.DataFrame
        :mode: str ['cicle'] (others not implemented yet)
        :index: boolean (whether to return the partitioned dataframe (False) or its index (True))
        
        :return: a list of 'list' (index == True) or pd.DataFrame (index == False)
    """
    partitions = list()
    arr_index = np.arange(df.shape[0])
    nodes = df.shape[0] if df.shape[0] < nodes else nodes 
    if sort_by is not None:
        df.sort_values(by=sort_by, ascending=ascending, inplace=True)

    if mode.lower() == 'cicle':
        for offset in np.arange(nodes):
            partition = arr_index[offset::nodes] if index else df.iloc[arr_index[offset::nodes]]
            partitions.append(partition)
    else:
        raise NotImplementedError
        
    return partitions

def create_gif(input_filepaths, output_filepath, duration = 0.2):
    import imageio    
    images = []
    for filepath in input_filepaths:
        images.append(imageio.imread(filepath))    
    imageio.mimsave(output_filepath, images, duration=duration)    

def write_log(filepath, mode="a+", text = '\n'):
    with open(filepath, mode) as f:
        f.write(text)

if __name__ == "__main__":   
    import pandas as pd 

    # Unit test for partition_dataframe()
    partitions = 5
    df_size = 17
    arr = ['Data ' + str(x) for x in np.arange(df_size)]
    print (partition_dataframe(pd.DataFrame(arr), mode='cicle', index=True))
    