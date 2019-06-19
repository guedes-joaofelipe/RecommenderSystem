select * from datasets.clusters 

-- Register utility 
select * from datasets.utility; 

insert into datasets.utility 
(utility, description)
values 
('books', 'books recommendation')

-- Register movieLens as a group of datasets
select * from datasets.clusters;

INSERT INTO datasets.clusters (tag)
VALUES ('BookCrossing');

-- Register Books Crossing 
select * from datasets.dataset;

-- Actual parameter values may differ, what you see is a default string representation of values
INSERT INTO datasets.dataset ("name",url,id_cluster,"version", id_utility)
VALUES ('Book Crossing','',3,'BOOKX', 3);

-----------------------------
-----------------------------
-----------------------------

-- Loading BOOKX

-----------------------------
-----------------------------
-----------------------------

-----------------------------
-- Users 
-----------------------------

drop table if exists transistory.bkx_user;
drop table if exists transistory.bkx_user_temp;

create table transistory.bkx_user (
	id_user varchar(50), 
	locat varchar(255),
	age varchar(10)
);

create table transistory.bkx_user_temp (
	line varchar(255)
);

COPY transistory.bkx_user_temp(line) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\BookCrossing\Standard_raw\BX-Users.csv'
; -- 'C:\u.info'
 
delete from transistory.bkx_user_temp where line like '"User-ID";"Location";"Age"';

insert into transistory.bkx_user
(id_user, locat, age)
select substring(line, '^"(\d+)";') as id_user, substring(line, '^"\d+";"(.*)";') as locat, substring(line, ';"(\d+)"$') as age 
from transistory.bkx_user_temp;

drop table if exists transistory.bkx_user_temp;

select * from transistory.bkx_user;

select * from datasets.user_info_types;

insert into datasets.user_info_types (info_type) values ('location');

-- user_id
insert into datasets."user"
(id_dataset, id_user_dataset)
select id_dataset, id_user from transistory.bkx_user bk 
inner join datasets.dataset dt on dt.version = 'BOOKX'
where id_user is not null;

select * from datasets.dataset

select * from datasets."user";

-- location
select * from datasets.user_info_types 

insert into datasets.user_info

select id_dataset, id_user from transistory.bkx_user bk 
inner join datasets.dataset dt on dt.version = 'BOOKX'
where id_user is not null;


select * from datasets.user_info 
inner join datasets."user" us on tran.id_user = us.id_user_dataset

--delete from datasets.user_info 
--where id_user in (
--select us.id_user from datasets.user_info tran
--inner join datasets."user" us on tran.id_user = us.id_user 
--where id_dataset = 7 )

insert into datasets.user_info
(id_user, id_type, info)
select us.id_user, 
	id_type, -- info type = occupation
	tran.locat   
from transistory.bkx_user tran
inner join datasets.dataset dt on dt.version = 'BOOKX'
inner join datasets."user" us on tran.id_user = us.id_user_dataset and us.id_dataset = dt.id_dataset
inner join datasets.user_info_types uit on uit.info_type = 'location'
where tran.id_user is not null and tran.locat is not null  
;


insert into datasets.user_info
(id_user, id_type, info)
select us.id_user, 
	id_type, -- info type = occupation
	tran.age   
from transistory.bkx_user tran
inner join datasets.dataset dt on dt.version = 'BOOKX'
inner join datasets."user" us on tran.id_user = us.id_user_dataset and us.id_dataset = dt.id_dataset
inner join datasets.user_info_types uit on uit.info_type = 'age'
where tran.id_user is not null and tran.age is not null  
;



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