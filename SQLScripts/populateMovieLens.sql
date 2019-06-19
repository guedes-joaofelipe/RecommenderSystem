select * from datasets.clusters 

truncate table datasets.clusters 


-- Register utility 
select * from datasets.utility; 

insert into datasets.utility 
(utility, description)
values 
('movies', 'movies recommendation')

-- Register movieLens as a group of datasets
INSERT INTO datasets.clusters (tag)
VALUES ('MovieLens');

-- Register movieLens 100k 
select * from datasets.dataset

-- Actual parameter values may differ, what you see is a default string representation of values
INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('MovieLens 100k','https://grouplens.org/datasets/movielens/',1,'100k', 1);

INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('MovieLens 1M','https://grouplens.org/datasets/movielens/',1,'1M', 1);

INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('MovieLens 10M','https://grouplens.org/datasets/movielens/',1,'10M', 1);

INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('MovieLens 20M','https://grouplens.org/datasets/movielens/',1,'20M', 1);

-----------------------------
-----------------------------
-----------------------------

-- Loading movieLens 100k

-----------------------------
-----------------------------
-----------------------------



-----------------------------
-- Users 
-----------------------------

drop table if exists transistory.movieLens100k_user;

create table transistory.movieLens100k_user (
	id_user varchar(50), 
	age int, 
	gender varchar(50), 
	occupation varchar(200),
	zipcode varchar(100)
);


COPY transistory.movieLens100k_user(id_user, age, gender, occupation, zipcode) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\100k_raw\u.user' -- 'C:\u.info' 
DELIMITER '|'; -- CSV HEADER;

select * from transistory.movieLens100k_user



select * from datasets.user_info_types

insert into datasets.user_info_types (info_type) values ('occupation');
insert into datasets.user_info_types (info_type) values ('gender');
insert into datasets.user_info_types (info_type) values ('age');
insert into datasets.user_info_types (info_type) values ('zipcode');


-- user_id
insert into datasets."user"
(id_dataset, id_user_dataset)
select 1 as id_dataset, id_user from transistory.movieLens100k_user;

select * from datasets."user";

-- occupation
select * from datasets.user_info;

insert into datasets.user_info
select us.id_user, 
	1 as id_type, -- info type = occupation
	tran.occupation   
from transistory.movieLens100k_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 1 ;


insert into datasets.user_info
select us.id_user, 
	2 as id_type, -- info type = occupation
	tran.gender   
from transistory.movieLens100k_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 1;


insert into datasets.user_info
select us.id_user, 
	3 as id_type, -- info type = occupation
	tran.age   
from transistory.movieLens100k_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 1;


insert into datasets.user_info
select us.id_user, 
	4 as id_type, -- info type = occupation
	tran.zipcode   
from transistory.movieLens100k_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 1;

-----------------------------
-- Items 
-----------------------------

create table transistory.movieLens100k_item (
	id_item varchar(50), 
	title varchar(255), 
	date_release varchar(50), 
	date_release_video varchar(50),
	imdb_url varchar(255),
	genre_unknown int, 
	genre_action int, 
	genre_adventure int, 
	genre_animation int,
	genre_children int, 
	genre_comedy int, 
	genre_crime int, 
	genre_documentary int, 
	genre_drama int, 
	genre_fantasy int, 
	genre_film_noir int,	 
	genre_horror int, 
	genre_musical int, 
	genre_mystery int, 
	genre_romance int, 
	genre_sciFi int, 
	genre_thriller int,     
    genre_war int, 
    genre_western int
);

COPY transistory.movieLens100k_item
(id_item, title, date_release, date_release_video, imdb_url, genre_unknown,  genre_action,  genre_adventure,  genre_animation, genre_children,  genre_comedy,  genre_crime,  genre_documentary,  genre_drama,  genre_fantasy,  genre_film_noir, genre_horror,  genre_musical,  genre_mystery,  genre_romance,  genre_sciFi,  genre_thriller, genre_war, genre_western) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\100k_raw\u.item' -- 'C:\u.info' 
(DELIMITER '|', ENCODING 'LATIN1'); -- CSV HEADER;

select * from transistory.movieLens100k_item 



-- item_id
insert into datasets.item
(id_dataset, id_item_dataset)
select 1 as id_dataset, id_item from transistory.movieLens100k_item;

select * from datasets.item;

select * from datasets.item_info_types;

