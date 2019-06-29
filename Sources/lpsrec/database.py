import pandas as pd
from sqlalchemy import create_engine, types

__author__ = 'Joao Felipe Guedes <guedes.joaofelipe@poli.ufrj.br>'

def get_database_connection(username, password, host, dbname= 'RecSys', sgbd = 'postgres'): 
    """
        Creates a sqlalchemy.engine for database connection and returns it

        :return: a connection variable to the database 
        :return type: sqlalchemy.engine.base.Engine
    """
    if sgbd.lower() == 'postgres':        
        engine = create_engine('postgresql+psycopg2://{}:{}@{}/{}'.format(username, password, host, dbname))
    return engine 

def get_dataset_from_sparsity(conn = None, data_path = None, dataset_tag = None, uss = 1.0, iss = 1.0, columns = ['user', 'item', 'feedback_value', 'timestamp', 'id_user', 'id_item'], sep = '\t'):
    if conn is None:
        df_dataset = pd.read_csv(data_path, sep=sep, header=None, names=columns)
    else:
        sql_str = "select * from sparsity.get_dataset_from_sparsity('{}', {}, {})".format(dataset_tag, uss, iss)
        df_dataset = pd.read_sql(con= conn , sql=sql_str).reset_index(drop=True)        
        if columns is not None:            
            df_dataset.columns = columns
    
    return df_dataset


if __name__ == '__main__':

    # Unit test for get_database_connection, get_dataset_from_sparsity
    username = 'postgres'
    password = 'admin'
    dbname = 'RecSys'
    host = 'localhost:5432'
    sgbd = 'postgres'

    conn = get_database_connection(username, password, host, dbname, sgbd=sgbd)
    print (conn)

    df_ratings = get_dataset_from_sparsity(data_path=None, conn=conn, dataset_tag='ML100k')
    print ('df_ratings shape: ', df_ratings.shape)
