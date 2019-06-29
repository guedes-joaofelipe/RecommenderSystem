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
VALUES ('Book Crossing','https://grouplens.org/datasets/book-crossing/',3,'BOOKX', 3);

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
 
select * from transistory.bkx_user_temp; 

delete from transistory.bkx_user_temp where line like '"User-ID";"Location";"Age"';

insert into transistory.bkx_user
(id_user, locat, age)
select substring(line, '^"(\d+)";') as id_user, substring(line, '^"\d+";"(.*)";') as locat, substring(line, ';"(\d+)"$') as age 
from transistory.bkx_user_temp;

delete from transistory.bkx_user where id_user is null; 

drop table if exists transistory.bkx_user_temp;

select * from transistory.bkx_user;
select count(1) from transistory.bkx_user where id_user is not null; -- 278858 OK

select * from datasets.user_info_types;

insert into datasets.user_info_types (info_type) values ('location');

-- user_id
delete from datasets."user"
where id_dataset in (select id_dataset from datasets.dataset where version = 'BOOKX' group by id_dataset);

insert into datasets."user"
(id_dataset, id_user_dataset)
select id_dataset, id_user from transistory.bkx_user bk 
inner join datasets.dataset dt on dt.version = 'BOOKX'
where id_user is not null;

select count(1) from transistory.bkx_user where id_user is not null; -- 278858 OK
select count(1) from datasets."user" where id_dataset = 7; -- 278858 OK

select * from datasets.dataset

select * from datasets."user" where id_dataset = 7;

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

drop table if exists transistory.bkx_item;

create table transistory.bkx_item (
	"ISBN" varchar(255),
	"Book-Title" varchar(500),
	"Book-Author" varchar(255),
	"Year-Of-Publication" varchar(255),
	"Publisher" varchar(255),
	"Image-URL-S" varchar(500),
	"Image-URL-M" varchar(500),
	"Image-URL-L" varchar(500)
);

COPY transistory.bkx_item
("ISBN", "Book-Title", "Book-Author", "Year-Of-Publication", "Publisher", "Image-URL-S", "Image-URL-M", "Image-URL-L") 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\BookCrossing\Standard_raw\BX-Books.csv' -- 'C:\u.info' 
(DELIMITER ';', ENCODING 'LATIN1'); -- CSV HEADER;

delete from transistory.bkx_item where "ISBN" like '"ISBN"';

select * from transistory.bkx_item; 



-- item_id
insert into datasets.item
(id_dataset, id_item_dataset)
select 7 as id_dataset, substring("ISBN",'^"(.*)"')  as id_item from transistory.bkx_item;

-- Verificando se todos os itens foram inseridos
select count(1) from transistory.bkx_item; -- 271379 OK
select count(1) from datasets.item where id_dataset = 7; -- 271379 OK

select * from datasets.item where id_dataset = 7;

select * from datasets.item_info_types;

/*
 * Falta inserir os meta dados dos itens !!!!!!!!!!!!!!!!!
 * 
 * */

insert into datasets.item_info_types (info_type) values ('title');




select * from datasets.item_info;

select * from transistory.bkx_item;



-- title 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	substring(tran."Book-Title",'^"(.*)"$')
from transistory.bkx_item tran
inner join datasets.item it on substring(tran."ISBN",'^"(.*)"') = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'title'
where id_dataset = 7 ;

-- date_release 
insert into datasets.item_info
select it.id_item, 
	ty.id_type as id_type, -- info type = occupation
	tran.date_release   
from transistory.movieLens100k_item tran
inner join datasets.item it on tran.id_item = it.id_item_dataset
inner join datasets.item_info_types ty on info_type = 'date_release'
where id_dataset = 1 ;


-----------------------------
-- Feedback
-----------------------------

select * from datasets.feedback_type; 

insert into datasets.feedback_type (info_type) values ('explicit'), ('implicit');

drop table if exists transistory.bkx_data;

create table transistory.bkx_data (
	id_user varchar(50), 
	id_item varchar(50),
	rating varchar(50)
);

COPY transistory.bkx_data
(id_user, id_item, rating) 
FROM 'G:\Google Drive\PersonalRep\ProjetoFinal\Workspace\Datasets\BookCrossing\Standard_raw\BX-Book-Ratings.csv' -- 'C:\u.info' 
(DELIMITER ';', ENCODING 'UTF8'); -- CSV HEADER;

select count(1) from transistory.bkx_data; -- 149780 OK

delete from transistory.bkx_data where id_user = '"User-ID"'; 

update transistory.bkx_data set id_user = substring(id_user,'^"(.*)"');
update transistory.bkx_data set id_item = substring(id_item,'^"(.*)"');
update transistory.bkx_data set rating = substring(rating,'^"(.*)"');


/*
 * Parei aqui
 * 
 * */
insert into datasets.feedback 
(id_user, id_item, value, id_feedback_type)


select count(1) from (
select us.id_user, it.id_item, rating, ft.id_feedback_type as type  
from transistory.bkx_data tran 
inner join datasets."user" us on us.id_user_dataset = tran.id_user and us.id_dataset = 7 
inner join datasets.item it on it.id_item_dataset = tran.id_item and it.id_dataset = 7
inner join datasets.feedback_type ft on ft.info_type = 'explicit') T1;

select * from datasets.feedback;

drop table if exists transistory.movielens100k_data; 
drop table if exists transistory.movielens100k_user;
drop table if exists transistory.movielens100k_item;