import recbole
import pandas as pd
from logging import getLogger

from recbole.config import Config
from recbole.utils import init_logger, get_model, get_trainer, init_seed
from recbole.data import create_dataset, data_preparation
from recbole.utils.utils import set_color
# from recbole.dataset.dataset
import numpy as np

def gini(inter_num, total):

    x = np.concatenate([np.ones(inter_num), np.zeros(total-inter_num)])
    
    # Mean absolute difference
    mad = np.abs(np.subtract.outer(x, x)).mean()
    # Relative mean absolute difference
    rmad = mad/np.mean(x)
    # Gini coefficient
    g = 0.5 * rmad
    return g

def _get_illegal_ids_by_sparsity(dataset, config, entity, sparsity_filter, sparsity_threshold):
    if entity == 'item':
        df_inter_num = dataset.inter_feat.groupby(config['ITEM_ID_FIELD']).count().iloc[:,1]
        total = dataset.user_num
    else:
        df_inter_num = dataset.inter_feat.groupby(config['USER_ID_FIELD']).count().iloc[:,1]
        total = dataset.item_num

    if sparsity_filter == 'gini':
        df_inter_num = df_inter_num.apply(lambda x: gini(x, total))

    elif sparsity_filter == 'relative':
        df_inter_num /= df_inter_num.max()
        df_inter_num = 1-df_inter_num

    return df_inter_num[df_inter_num > sparsity_threshold].index

def _filter_by_sparsity(dataset, config, sparsity_filter, sparsity_threshold):
    ban_users = _get_illegal_ids_by_sparsity(dataset, config, 'user', sparsity_filter, sparsity_threshold)
    ban_items = _get_illegal_ids_by_sparsity(dataset, config, 'item', sparsity_filter, sparsity_threshold)

    # if len(ban_users) == 0 and len(ban_items) == 0:
    #     break

    if dataset.user_feat is not None:
        dropped_user = dataset.user_feat[dataset.uid_field].isin(ban_users)
        dataset.user_feat.drop(dataset.user_feat.index[dropped_user], inplace=True)

    if dataset.item_feat is not None:
        dropped_item = dataset.item_feat[dataset.iid_field].isin(ban_items)
        dataset.item_feat.drop(dataset.item_feat.index[dropped_item], inplace=True)

    dropped_inter = pd.Series(False, index=dataset.inter_feat.index)
    user_inter = dataset.inter_feat[dataset.uid_field]
    item_inter = dataset.inter_feat[dataset.iid_field]
    dropped_inter |= user_inter.isin(ban_users)
    dropped_inter |= item_inter.isin(ban_items)

    dropped_index = dataset.inter_feat.index[dropped_inter]
    dataset.logger.debug(f'[{len(dropped_index)}] dropped interactions.')
    dataset.inter_feat.drop(dropped_index, inplace=True)

    return dataset

def main(model=None, dataset=None, data_path=None, saved=True):

    config = Config(
        model=model, 
        config_file_list=['./rec-sparsity/tests/example.yaml'])

    init_seed(config['seed'], config['reproducibility'])

    # logger initialization
    init_logger(config)
    logger = getLogger()

    logger.info(config)

    #dataset filtering
    dataset = create_dataset(config)
    print (dataset.inter_feat.head())
    logger.info(dataset)
    print (1-(dataset.inter_feat.shape[0])/((dataset.inter_feat[dataset.iid_field].nunique()+1)*(dataset.inter_feat[dataset.uid_field].nunique()+1)))
    print (dataset.inter_feat[dataset.uid_field].nunique())
    print (dataset.inter_feat[dataset.iid_field].nunique())

    sparsity_filter='relative'
    sparsity_threshold=0.6
    dataset = _filter_by_sparsity(dataset, config, sparsity_filter, sparsity_threshold)
    logger.info(dataset)

    print (dataset.inter_feat.head())
    print (1-dataset.inter_feat.shape[0]/(dataset.inter_feat[dataset.iid_field].nunique()*dataset.inter_feat[dataset.uid_field].nunique()))
    print (dataset.inter_feat[dataset.uid_field].nunique())
    print (dataset.inter_feat[dataset.iid_field].nunique())
    exit()
    # dataset splitting
    train_data, valid_data, test_data = data_preparation(config, dataset)

    # model loading and initialization
    model = get_model(config['model'])(config, train_data).to(config['device'])
    logger.info(model)

    # trainer loading and initialization
    trainer = get_trainer(config['MODEL_TYPE'], config['model'])(config, model)

    # model training
    best_valid_score, best_valid_result = trainer.fit(
        train_data, valid_data, 
        saved=saved, show_progress=config['show_progress'],
        verbose=False
    )
    # trainer.plot_train_loss()
    # saved_model_file = '{}-{}.pth'.format(config['model'], get_local_time())
    # trainer.resume_checkpoint(os.path.join(config['checkpoint_dir'], saved_model_file))

    # model evaluation
    test_result = trainer.evaluate(
        test_data, 
        load_best_model=saved, 
        model_file=None,
        show_progress=config['show_progress']
    )

    logger.info(set_color('best valid ', 'yellow') + f': {best_valid_result}')
    logger.info(set_color('test result', 'yellow') + f': {test_result}')

if __name__ == "__main__":

    model = 'ItemKNN'
    data_path = 'dataset/test/'
    main(model=model, data_path=data_path)