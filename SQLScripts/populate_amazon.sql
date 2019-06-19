/*
 * Populate Amazon Dataset 
 * 
 * */

-- Register amazon as a group of datasets
INSERT INTO datasets.clusters (tag)
VALUES ('Amazon');

select * from datasets.clusters

-- Register Utilities
insert into datasets.utility (utility, description)
values ('video', 'video recommendation');

select * from datasets.utility;

-- Register Amazon Datasets 
select * from datasets.dataset;

-- Actual parameter values may differ, what you see is a default string representation of values
INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('Amazon Movies and TV','http://jmcauley.ucsd.edu/data/amazon/',2,'AMZMTV', 1);

INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('Amazon Instant Video','http://jmcauley.ucsd.edu/data/amazon/',2,'AMZIV', 2);


-----------------------------
-----------------------------
-----------------------------

-- Loading MoviesTV Dataset

-----------------------------
-----------------------------
-----------------------------

-----------------------------
-- Feedback 
-----------------------------

drop table if exists transistory.amznMT_data;

create table transistory.amznMT_data (
	id_user varchar(50), 
	id_item varchar(50),
	rating varchar(50), 
	time_stamp int
);

COPY transistory.amznMT_data
(id_user, id_item, rating, time_stamp) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\Amazon\MoviesTV_raw\ratings_Movies_and_TV.csv' -- 'C:\u.info' 
(DELIMITER E',', ENCODING 'UTF8'); -- CSV HEADER;


select * from transistory.amznMT_data amz where id_item = 'B000BITV10';

-----------------------------
-- Users 
-----------------------------

insert into datasets."user"
(id_dataset, id_user_dataset)
select id_dataset, id_user 
from transistory.amznMT_data amz
inner join datasets.dataset dt on dt.name = 'Amazon Movies and TV'
group by id_dataset, id_user;

select count(1) from datasets."user" where id_dataset = 5; -- 2.088.620

-----------------------------
-- Items
-----------------------------

insert into datasets.item
(id_dataset, id_item_dataset)
select id_dataset, id_item 
from transistory.amznMT_data amz
inner join datasets.dataset dt on dt.name = 'Amazon Movies and TV'
group by id_dataset, id_item;

select count(1) from datasets.item where id_dataset = 5; -- 200.941

-----------------------------
-- Feedback
-----------------------------

insert into datasets.feedback 
(id_user, id_item, value, "timestamp", id_feedback_type)
select us.id_user, it.id_item, rating, to_timestamp(time_stamp), ft.id_feedback_type as type  
from transistory.amznMT_data tran
inner join datasets.dataset dt on dt.name = 'Amazon Movies and TV'
inner join datasets."user" us on us.id_user_dataset = tran.id_user and us.id_dataset = dt.id_dataset 
inner join datasets.item it on it.id_item_dataset = tran.id_item and it.id_dataset = dt.id_dataset
inner join datasets.feedback_type ft on ft.info_type = 'explicit';

select * from datasets.item_info;


-----------------------------
-----------------------------
-----------------------------

-- Loading Instant Video Dataset

-----------------------------
-----------------------------
-----------------------------

-----------------------------
-- Feedback 
-----------------------------

drop table if exists transistory.amznIV_data;

create table transistory.amznIV_data (
	id_user varchar(50), 
	id_item varchar(50),
	rating varchar(50), 
	time_stamp int
);

COPY transistory.amznIV_data
(id_user, id_item, rating, time_stamp) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\Amazon\InstantVideo_raw\ratings_Amazon_Instant_Video.csv' -- 'C:\u.info' 
(DELIMITER E',', ENCODING 'UTF8'); -- CSV HEADER;


select * from transistory.amznIV_data;


select * from datasets.user where id_user_dataset = 'ACX8YW2D5EGP6'

-----------------------------
-- Users 
-----------------------------

insert into datasets."user"
(id_dataset, id_user_dataset)
select id_dataset, id_user 
from transistory.amznIV_data amz
inner join datasets.dataset dt on dt.name = 'Amazon Instant Video'
group by id_dataset, id_user;

select count(1) from datasets."user" where id_dataset = 6; -- 426.922

-----------------------------
-- Items
-----------------------------

insert into datasets.item
(id_dataset, id_item_dataset)
select id_dataset, id_item 
from transistory.amznIV_data amz
inner join datasets.dataset dt on dt.name = 'Amazon Instant Video'
group by id_dataset, id_item;

select count(1) from datasets.item where id_dataset = 6; -- 23.965

-----------------------------
-- Feedback
-----------------------------

insert into datasets.feedback 
(id_user, id_item, value, "timestamp", id_feedback_type)
select us.id_user, it.id_item, rating, to_timestamp(time_stamp), ft.id_feedback_type as type  
from transistory.amznIV_data tran
inner join datasets.dataset dt on dt.name = 'Amazon Instant Video'
inner join datasets."user" us on us.id_user_dataset = tran.id_user and us.id_dataset = dt.id_dataset 
inner join datasets.item it on it.id_item_dataset = tran.id_item and it.id_dataset = dt.id_dataset
inner join datasets.feedback_type ft on ft.info_type = 'explicit';



