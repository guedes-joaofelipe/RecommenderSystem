import sys, os, argparse, multiprocessing
import papermill as pm
import numpy as np 
lib_path = './../Sources'
if (lib_path not in sys.path):
    sys.path.append(lib_path) #src directory
from lpsrec.messaging.telegrambot import Bot

def run_notebook(model_tag, dataset_tag, args):
    print ("Running model tag {} plot ({} nodes) for the {} dataset".format(model_tag, args.nodes, dataset_tag))

    bot = Bot(user_credentials='./JFGS.json')

    output_folder = './Output_Notebooks'
    if not os.path.exists(output_folder):
        print ('Creating folder ' + output_folder)
        os.makedirs(output_folder)

    try:
        pm.execute_notebook(
            './Plot Case Recommender Eval (Papermill Version).ipynb',
            os.path.join(output_folder, '{} Plots Case Recommender Eval [{}].ipynb'.format(model_tag, dataset_tag)),
            parameters = dict(
                dataset_tag = dataset_tag,
                model_tag = model_tag,
                rank_length = int(args.rank_length),                
                evaluation_metrics = ['PREC', 'RECALL', 'NDCG', 'MRR', 'MAP'],
                bot_alive = True,                
                nodes = int(args.nodes),
                n_folds=int(args.n_folds))
        )
    except Exception as e:
        bot.send_message(text="Error on script for {}-{}: {}".format(dataset_tag, model_tag, e))
        print (e)

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--dataset_tag', '-d', dest='dataset_tag', help='A dataset tag ["ML100k", "ML1M", ...] to run the script')
    parser.add_argument('--nodes', '-n', dest='nodes', help='Number of nodes to split the sparsity dataset analysis parallelization')    
    parser.add_argument('--rank_length', '-r', dest='rank_length', help='An integer representing the rank to train and evaluate the algorithm')
    parser.add_argument('--folds', '-f', dest='n_folds', help='An integer representing the number of folds for cross-validation')
    parser.add_argument('--model_tag', '-m', dest='model_tag', help='Model to run the experiments ["MostPopular", "ItemKNN", ...]')
    args = parser.parse_args()

    model_tags = [x.strip() for x in args.model_tag.split(',')]
    dataset_tags = [x.strip() for x in args.dataset_tag.split(',')]
    processes = list()

    for dataset_tag in dataset_tags:
        for model_tag in model_tags:
            # run_notebook(partition, args.nodes, args.model_tag, args.dataset_tag)
            p = multiprocessing.Process(target=run_notebook, args=(model_tag, dataset_tag, args))
            processes.append(p)
            p.start()

    for process in processes:
        process.join()

    # python papermill_plot_run.py -d=ML1M -n=10 -r=30 -f=5 -m=MostPopular,ItemKNN,NMF