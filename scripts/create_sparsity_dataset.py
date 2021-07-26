import os
import pandas as pd
import numpy as np
import argparse
import logging

# def gini(inter_num, total):
#     x = np.concatenate([np.ones(inter_num), np.zeros(total-inter_num)])    
#     # mad = np.abs(np.subtract.outer(x, x)).mean()            
#     # rmad = mad/np.mean(x)            
#     # g = 0.5 * rmad
#     diffsum = 0
#     for i, xi in enumerate(x[:-1], 1):
#         diffsum += np.sum(np.abs(xi - x[i:]))
#     g = diffsum / (len(x)**2 * np.mean(x))
#     return g

def gini(inter_num, total):
    """Calculate the Gini coefficient of a numpy array."""    
    # array = array.flatten()
    # array = np.concatenate([np.ones(inter_num), np.zeros(total-inter_num)])
    if int(total-inter_num) < 0:
        print ('NEGATIVE', total, inter_num)
    array = np.pad(np.ones(inter_num), (int(total-inter_num), 0), 'constant')
    
    if np.amin(array) < 0:
        # Values cannot be negative:
        array -= np.amin(array)
    # Values cannot be 0:
    array += 0.0000001
    # Values must be sorted:
    # array = np.sort(array)
    # Index per array element:
    index = np.arange(1,array.shape[0]+1)
    # Number of array elements:
    n = array.shape[0]
    # Gini coefficient:
    return ((np.sum((2 * index - n  - 1) * array)) / (n * np.sum(array)))

def get_specific_sparsity(df, entity, sparsity_filter):
    
    logger.info(f'get_specific_sparsity(df.shape={df.shape}, entity={entity}, sparsity_filter={sparsity_filter}')
    
    df_inter_num = df.groupby([entity+'_id:token']).count().iloc[:,0]
    total = df[[entity+'_id:token']].nunique()+1
    
    logger.info(f'Number of {entity}s to process: {total}')

    if sparsity_filter == 'gini':
        df_inter_num = df_inter_num.apply(lambda x: gini(x, total))
    else:
        df_inter_num /= df_inter_num.max()
        df_inter_num = 1-df_inter_num

    sparsity = pd.merge(
        df, 
        df_inter_num.reset_index().rename({'rating:float': 'sparsity'}, axis=1), 
        on=entity+'_id:token', 
        how='left'
    )['sparsity']

    return sparsity
    
    
# pinterest vindo com esparsidade nula

def main(filedir, dataset, sparsity_filter='gini'):

    logger.info('Reading dataset from ' + os.path.join(filedir, dataset, f'{dataset}.inter'))
    df = pd.read_csv(os.path.join(filedir, dataset, f'{dataset}.inter'), sep='\t')

    feedback_column = 'rating:float'# if dataset not in ['lastfm'] else 'weight:float'
    remove_feedback_column = False
    if feedback_column not in df.columns:
        df[feedback_column] = 1
        remove_feedback_column = True

    df['uss:float'] = get_specific_sparsity(df[['item_id:token', 'user_id:token', feedback_column]].drop_duplicates()[['user_id:token', feedback_column]], 'user', sparsity_filter)
    df['iss:float'] = get_specific_sparsity(df[['item_id:token', 'user_id:token', feedback_column]].drop_duplicates()[['item_id:token', feedback_column]], 'item', sparsity_filter)

    if remove_feedback_column:
        df.drop([feedback_column], axis=1, inplace=True)

    logger.info('Saving dataset to ' + os.path.join(filedir, dataset, f'{dataset}.inter'))
    df.to_csv(os.path.join(filedir, dataset, f'{dataset}.inter'), sep='\t', index=None)


if __name__ == '__main__':
    
    
    logging.basicConfig(format='%(asctime)-15s %(message)s', level=logging.INFO)
    logger = logging.getLogger()

    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset', type=str, default='ml-1m')
    parser.add_argument('--input_path', type=str, default=None)    
   
    args = parser.parse_args()

    assert args.input_path is not None, 'input_path can not be None, please specify the input_path'
    
    main(args.input_path, args.dataset)