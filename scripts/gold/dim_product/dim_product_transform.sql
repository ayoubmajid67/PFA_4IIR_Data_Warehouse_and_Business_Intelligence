-- check for number of items history for each product  :
select prd_key,count(*)   from silver.crm_prd_info group by prd_key having count(*) >1 ;
SELECT pri.*
FROM silver.crm_prd_info pri
JOIN (
  SELECT prd_key
  FROM silver.crm_prd_info
  GROUP BY prd_key
  HAVING COUNT(*) > 1
) dup
ON pri.prd_key = dup.prd_key;






CREATE VIEW gold.dim_products AS
select 
row_number() over (order by pri.prd_start_dt) as product_key,
pri.prd_id as product_id,
pri.prd_key as product_number,
pri.prd_nm as product_name,
pri.cat_id as category_id,
prc.cat as category,
prc.subcat as subcategory,
prc.maintenance ,
pri.prd_cost as cost,
pri.prd_line as product_line,
pri.prd_start_dt as start_date
from silver.crm_prd_info pri
left join silver.erp_px_cat_g1v2 prc
on pri.cat_id =prc.id
where pri.prd_end_dt is null -- Filter out all historical dat


select * from gold.dim_products;



