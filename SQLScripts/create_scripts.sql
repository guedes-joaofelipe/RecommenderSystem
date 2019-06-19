-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2019-04-22 22:16:40.4

-- tables
-- Table: cenario
CREATE TABLE sparsity.cenario (
    id_sparsity_cenario int  NOT NULL,
    uss decimal(10,4)  NOT NULL,
    iss decimal(10,4)  NOT NULL,
    CONSTRAINT cenario_pk PRIMARY KEY (id_sparsity_cenario)
);

-- Table: cenario_items
CREATE TABLE sparsity.cenario_items (
    id_item int  NOT NULL,
    id_sparsity_cenario int  NOT NULL,
    id_dataset int  NOT NULL,
    CONSTRAINT cenario_items_pk PRIMARY KEY (id_item,id_sparsity_cenario,id_dataset)
);

-- Table: cenario_items_folder
CREATE TABLE sparsity.cenario_items_folder (
    id_item int  NOT NULL,
    id_sparsity_cenario int  NOT NULL,
    id_dataset int  NOT NULL,
    folder_id_folder int  NOT NULL,
    CONSTRAINT cenario_items_folder_pk PRIMARY KEY (id_item,id_sparsity_cenario,id_dataset,folder_id_folder)
);

-- Table: cenario_users
CREATE TABLE sparsity.cenario_users (
    id_user int  NOT NULL,
    id_sparsity_cenario int  NOT NULL,
    id_dataset int  NOT NULL,
    CONSTRAINT cenario_users_pk PRIMARY KEY (id_user,id_sparsity_cenario,id_dataset)
);

-- Table: cenario_users_folder
CREATE TABLE sparsity.cenario_users_folder (
    id_user int  NOT NULL,
    id_sparsity_cenario int  NOT NULL,
    id_dataset int  NOT NULL,
    id_folder int  NOT NULL,
    CONSTRAINT cenario_users_folder_pk PRIMARY KEY (id_user,id_sparsity_cenario,id_dataset,id_folder)
);

-- Table: clusters
CREATE TABLE datasets.clusters (
    id_cluster int  NOT NULL DEFAULT nextval('datasets.seq_id_cluster'),
    tag varchar(50)  NULL,
    CONSTRAINT clusters_pk PRIMARY KEY (id_cluster)
);

-- Table: config
CREATE TABLE models.config (
    id_model_configuration int  NOT NULL,
    id_model_parameter int  NOT NULL,
    id_model int  NOT NULL,
    CONSTRAINT config_pk PRIMARY KEY (id_model_configuration)
);

-- Table: dataset
CREATE TABLE datasets.dataset (
    id_dataset int  NOT NULL DEFAULT nextval('datasets.seq_id_dataset'),
    name varchar(50)  NOT NULL,
    url varchar(500)  NULL,
    registers int  NULL,
    size decimal(10,2)  NULL,
    id_cluster int  NOT NULL,
    version varchar(50)  NULL,
    id_utility int  NULL,
    CONSTRAINT id_dataset PRIMARY KEY (id_dataset)
);

drop table datasets.feedback

-- Table: feedback
CREATE TABLE datasets.feedback (
    id_user int  NOT NULL,
    id_item int  NOT NULL,
    value varchar(50)  NOT NULL,
    timestamp timestamp  NULL,
    id_feedback_type int  NOT NULL,
    CONSTRAINT feedback_pk PRIMARY KEY (id_user,id_item)
);

-- Table: feedback_type

CREATE TABLE datasets.feedback_type (
    id_feedback_type int  NOT NULL DEFAULT nextval('datasets.seq_id_feedback_type'),
    info_type varchar(50)  NOT NULL,
    CONSTRAINT feedback_type_pk PRIMARY KEY (id_feedback_type)
);

-- Table: folder
CREATE TABLE sparsity.folder (
    id_folder int  NOT NULL,
    training_ratio decimal(10,2)  NOT NULL,
    CONSTRAINT folder_pk PRIMARY KEY (id_folder)
);

-- Table: item
CREATE TABLE datasets.item (
    id_item int  NOT NULL DEFAULT nextval('datasets.seq_id_item'),
    id_dataset int  NOT NULL,
    id_item_dataset varchar(100)  NOT NULL,
    CONSTRAINT item_pk PRIMARY KEY (id_item)
);

