select * from silver.crm_sales_details;
select * from  gold.dim_customers; 

select * from gold.dim_products;



create  view gold.fact_sales AS
select 
row_number() over (order by sd.sls_order_dt) as sales_key,
sd.sls_ord_num as order_number,
dp.product_key as product_key,
dc.customer_key  ,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_customers  dc
on sd.sls_cust_id = dc.customer_id
left join gold.dim_products dp 
on sd.sls_prd_key = dp.product_number

select * from gold.fact_sales;

-- check the data intergration b between the fact_sales and the dim_products , dim_customers; 
select * from gold.fact_sales s
left join gold.dim_customers c
on s.customer_key= c.customer_key
left join gold.dim_products p
on s.product_key= p.product_key;

select * from gold.fact_sales s
left join gold.dim_customers c
on s.customer_key= c.customer_key
left join gold.dim_products p
on s.product_key= p.product_key
where p.product_key is null or  c.customer_key is null;

select * from gold.dim_products; 

