use DataWarehouse;
-- check for not valid cid : 
select REPLACE(cid,'-','') cid,cntry from bronze.erp_loc_a101 where REPLACE(cid,'-','') not in (select cst_key from silver.crm_cust_info) ;

select cst_key from silver.crm_cust_info;

-- check for null cntry 
select REPLACE(cid,'-','') cid,cntry from bronze.erp_loc_a101 where cntry is null ;


-- Data Standardization & consistency:
select distinct cntry ,case  when Trim(cntry)='DE' then 'Germany'
      when Trim(cntry) in ('USA','US') then 'United States'
      when Trim(cntry) ='' or cntry is null then 'n/a'
else Trim(cntry) end old_countries from bronze.erp_loc_a101 ;

--- check for empty values: 
select cntry from bronze.erp_loc_a101 where TRIM(cntry) = ''



