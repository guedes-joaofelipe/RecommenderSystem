

-- Filling sparsity.cenario

	truncate table sparsity.cenario cascade;

	insert into sparsity.cenario
	(uss, iss)
    SELECT cast(a.n/100.0 as decimal(10,2)) as uss, T2.iss 
    FROM generate_series(10, 100, 2) AS a(n)
    inner join (
    	SELECT b.n, cast(b.n/100.0 as decimal(10,2)) as iss 
    	FROM generate_series(10, 100, 2) AS b(n)
    ) T2 
    	on 1 = 1;
    
    select * from sparsity.cenario


select u.id_user, uss  
from sparsity.users_uss uuss 
inner join datasets."user" u on uuss.id_user = u.id_user 
where id_dataset = 1   
    
-- Query para encontrar USS 
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
) as T1
	

	
-- Query para encontrar ISS 
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
) as T1



select i.id_item, iss  
from sparsity.items_iss iiss 
inner join datasets.item i on iiss.id_item = i.id_item
where id_dataset = 1 and i.id_item = 61    



select id_sparsity_cenario, id_item,   
from sparsity.cenario sc 
inner join sparsity.items_iss iiss on iiss.iss <= sc.iss 
inner join datasets.item i on iiss.id_item = i.id_item and i.id_dataset = 1
where -- id_item = 61
	 sc.uss = 0.1 
	 and sc.iss = 0.11
	 
-- Filling folder table 

insert into sparsity.folder
(id_folder, training_ratio)
SELECT b.n, 0.8 as training_ratio  
FROM generate_series(1, 5, 1) AS b(n); 


select * from sparsity.items_iss


select count(1) from datasets.feedback

