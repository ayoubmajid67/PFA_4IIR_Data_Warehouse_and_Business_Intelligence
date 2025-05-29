select  id,cat,subcat ,maintenance from bronze.erp_px_cat_g1v2;
 

-- check for the categories that did not have any product: 
select id ,cat ,subcat ,maintenance from bronze.erp_px_cat_g1v2
where id not  in (select cat_id from silver.crm_prd_info);

-- data Standardization & Consistency : 
select distinct(maintenance) from bronze.erp_px_cat_g1v2; 
select distinct(subcat) from bronze.erp_px_cat_g1v2;
select distinct(cat) from bronze.erp_px_cat_g1v2;

-- check for unwanted spaces : 
select * from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)

select * from silver.erp_px_cat_g1v2; ss

