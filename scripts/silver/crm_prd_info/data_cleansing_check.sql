-- check for nulls or duplicates in primary key
-- expectation: No Result
select prd_id , count(prd_id) 
from bronze.crm_prd_info 
group by prd_id
having count(prd_id) > 1 ;

-- check the not matches  cat_id in the crm_prd_info table : 
select prd_id,prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info 
where  REPLACE(SUBSTRING(prd_key,1,5),'-','_') not in (select distinct id from bronze.erp_px_cat_g1v2);


-- check the prd_key not found in the bronze.crm_sales_details:
select prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info 
where  REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2)
and  SUBSTRING(prd_key,7,len(prd_key)) not in (select distinct sls_prd_key from bronze.crm_sales_details);


 -- check for unwanted spaces for the prd_nm : 
 select prd_nm 
 from bronze.crm_prd_info
 where prd_nm != TRIM(prd_nm); 

 -- check for nulls or negative numbers for the prd_cost : 
 -- Expectation : No Results 
 select prd_cost  
 from bronze.crm_prd_info
 where prd_cost < 0 or prd_cost is null ; 

 
-- check for invalid data order:
select * 
from bronze.crm_prd_info
where prd_end_dt < prd_start_dt; 