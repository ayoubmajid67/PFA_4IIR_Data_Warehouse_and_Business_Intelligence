-- client : 
SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
az12.bdate ,
az12.gen,
loc.cntry

FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 az12
on ci.cst_key = az12.cid
left join silver.erp_loc_a101 loc 
on loc.cid = ci.cst_key ;

-- check for duplicate cst_key : 
select cst_key,count(*) from (
SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
az12.bdate ,
az12.gen,
loc.cntry

FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 az12
on ci.cst_key = az12.cid
left join silver.erp_loc_a101 loc 
on loc.cid = ci.cst_key ) t 
group by cst_key
having count(*) > 1; 



select * from silver.erp_loc_a101;



-- gender integration  check : 
SELECT distinct
ci.cst_gndr,
ca.gen,
case when ci.cst_gndr !='n/a' then ci.cst_gndr 
else coalesce(ca.gen,'n/a')
end new_gen

FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 loc 
on loc.cid = ci.cst_key ;

-- insert query  :
CREATE VIEW gold.dim_customers AS
SELECT 
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr !='n/a' then ci.cst_gndr 
else coalesce(ca.gen,'n/a')
end gender,
loc.cntry as country,
ca.bdate as birthdate,
ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 loc 
on loc.cid = ci.cst_key ;

