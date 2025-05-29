-- convert dates =0 to null and converts from dates from int to date:
SELECT  sls_ord_num
      ,sls_prd_key
      ,sls_cust_id,
	  case when sls_order_dt=0 or len(sls_order_dt)!='8' then null 
	  else cast(CAST(sls_order_dt as varchar) as date)
	  end as sls_order_dt
      ,case when sls_ship_dt=0 or len(sls_ship_dt)!='8' then null 
	  else cast(CAST(sls_ship_dt as varchar) as date)
	  end as sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
  FROM bronze.crm_sales_details;

   -- Data consistency: between sales, quantity, and price 
 --->> sales = quantity * price 
 -- >> Values must not be null, zero, or negative 
 use DataWarehouse;
 insert into silver.crm_sales_details (
 sls_ord_num,
 sls_prd_key,
 sls_cust_id,
 sls_order_dt,
 sls_ship_dt,
 sls_due_dt,
 sls_sales,
 sls_quantity,
 sls_price
 )

select 
 sls_ord_num
      ,sls_prd_key
      ,sls_cust_id,
case when sls_order_dt=0 or len(sls_order_dt)!='8' then null 
	  else cast(CAST(sls_order_dt as varchar) as date)
	  end as sls_order_dt

      ,case when sls_ship_dt=0 or len(sls_ship_dt)!='8' then null 
	  else cast(CAST(sls_ship_dt as varchar) as date)
	  end as sls_ship_dt

      ,case when sls_due_dt=0 or len(sls_due_dt)!='8' then null 
	  else cast(CAST(sls_due_dt as varchar) as date)
	  end as sls_due_dt,
case 
when sls_sales is null or sls_sales <=0 or sls_sales!=sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
else sls_sales
end as sls_sales,

sls_quantity,
case when sls_price is null or sls_price < 0 then  sls_sales/nullif(sls_quantity,0) 
else sls_price
end as sls_price

from bronze.crm_sales_details
where sls_order_dt < sls_ship_dt and sls_ship_dt < sls_due_dt 

select* from silver.crm_sales_details;