-- Table: item_info
CREATE TABLE datasets.item_info (
    id_item int  NOT NULL,
    id_type int  NOT NULL,
    info varchar(255)  NOT NULL,
    CONSTRAINT item_info_pk PRIMARY KEY (id_item,id_type)
);

-- Table: item_info_types
CREATE TABLE datasets.item_info_types (
    id_type int  NOT NULL DEFAULT nextval('datasets.seq_id_item_info_types'),
    info_type varchar(50)  NOT NULL,
    CONSTRAINT item_info_types_pk PRIMARY KEY (id_type)
);

-- Table: metric
CREATE TABLE results.metric (
    id_metric int  NOT NULL,
    name int  NOT NULL,
    "alias" int  NOT NULL,
    CONSTRAINT metric_pk PRIMARY KEY (id_metric)
);

-- Table: model
CREATE TABLE models.model (
    id_model int  NOT NULL,
    name varchar(100)  NOT NULL,
    "alias" varchar(50)  NOT NULL,
    CONSTRAINT model_pk PRIMARY KEY (id_model)
);

-- Table: overall_sparsity
CREATE TABLE sparsity.overall_sparsity (
    id_sparsity_cenario int  NOT NULL,
    id_dataset int  NOT NULL,
    os decimal(10,4)  NOT NULL,
    CONSTRAINT overall_sparsity_pk PRIMARY KEY (id_sparsity_cenario,id_dataset)
);

-- Table: parameters
CREATE TABLE models.parameters (
    id_model_parameter int  NOT NULL,
    id_model int  NOT NULL,
    name varchar(50)  NOT NULL,
    value varchar(50)  NOT NULL,
    CONSTRAINT parameters_pk PRIMARY KEY (id_model_parameter,id_model)
);

-- Table: simulation
CREATE TABLE results.simulation (
    id_simulation int  NOT NULL,
    id_metric int  NOT NULL,
    id_model_configuration int  NOT NULL,
    id_sparsity_cenario int  NOT NULL,
    result varchar(50)  NOT NULL DEFAULT 0,
    folder int  NOT NULL,
    path_trained_model varchar(255)  NOT NULL,
    training_start timestamp  NOT NULL,
    training_end timestamp  NOT NULL,
    validation_start timestamp  NOT NULL,
    validation_end timestamp  NOT NULL,
    CONSTRAINT simulation_pk PRIMARY KEY (id_simulation)
);

-- Table: user
CREATE TABLE datasets."user" (
    id_user int  NOT NULL DEFAULT nextval('datasets.seq_id_user'),
    id_dataset int  NOT NULL,
    id_user_dataset varchar(100)  NOT NULL,
    CONSTRAINT user_pk PRIMARY KEY (id_user)
);

-- Table: user_info
CREATE TABLE datasets.user_info (
    id_user int  NOT NULL,
    id_type int  NOT NULL,
    info varchar(200)  NOT NULL,
    CONSTRAINT user_info_pk PRIMARY KEY (id_user,id_type)
);

-- Table: user_info_types
CREATE TABLE datasets.user_info_types (
    id_type int  NOT NULL DEFAULT nextval('datasets.seq_id_user_info_types'),
    info_type varchar(50)  NOT NULL,
    CONSTRAINT user_info_types_pk PRIMARY KEY (id_type)
);

-- Table: utility
CREATE TABLE datasets.utility (
    id_utility serial  NOT NULL,
    utility varchar(50)  NOT NULL,
    description varchar(200)  NOT NULL,
    CONSTRAINT utility_pk PRIMARY KEY (id_utility)
);

-- Table: item_iss
drop table sparsity.item_iss;

CREATE TABLE sparsity.item_iss (
    id_item INT  NOT NULL,
    n_feedback INT,
    max_feedback INT,
    iss FLOAT not null, 
    CONSTRAINT item_pk PRIMARY KEY (id_item)
);

select * from sparsity.item_iss

ALTER TABLE sparsity.item_iss ADD CONSTRAINT sparsity_item_iss_datasets_item
    FOREIGN KEY (id_item)
    REFERENCES datasets.item (id_item)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Table: item_iss
drop table if exists sparsity.user_uss;

