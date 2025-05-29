-- check for trim in the sls_prd_key : 
SELECT  [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [DataWarehouse].[bronze].[crm_sales_details]
  where sls_ord_num != Trim(sls_ord_num)



-- check for not exists sls_prd_key in the crm_prd_info : 
SELECT  [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [DataWarehouse].[bronze].[crm_sales_details]
  where sls_prd_key not in (select prd_key from silver.crm_prd_info)

  
-- check for not exists sls_cust_id in the crm_cust_info : 
SELECT  [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
  FROM [DataWarehouse].[bronze].[crm_sales_details]
  where sls_cust_id not in (select cst_id from silver.crm_cust_info)


  -- check for invliad dates 
  select  sls_order_dt 
  from bronze.crm_sales_details
  where sls_order_dt <= 0; 

  -- check the length of each numnber 
  select sls_order_dt 
  from bronze.crm_sales_details
  where len(sls_order_dt) !=8

  -- check for invalid sls_order_dt dates time 
  select sls_order_dt
  from bronze.crm_sales_details
  where sls_order_dt > 20500101 or sls_order_dt < 19000101  -- 2050/01/01 y/m/d
   
 -- check for invalid sls_ship_dt dates time
 select nullif(sls_ship_dt,0) sls_ship_dt 
 from bronze.crm_sales_details
 where sls_ship_dt <=0 
or len(sls_ship_dt) !=8
or sls_ship_dt > 20500101 or sls_ship_dt < 19000101

-- check for sls_order_dt > sls_ship_dt > sls_due_date 
 select nullif(sls_ship_dt,0) sls_ship_dt 
 from bronze.crm_sales_details
 where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt or sls_ship_dt > sls_due_dt

 -- check Data consistency: between sales, quantity, and price 
 --->> sales = quantity * price 
 -- >> Values must not be null, zero, or negative 
 
select  distinct 
sls_sales,
sls_quantity,
sls_price 
from silver.crm_sales_details
where sls_sales <> sls_quantity * sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null 
or sls_sales < 0 or sls_quantity < 0 or sls_price < 0 
order by sls_sales , sls_quantity , sls_price
