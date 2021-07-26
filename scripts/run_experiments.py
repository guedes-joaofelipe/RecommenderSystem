import yaml
import io
import argparse
import logging
from recbole.config import Config


def main(model, dataset, config_files):
    print (config_files)
    config = Config(model, dataset, config_files)    
    logger.debug(config)

    event_configs = []
    for iss_quantile in config['sparsity_quantiles']:
        for uss_quantile in config['sparsity_quantiles']:
            event_config = config
            event_config['max_iss_quantile'] = iss_quantile
            event_config['max_uss_quantile'] = uss_quantile
            event_configs.append(event_config)

    # start_subscriber()
    # publish_configs(event_configs)


if __name__ == '__main__':
    
    logging.basicConfig(format='%(asctime)-15s %(message)s', level=logging.DEBUG)
    logger = logging.getLogger()

    parser = argparse.ArgumentParser()
    parser.add_argument('--model', '-m', type=str, default='BPR', help='name of models')
    parser.add_argument('--dataset', '-d', type=str, default='ml-100k', help='name of datasets')
    # parser.add_argument('--config_file_list', type=str, default=None, help='config file')

    args = parser.parse_args()
    # config_file_list = args.config_file_list.strip().split(' ') if args.config_file_list else None
    config_file_list = ['./configs/overall.yaml', f'./configs/{args.dataset}.yaml', f'./configs/{args.model}.yaml']
    
    main(args.model, args.dataset, config_file_list)

# python ./scripts/run_experiments.py --config_files "./configs/overall.yaml ./configs/BPR.yaml ./configs/ml-100k.yaml"