insert into datasets.item_info_types (info_type) values ('title');
insert into datasets.item_info_types (info_type) values ('date_release');
insert into datasets.item_info_types (info_type) values ('date_release_video');
insert into datasets.item_info_types (info_type) values ('imdb_url');
insert into datasets.item_info_types (info_type) values ('genre_unknown');
insert into datasets.item_info_types (info_type) values ('genre_action');
insert into datasets.item_info_types (info_type) values ('genre_adventure');
insert into datasets.item_info_types (info_type) values ('genre_animation');
insert into datasets.item_info_types (info_type) values ('genre_children');
insert into datasets.item_info_types (info_type) values ('genre_comedy');
insert into datasets.item_info_types (info_type) values ('genre_crime');
insert into datasets.item_info_types (info_type) values ('genre_documentary');
insert into datasets.item_info_types (info_type) values ('genre_drama');
insert into datasets.item_info_types (info_type) values ('genre_fantasy');
insert into datasets.item_info_types (info_type) values ('genre_film_noir');
insert into datasets.item_info_types (info_type) values ('genre_horror');
insert into datasets.item_info_types (info_type) values ('genre_musical');
insert into datasets.item_info_types (info_type) values ('genre_mystery');
insert into datasets.item_info_types (info_type) values ('genre_romance');
insert into datasets.item_info_types (info_type) values ('genre_sciFi');
insert into datasets.item_info_types (info_type) values ('genre_thriller');
insert into datasets.item_info_types (info_type) values ('genre_war');
insert into datasets.item_info_types (info_type) values ('genre_western');



select * from datasets.item_info;

-- title 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.title   
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'title'
where id_dataset = 1 ;

-- date_release 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.date_release   
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'date_release'
where id_dataset = 1 ;

-- date_release_video 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.date_release_video   
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'date_release_video'
where id_dataset = 1 and tran.date_release_video != '';

-- imdb_url 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.imdb_url   
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'imdb_url'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_unknown
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_unknown'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_action
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_action'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_adventure
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_adventure'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_animation
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_animation'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_children
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_children'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_comedy
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_comedy'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_crime
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_crime'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_documentary
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_documentary'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_drama
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_drama'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_fantasy
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_fantasy'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_film_noir
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_film_noir'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_horror
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_horror'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_musical
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_musical'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_mystery
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_mystery'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_romance
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_romance'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_sciFi
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_sciFi'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_thriller
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_thriller'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_war
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_war'
where id_dataset = 1;

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre_western
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre_western'
where id_dataset = 1;

-----------------------------
-- Feedback
-----------------------------

select * from datasets.feedback_type; 

insert into datasets.feedback_type (info_type) values ('explicit'), ('implicit');


create table transistory.movieLens100k_data (
	id_user varchar(50), 
	id_item varchar(50),
	rating varchar(50), 
	time_stamp int
);

COPY transistory.movieLens100k_data
(id_user, id_item, rating, time_stamp) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\100k_raw\u.data' -- 'C:\u.info' 
(DELIMITER E'\t', ENCODING 'UTF8'); -- CSV HEADER;

insert into datasets.feedback 
(id_user, id_item, value, "timestamp", id_feedback_type)
select us.id_user, it.id_item, rating, to_timestamp(time_stamp), ft.id_feedback_type as type  
from transistory.movieLens100k_data tran 
inner join datasets."user" us on us.id_user_dataset = tran.id_user and us.id_dataset = 1 
inner join datasets.item it on it.id_item_dataset = tran.id_item and it.id_dataset = 1
inner join datasets.feedback_type ft on ft.info_type = 'explicit';

select * from datasets.feedback;

drop table if exists transistory.movielens100k_data; 
drop table if exists transistory.movielens100k_user;
drop table if exists transistory.movielens100k_item;


-----------------------------
-----------------------------
-----------------------------

-- Loading movieLens 1M

-----------------------------
-----------------------------
-----------------------------

drop table if exists transistory.movieLens1M_user;

create table transistory.movieLens1M_user (
	id_user varchar(50),
	gender varchar(50),
	age varchar(50), 	 
	occupation varchar(200),
	zipcode varchar(100)
);

COPY transistory.movieLens1M_user(id_user, gender, age, occupation, zipcode) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\1M_raw\users.dat' -- 'C:\u.info' 
DELIMITER ';'; -- CSV HEADER;

select * from transistory.movieLens1M_user

-----------------------------
-- Users
-----------------------------


-- User ID 

