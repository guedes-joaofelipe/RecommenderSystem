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

select * from sparsity.get_dataset_from_sparsity('ML100k', 1.0, 1.0)

select ds."version", count(1), ds.id_dataset
from datasets.feedback fb
inner join datasets."user" us on fb.id_user = us.id_user
inner join datasets.item it on fb.id_item = it.id_item
inner join datasets.dataset ds on ds.id_dataset = it.id_dataset and us.id_dataset = ds.id_dataset
group by ds."version", ds.id_dataset

select * from datasets.dataset

update datasets.dataset a 
set a.registers = b.registers
from (
	select ds."version", count(1) as registers, ds.id_dataset
	from datasets.feedback fb
	inner join datasets."user" us on fb.id_user = us.id_user
	inner join datasets.item it on fb.id_item = it.id_item
	inner join datasets.dataset ds on ds.id_dataset = it.id_dataset and us.id_dataset = ds.id_dataset
	group by ds."version", ds.id_dataset	
) b
where a.id_dataset = b.id_dataset

from datasets.feedback fb
inner join datasets."user" us on fb.id_user = us.id_user
inner join datasets.item it on fb.id_item = it.id_item
inner join datasets.dataset ds on ds.id_dataset = it.id_dataset and us.id_dataset = ds.id_dataset
group by ds."version"

