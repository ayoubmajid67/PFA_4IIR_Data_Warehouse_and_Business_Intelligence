--  replace the cid - with empty character to match the format of the cust_key in the cust_info table :

select REPLACE(cid,'-','') cid,cntry from bronze.erp_loc_a101 where REPLACE(cid,'-','')  in (select cst_key from silver.crm_cust_info) ;

select cst_key from silver.crm_cust_info;


-- Data Standardization & consistency:
select distinct cntry from bronze.erp_loc_a101 ;

--- remove the empty countries: 
select REPLACE(cid,'-','') cid ,  
case  when Trim(cntry)='DE' then 'Germany'
      when Trim(cntry) in ('USA','US') then 'United States'
      when Trim(cntry) ='' or cntry is null then 'n/a'
else Trim(cntry)
end cntry
 
from bronze.erp_loc_a101

select cst_key from silver.crm_cust_info;



select cntry from bronze.erp_loc_a101 where TRIM(cntry) = ''


-- insert query into the silver layer : 
insert into  silver.erp_loc_a101 (cid,cntry)

select REPLACE(cid,'-','') cid ,  
case  when Trim(cntry)='DE' then 'Germany'
      when Trim(cntry) in ('USA','US') then 'United States'
      when Trim(cntry) ='' or cntry is null then 'n/a'
else Trim(cntry)
end cntry
 
from bronze.erp_loc_a101

select cst_key from silver.crm_cust_info;

select * from silver.erp_loc_a101;