insert into datasets."user" 
(id_dataset, id_user_dataset)
select id_dataset, id_user  
from transistory.movieLens1M_user
inner join datasets.dataset dt on name = 'MovieLens 1M' ;

-- occupation
select * from datasets.user_info_TYPES ;

insert into datasets.user_info
select us.id_user, 
	1 as id_type, -- info type = occupation
	tran.occupation   
from transistory.movieLens100k_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 1 ;


insert into datasets.user_info
select us.id_user, 
	1 as id_type, 
	case 
		when occupation = '0' then 'other or not specified'
		when occupation = '1' then 'academic/educator'
		when occupation = '2' then 'artist'
		when occupation = '3' then 'clerical/admin'
		when occupation = '4' then 'college/grad student'
		when occupation = '5' then 'customer service'
		when occupation = '6' then 'doctor/health care'
		when occupation = '7' then 'executive/managerial'
		when occupation = '8' then 'farmer'
		when occupation = '9' then 'homemaker'
		when occupation = '10' then 'K-12 student'
		when occupation = '11' then 'lawyer'
		when occupation = '12' then 'programmer'
		when occupation = '13' then 'retired'
		when occupation = '14' then 'sales/marketing'
		when occupation = '15' then 'scientist'
		when occupation = '16' then 'self-employed'
		when occupation = '17' then 'technician/engineer'
		when occupation = '18' then 'tradesman/craftsman'
		when occupation = '19' then 'unemployed'
		when occupation = '20' then 'writer'
	end as occ 
from transistory.movieLens1M_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 2 ;



select * from transistory.movieLens1M_user tran

insert into datasets.user_info
select us.id_user, 
	2 as id_type, -- info type = gender
	tran.gender   
from transistory.movieLens1M_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 2;


insert into datasets.user_info
select us.id_user, 
	3 as id_type, -- info type = AGE
	tran.age   
from transistory.movieLens1M_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 2;


insert into datasets.user_info
select us.id_user, 
	4 as id_type, -- info type = occupation
	tran.zipcode   
from transistory.movieLens1M_user tran
inner join datasets."user" us on tran.id_user = us.id_user_dataset 
where id_dataset = 2;

select * from datasets.user_info where id_user = 944

-----------------------------
-- Items
-----------------------------

drop table if exists transistory.movieLens1M_item;

create table transistory.movieLens1M_item (
	id_item varchar(50),
	title varchar(255),
	genre varchar(255)
);

COPY transistory.movieLens1M_item(id_item, title, genre) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\1M_raw\movies.dat' -- 'C:\u.info' 
(DELIMITER E'\t', encoding 'LATIN1'); -- CSV HEADER;


select * from transistory.movieLens1M_item where TITLE like '%|%'


-- item_id
insert into datasets.item
(id_dataset, id_item_dataset)
select id_dataset, id_item 
from transistory.movieLens1M_item
inner join datasets.dataset on name = 'MovieLens 1M';

select * from datasets.item where id_dataset = 2;

select * from datasets.item_info;

-- title 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.title   
from transistory.movieLens1M_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'title'
where id_dataset = 2 ;

-- genre

INSERT INTO datasets.item_info_types (info_type) VALUES ('genre');

insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.genre
from transistory.movieLens1M_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'genre'
where id_dataset = 2;


-----------------------------
-- Feedback
-----------------------------

drop table if exists transistory.movieLens1M_data; 

create table transistory.movieLens1M_data (
	id_user varchar(50), 
	id_item varchar(50),
	rating varchar(50), 
	time_stamp int
);

COPY transistory.movieLens1M_data
(id_user, id_item, rating, time_stamp) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\MovieLens\1M_raw\ratings.dat' -- 'C:\u.info' 
(DELIMITER E'\t', ENCODING 'UTF8'); -- CSV HEADER;


insert into datasets.feedback 
(id_user, id_item, value, "timestamp", id_feedback_type)
select us.id_user, it.id_item, rating, to_timestamp(time_stamp), ft.id_feedback_type as type  
from transistory.movieLens1M_data tran 
inner join datasets."user" us on us.id_user_dataset = tran.id_user and us.id_dataset = 2 
inner join datasets.item it on it.id_item_dataset = tran.id_item and it.id_dataset = 2
inner join datasets.feedback_type ft on ft.info_type = 'explicit'
;

select count(1) from datasets.feedback;

drop table if exists transistory.movielens1M_data; 
drop table if exists transistory.movielens1M_user;
drop table if exists transistory.movielens1M_item;

