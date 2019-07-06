SELECT * FROM datasets.dataset

select * from public.dataset


DROP FUNCTION sparsity.get_dataset_from_sparsity

CREATE FUNCTION sparsity.get_dataset_from_sparsity(in in_dataset_version VARCHAR(50), in in_uss FLOAT, in in_iss FLOAT)
 RETURNS TABLE (
 	id_user_dataset VARCHAR(100), 
 	id_item_dataset VARCHAR(100), 
 	value VARCHAR(50),
 	"timestamp" timestamp,
 	id_user INT, 
 	id_item INT
 ) 
 as $$
begin	
  return query 
  	select us.id_user_dataset, it.id_item_dataset, fb.value, fb."timestamp", us.id_user, it.id_item 
	from datasets.feedback fb
	inner join datasets."user" us on fb.id_user = us.id_user 
	inner join datasets.item it on fb.id_item = it.id_item 
	inner join datasets.dataset ds on it.id_dataset = ds.id_dataset and us.id_dataset = ds.id_dataset
	inner join sparsity.item_iss iiss on iiss.id_item = it.id_item
	inner join sparsity.user_uss uuss on uuss.id_user = us.id_user
	where ds.version = in_dataset_version
		and iiss.iss <= in_iss
		and uuss.uss <= in_uss;  
END; $$
LANGUAGE 'plpgsql';

select count(1) from sparsity.get_dataset_from_sparsity('BOOKX', 1.0, 1.0)

select ds."version", count(1), ds.id_dataset
from datasets.feedback fb
inner join datasets."user" us on fb.id_user = us.id_user
inner join datasets.item it on fb.id_item = it.id_item
inner join datasets.dataset ds on ds.id_dataset = it.id_dataset and us.id_dataset = ds.id_dataset
group by ds."version", ds.id_dataset

select * from datasets.dataset

/*
 * Update Dataset Statistics  
 */

DROP PROCEDURE datasets.update_stats;

CREATE PROCEDURE datasets.update_stats() 
 as $$
begin	
  
  	truncate table sparsity.item_iss;
  
 	update datasets.dataset  as T1
	set T1.registers = b.registers
	from (
		select ds."version", count(1) as registers, ds.id_dataset
		from datasets.feedback fb
		inner join datasets."user" us on fb.id_user = us.id_user
		inner join datasets.item it on fb.id_item = it.id_item
		inner join datasets.dataset ds on ds.id_dataset = it.id_dataset and us.id_dataset = ds.id_dataset
		group by ds."version", ds.id_dataset	
	) b
	where T1.id_dataset = b.id_dataset; 

END; $$
LANGUAGE 'plpgsql';

call datasets.update_stats();

select * from datasets.clusters;


/*
 * Update ISS Procedure 
 */ 

DROP PROCEDURE sparsity.update_iss;

CREATE PROCEDURE sparsity.update_iss() 
 as $$
begin	
  
  	truncate table sparsity.item_iss;
  
 	insert into sparsity.item_iss 
	(id_item, n_feedback, max_feedback, iss)
	select T1.id_item, 
	    T1.n_feedback, 
	    max(n_feedback) OVER(PARTITION BY id_dataset, counter) as max_feedback, 
	    1-T1.n_feedback/cast(max(n_feedback) OVER(PARTITION BY id_dataset, counter) as decimal(10, 2)) as iss
	from (
	    select it.id_dataset, fb.id_item, count(1) as n_feedback, 1 as counter  
	    from datasets.feedback fb 
	    inner join datasets.item it on fb.id_item = it.id_item	
	    group by it.id_dataset, fb.id_item	
	) as T1 ; 

END; $$
LANGUAGE 'plpgsql';

CALL sparsity.update_iss() ;

/*
 * Update USS Procedure 
 */ 

DROP PROCEDURE sparsity.update_uss;

CREATE PROCEDURE sparsity.update_uss() 
 as $$
begin	
  
  	truncate table sparsity.user_uss;
  
 	insert into sparsity.user_uss 
	(id_user, n_feedback, max_feedback, uss)
	select T1.id_user, 
	    T1.n_feedback, 
	    max(n_feedback) OVER(PARTITION BY id_dataset, counter) as max_feedback, 
	    1 - T1.n_feedback/cast(max(n_feedback) OVER(PARTITION BY id_dataset, counter) as decimal(10, 2)) as uss
	from (
	    select us.id_dataset, fb.id_user, count(1) as n_feedback, 1 as counter  
	    from datasets.feedback fb 
	    inner join datasets."user" us on fb.id_user = us.id_user
	    group by us.id_dataset, fb.id_user
	) as T1;

END; $$
LANGUAGE 'plpgsql';

CALL sparsity.update_uss() ;



select count(1) from sparsity.get_dataset_from_sparsity('BOOKX', 1.0, 1.0)
