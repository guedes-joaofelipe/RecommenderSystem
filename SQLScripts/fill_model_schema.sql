select * from models.model;

insert into models.model 
(name, alias)
values 
('Most Popular', 'MostPopular'),
('Item K-Nearest Neighbors', 'ItemKNN'),
('Item Attribute K-Nearest Neighbors', 'ItemAttKNN'),
('User K-Nearest Neighbors', 'UserKNN'),
('User Attribute K-Nearest Neighbors', 'UserAttKNN'),
('Autoencoder', 'AE'),
('Stacked Autoencoder', 'SAE'),
('Collaborative Denoising Autoencoder', 'CDAE'),
('Factored Item Similarity Matrix', 'FISM'),
('Collaborative Less-is-More Filtering', 'CLiMF'),
('Extended Collaborative Less-is-More Filtering', 'xCLiMF'),
('Bayesian Personalized Ranking', 'BPR'),
('Non-negative Matrix Factorization', 'NMF'),
('Singular Value Decomposition', 'SVD'),
('Singular Value Decomposition Plus Plus', 'SVD++'),
('Paco Recommender', 'PacoRec'),
('Gated Recurrent Unit for Recommenders', 'GRU4REC'),
('Long-short Term Memory', 'LSTM');


insert into models.parameters 
(id_model, name, value)
values
(1, 'rank_length', 30);

select * from datasets.item_info ii inner join datasets.item it on ii.id_item = it.id_item where it.id_dataset = 7

select * from datasets.feedback ii inner join datasets.item it on ii.id_item = it.id_item where it.id_dataset = 7

delete from datasets.item_info where id_item in (select id_item from datasets.item where id_dataset = 7)

update datasets.item set id_item_dataset = 'null' where id_dataset = 7

select count(1) from datasets.item where id_dataset = 7 and id_item_dataset != 'null'