import os
import pandas as pd
import numpy as np
import argparse

def gini(inter_num, total):
    x = np.concatenate([np.ones(inter_num), np.zeros(total-inter_num)])    
    # mad = np.abs(np.subtract.outer(x, x)).mean()            
    # rmad = mad/np.mean(x)            
    # g = 0.5 * rmad
    diffsum = 0
    for i, xi in enumerate(x[:-1], 1):
        diffsum += np.sum(np.abs(xi - x[i:]))
    g = diffsum / (len(x)**2 * np.mean(x))
    return g

def get_specific_sparsity(df, entity, sparsity_filter):
    
    
    df_inter_num = df.groupby([entity+'_id:token']).count().iloc[:,0]
    total = df[[entity+'_id:token']].nunique()+1
    
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
    
    


def main(filedir, dataset, sparsity_filter='gini'):
    df = pd.read_csv(os.path.join(filedir, dataset, f'{dataset}.inter'), sep='\t')

    df['uss:float'] = get_specific_sparsity(df[['user_id:token', 'rating:float']], 'user', sparsity_filter)
    df['iss:float'] = get_specific_sparsity(df[['item_id:token', 'rating:float']], 'item', sparsity_filter)

    df.to_csv(os.path.join(filedir, dataset, f'{dataset}.inter'), sep='\t', index=None)


if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset', type=str, default='ml-1m')
    parser.add_argument('--input_path', type=str, default=None)    
   
    args = parser.parse_args()

    assert args.input_path is not None, 'input_path can not be None, please specify the input_path'
    
    main(args.input_path, args.dataset)