CREATE TABLE sparsity.user_uss (
    id_user INT  NOT NULL,
    n_feedback INT,
    max_feedback INT,
    uss FLOAT not null, 
    CONSTRAINT user_pk PRIMARY KEY (id_user)
);

select * from sparsity.user_uss

ALTER TABLE sparsity.user_uss ADD CONSTRAINT sparsity_user_uss_datasets_user
    FOREIGN KEY (id_user)
    REFERENCES datasets.user (id_user)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- foreign keys
-- Reference: cenario_items_folder_cenario_items (table: cenario_items_folder)
ALTER TABLE sparsity.cenario_items_folder ADD CONSTRAINT cenario_items_folder_cenario_items
    FOREIGN KEY (id_item, id_sparsity_cenario, id_dataset)
    REFERENCES sparsity.cenario_items (id_item, id_sparsity_cenario, id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_items_folder_folder (table: cenario_items_folder)
ALTER TABLE sparsity.cenario_items_folder ADD CONSTRAINT cenario_items_folder_folder
    FOREIGN KEY (folder_id_folder)
    REFERENCES sparsity.folder (id_folder)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_items_item (table: cenario_items)
ALTER TABLE sparsity.cenario_items ADD CONSTRAINT cenario_items_item
    FOREIGN KEY (id_item)
    REFERENCES datasets.item (id_item)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_items_overall_sparsity (table: cenario_items)
ALTER TABLE sparsity.cenario_items ADD CONSTRAINT cenario_items_overall_sparsity
    FOREIGN KEY (id_sparsity_cenario, id_dataset)
    REFERENCES sparsity.overall_sparsity (id_sparsity_cenario, id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_users_folder_cenario_users (table: cenario_users_folder)
ALTER TABLE sparsity.cenario_users_folder ADD CONSTRAINT cenario_users_folder_cenario_users
    FOREIGN KEY (id_user, id_sparsity_cenario, id_dataset)
    REFERENCES sparsity.cenario_users (id_user, id_sparsity_cenario, id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_users_folder_folder (table: cenario_users_folder)
ALTER TABLE sparsity.cenario_users_folder ADD CONSTRAINT cenario_users_folder_folder
    FOREIGN KEY (id_folder)
    REFERENCES sparsity.folder (id_folder)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_users_overall_sparsity (table: cenario_users)
ALTER TABLE sparsity.cenario_users ADD CONSTRAINT cenario_users_overall_sparsity
    FOREIGN KEY (id_sparsity_cenario, id_dataset)
    REFERENCES sparsity.overall_sparsity (id_sparsity_cenario, id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cenario_users_user (table: cenario_users)
ALTER TABLE sparsity.cenario_users ADD CONSTRAINT cenario_users_user
    FOREIGN KEY (id_user)
    REFERENCES datasets."user" (id_user)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: dataset_dataset_groups (table: dataset)
ALTER TABLE datasets.dataset ADD CONSTRAINT dataset_dataset_groups
    FOREIGN KEY (id_cluster)
    REFERENCES datasets.clusters (id_cluster)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: feedback_feedback_type (table: feedback)
ALTER TABLE datasets.feedback ADD CONSTRAINT feedback_feedback_type
    FOREIGN KEY (id_feedback_type)
    REFERENCES datasets.feedback_type (id_feedback_type)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: items_datasets (table: item)
ALTER TABLE datasets.item ADD CONSTRAINT items_datasets
    FOREIGN KEY (id_dataset)
    REFERENCES datasets.dataset (id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: items_info_items (table: item_info)
ALTER TABLE datasets.item_info ADD CONSTRAINT items_info_items
    FOREIGN KEY (id_item)
    REFERENCES datasets.item (id_item)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: items_info_items_info_types (table: item_info)
ALTER TABLE datasets.item_info ADD CONSTRAINT items_info_items_info_types
    FOREIGN KEY (id_type)
    REFERENCES datasets.item_info_types (id_type)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: model_configuration_model_parameters (table: config)
ALTER TABLE models.config ADD CONSTRAINT model_configuration_model_parameters
    FOREIGN KEY (id_model_parameter, id_model)
    REFERENCES models.parameters (id_model_parameter, id_model)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: model_parameters_model (table: parameters)
ALTER TABLE models.parameters ADD CONSTRAINT model_parameters_model
    FOREIGN KEY (id_model)
    REFERENCES models.model (id_model)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: overall_sparsity_dataset (table: overall_sparsity)
ALTER TABLE sparsity.overall_sparsity ADD CONSTRAINT overall_sparsity_dataset
    FOREIGN KEY (id_dataset)
    REFERENCES datasets.dataset (id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: overall_sparsity_sparsity_cenario (table: overall_sparsity)
ALTER TABLE sparsity.overall_sparsity ADD CONSTRAINT overall_sparsity_sparsity_cenario
    FOREIGN KEY (id_sparsity_cenario)
    REFERENCES sparsity.cenario (id_sparsity_cenario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: rating_item (table: feedback)
ALTER TABLE datasets.feedback ADD CONSTRAINT rating_item
    FOREIGN KEY (id_item)
    REFERENCES datasets.item (id_item)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: rating_user (table: feedback)
ALTER TABLE datasets.feedback ADD CONSTRAINT rating_user
    FOREIGN KEY (id_user)
    REFERENCES datasets."user" (id_user)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: result_metric (table: simulation)
ALTER TABLE results.simulation ADD CONSTRAINT result_metric
    FOREIGN KEY (id_metric)
    REFERENCES results.metric (id_metric)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: result_model_configuration (table: simulation)
ALTER TABLE results.simulation ADD CONSTRAINT result_model_configuration
    FOREIGN KEY (id_model_configuration)
    REFERENCES models.config (id_model_configuration)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: result_sparsity_cenario (table: simulation)
ALTER TABLE results.simulation ADD CONSTRAINT result_sparsity_cenario
    FOREIGN KEY (id_sparsity_cenario)
    REFERENCES sparsity.cenario (id_sparsity_cenario)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_datasets (table: user)
ALTER TABLE datasets."user" ADD CONSTRAINT users_datasets
    FOREIGN KEY (id_dataset)
    REFERENCES datasets.dataset (id_dataset)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_info_users (table: user_info)
ALTER TABLE datasets.user_info ADD CONSTRAINT users_info_users
    FOREIGN KEY (id_user)
    REFERENCES datasets."user" (id_user)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_info_users_info_types (table: user_info)
ALTER TABLE datasets.user_info ADD CONSTRAINT users_info_users_info_types
    FOREIGN KEY (id_type)
    REFERENCES datasets.user_info_types (id_type)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- sequences
-- Sequence: seq_id_cluster
CREATE SEQUENCE datasets.seq_id_cluster
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: seq_id_dataset
CREATE SEQUENCE datasets.seq_id_dataset
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;



-- Sequence: seq_id_feedback_type
CREATE SEQUENCE datasets.seq_id_feedback_type
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: seq_id_item
CREATE SEQUENCE datasets.seq_id_item
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: seq_id_item_info_types
CREATE SEQUENCE datasets.seq_id_item_info_types
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: seq_id_user
CREATE SEQUENCE datasets.seq_id_user
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: seq_id_user_info_types
CREATE SEQUENCE datasets.seq_id_user_info_types
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;


-- Sequence: seq_id_sparsity_cenario
CREATE SEQUENCE sparsity.seq_id_sparsity_cenario
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

CREATE OR REPLACE VIEW sparsity.users_uss AS
select T1.id_user as id_user, 
 T1.n_feedback, 
 max(n_feedback) OVER(PARTITION BY id_dataset, counter) as max_feedback, 
 T1.n_feedback/cast(max(n_feedback) OVER(PARTITION BY id_dataset, counter) as decimal(10, 2)) as uss
from (
select us.id_dataset, fb.id_user, count(1) as n_feedback, 1 as counter  
from datasets.feedback fb 
inner join datasets."user" us on fb.id_user = us.id_user
group by us.id_dataset, fb.id_user
) as T1;


CREATE OR REPLACE VIEW sparsity.items_iss AS
select T1.id_item, 
 T1.n_feedback, 
 max(n_feedback) OVER(PARTITION BY id_dataset, counter) as max_feedback, 
 T1.n_feedback/cast(max(n_feedback) OVER(PARTITION BY id_dataset, counter) as decimal(10, 2)) as iss
from (
select it.id_dataset, fb.id_item, count(1) as n_feedback, 1 as counter  
from datasets.feedback fb 
inner join datasets.item it on fb.id_item = it.id_item
group by it.id_dataset, fb.id_item
) as T1;


-- End of file.

