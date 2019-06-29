import sys, os, argparse, multiprocessing
import papermill as pm
import numpy as np 
lib_path = './../Sources'
if (lib_path not in sys.path):
    sys.path.append(lib_path) #src directory
from lpsrec.messaging.telegrambot import Bot

def run_notebook(partition, args):
    print ("Running partition {}/{} for the {} model on the {} dataset".format(partition, args.nodes, args.model_tag, args.dataset_tag))

    bot = Bot(user_credentials='./JFGS.json')

    output_folder = './Output_Notebooks'
    if not os.path.exists(output_folder):
        print ('Creating folder ' + output_folder)
        os.makedirs(output_folder)

    try:
        pm.execute_notebook(
            './{} Case Recommender Eval on Sparsity Datasets.ipynb'.format(args.model_tag),
            os.path.join(output_folder, '{} Case Recommender Eval on Sparsity Datasets [{}][{}].ipynb'.format(args.model_tag, args.dataset_tag, str(partition))),
            parameters = dict(
                dataset_tag = args.dataset_tag,
                model_tag = args.model_tag,
                rank_length = int(args.rank_length),
                random_state = 31415,
                evaluation_metrics = ['PREC', 'RECALL', 'NDCG', 'MRR', 'MAP'],
                bot_alive = True,
                partition = int(partition),
                nodes = int(args.nodes),
                n_folds=int(args.n_folds))
        )
    except Exception as e:
        bot.send_message(text="Error on script for {}-{}[{}/{}]: {}".format(args.dataset_tag, args.model_tag, args.partition, args.nodes, e))
        print (e)

if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--dataset_tag', '-d', dest='dataset_tag', help='A dataset tag ["ML100k", "ML1M", ...] to run the script')
    parser.add_argument('--nodes', '-n', dest='nodes', help='Number of nodes to split the sparsity dataset analysis parallelization')
    parser.add_argument('--partition', '-p', dest='partition', help='The partition to run the script [1 ... nodes]')
    parser.add_argument('--model_tag', '-m', dest='model_tag', help='Model to run the experiments ["MostPopular", "ItemKNN", ...]')
    parser.add_argument('--rank_length', '-r', dest='rank_length', help='An integer representing the rank to train and evaluate the algorithm')
    parser.add_argument('--folds', '-f', dest='n_folds', help='An integer representing the number of folds for cross-validation')
    args = parser.parse_args()

    partitions = [x.strip() for x in args.partition.split(',')]
    processes = list()

    for partition in partitions:
        # run_notebook(partition, args.nodes, args.model_tag, args.dataset_tag)
        p = multiprocessing.Process(target=run_notebook, args=(partition, args))
        processes.append(p)
        p.start()

    for process in processes:
        process.join()

    # python papermill_script.py -d=ML1M -n=10 -m=MostPopular -r=30 -p=1 