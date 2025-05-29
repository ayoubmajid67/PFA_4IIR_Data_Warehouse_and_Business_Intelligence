SELECT TOP (1000) [prd_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWarehouse].[bronze].[crm_prd_info]

--  data enrichement (adding the category id filed) it allows use to join with the erp_px_cat_g1v2 table : 
-- REPLACE(string_expression, string_pattern, string_replacement)
select prd_id,prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info; 

select distinct id from bronze.erp_px_cat_g1v2;

-- remove the cat_id not found in the bronze.erp_px_cat_g1v2 : 
select prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,

prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info 
where  REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2);

 -- remove the prd_key not found in the bronze.crm_sales_details :
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
and   SUBSTRING(prd_key,7,len(prd_key)) in (select distinct sls_prd_key from bronze.crm_sales_details)
;

 -- remove nulls and negative values for the prd_cost
 select prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
case 
when prd_cost < 0 then 0
else ISNULL(prd_cost,0) 
end prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info 
where   REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2)
and   SUBSTRING(prd_key,7,len(prd_key)) in (select distinct sls_prd_key from bronze.crm_sales_details)
;

-- data standardization & consistency : 
select distinct prd_line 
from bronze.crm_prd_info; 

-- map prd_line values to be more frendly : 
 select prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
case 
when prd_cost < 0 then 0
else ISNULL(prd_cost,0) 
end  prd_cost,
case  upper(trim(prd_line)) 
when 'M' then 'Moutain'
when  'R' then 'Road'
when 'S' then 'others Sales'
when  'T' then 'Touring'
else 'n/a'
end  prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info 
where   REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2)
and   SUBSTRING(prd_key,7,len(prd_key)) in (select distinct sls_prd_key from bronze.crm_sales_details)

-- map prd_start-dt & prd_end_dt: 
/*
### 🎯 **What does `LEAD()` do?**

It **looks ahead** to the next row's value **in the same group** (defined by `PARTITION BY`), and helps you compare or calculate with it.

---

### 🧠 Think of it like this:

Imagine you have a **timeline of promotions** for a product. You know when each promotion **starts**, but not exactly when it **ends**. However, if the **next promotion** starts on a certain date, then this promotion should **end the day before**.

---

### 🔢 **Example Data:**

Let's say you have this:

| prd\_key | prd\_start\_dt |
| -------- | -------------- |
| A001     | 2024-01-01     |
| A001     | 2024-03-01     |
| A001     | 2024-06-01     |

You want to **find the end date of each product period**.

---

### ✅ What `LEAD(prd_start_dt)` does:

It shifts the `prd_start_dt` **up one row**:

| prd\_key | prd\_start\_dt | next\_start\_dt (LEAD) |
| -------- | -------------- | ---------------------- |
| A001     | 2024-01-01     | 2024-03-01             |
| A001     | 2024-03-01     | 2024-06-01             |
| A001     | 2024-06-01     | NULL                   |

Now subtract 1 day from `next_start_dt`:

| prd\_key | prd\_start\_dt | prd\_end\_dt |
| -------- | -------------- | ------------ |
| A001     | 2024-01-01     | 2024-02-29   |
| A001     | 2024-03-01     | 2024-05-31   |
| A001     | 2024-06-01     | NULL         |

---

### 🔧 SQL:

```sql
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)
```

This means:
→ For each `prd_key`, look at the next `prd_start_dt`, ordered by date.

Then subtract 1 day to get the **end date** of the current product.

---

*/
 select prd_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id,
prd_nm,
case 
when prd_cost < 0 then 0
else ISNULL(prd_cost,0) 
end  prd_cost,
case  upper(trim(prd_line)) 
when 'M' then 'Moutain'
when  'R' then 'Road'
when 'S' then 'others Sales'
when  'T' then 'Touring'
else 'n/a'
end  prd_line,
cast( prd_start_dt as date) as prd_start_dt,
cast ((LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 ) as date)  as prd_end_dt
from bronze.crm_prd_info 
where   REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2)
and   SUBSTRING(prd_key,7,len(prd_key)) in (select distinct sls_prd_key from bronze.crm_sales_details)


-- insert query the result to the  silver.crm_prd_info:
insert into silver.crm_prd_info (
prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt
)
 select prd_id,
 REPLACE(SUBSTRING(prd_key,1,5),'-','_')  as cat_id, -- derived columns 
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,

prd_nm,
case 
when prd_cost < 0 then 0
else ISNULL(prd_cost,0) 
end  prd_cost,
case  upper(trim(prd_line))  -- normalization 
when 'M' then 'Moutain'
when  'R' then 'Road'
when 'S' then 'others Sales'
when  'T' then 'Touring'
else 'n/a'
end  prd_line,
cast( prd_start_dt as date) as prd_start_dt, -- datatype casting 
cast ((LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 ) as date)  as prd_end_dt -- data enrichment 
from bronze.crm_prd_info 
where   REPLACE(SUBSTRING(prd_key,1,5),'-','_')  in (select distinct id from bronze.erp_px_cat_g1v2)
and   SUBSTRING(prd_key,7,len(prd_key))  in (select distinct sls_prd_key from bronze.crm_sales_details);


select SUBSTRING(prd_key,7,len(prd_key)) from  bronze.crm_prd_info;
select distinct sls_prd_key from bronze.crm_sales_details