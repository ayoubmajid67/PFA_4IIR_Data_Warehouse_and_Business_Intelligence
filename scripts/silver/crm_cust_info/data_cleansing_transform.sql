/*
✅ ROW_NUMBER() OVER (...) AS flag_last
This generates a row number for each row within a group of rows defined by PARTITION BY, ordered by some column.

PARTITION BY cst_id:
Groups the data by the cst_id field. In this case, all rows with the same cst_id are grouped together (only one value here because of the WHERE clause).

ORDER BY cst_create_date DESC:
Within each group (each cst_id), rows are ordered by the cst_create_date in descending order — meaning the most recent date comes first.

ROW_NUMBER():
Assigns a sequential number starting from 1 to each row within the partition.

AS flag_last:
Names this computed column flag_last.
*/

-- retrieve  the most recent record for each customer 
select * from (select * , ROW_NUMBER() over (Partition by cst_id order by cst_create_date desc ) as flag_last  from bronze.crm_cust_info  ) t
where flag_last =1 ;


--  unique_cst_id  && remove unwanted spaces 
select * from bronze.crm_cust_info;
select  cst_id, cst_key, trim(cst_firstname) as cst_firstname , trim(cst_lastname) as cst_lastname,
cst_marital_status, cst_gndr, cst_create_date
from 
(
	select * from (select * , ROW_NUMBER() over (Partition by cst_id order by cst_create_date desc ) as flag_last  from bronze.crm_cust_info  ) t
	where cst_id is not null
) t where flag_last =1;


-- Map thee values of the cst_gndr to be frendly : 
select * from bronze.crm_cust_info;
select  cst_id, cst_key, trim(cst_firstname) as cst_firstname , trim(cst_lastname) as cst_lastname,
cst_marital_status,  
 case when  UPPER (trim(cst_gndr))  ='F' then 'Female'
 when upper(trim(cst_gndr))='M' then 'Male'
 else 'n/a'
 end cst_gndr

, cst_create_date
from 
(
	select * from (select * , ROW_NUMBER() over (Partition by cst_id order by cst_create_date desc ) as flag_last  from bronze.crm_cust_info  ) t
	where cst_id is not null
) t where flag_last =1;



--  Map thee values of the cst_marital_status to be frendly : 
select * from bronze.crm_cust_info;
select  cst_id, cst_key, trim(cst_firstname) as cst_firstname , trim(cst_lastname) as cst_lastname,
case when  UPPER (trim(cst_marital_status))  ='S' then 'Singlee'
 when upper(trim(cst_marital_status))='M' then 'Married'
 else 'n/a'
 end cst_marital_status
,  
 case when  UPPER (trim(cst_gndr))  ='F' then 'Female'
 when upper(trim(cst_gndr))='M' then 'Male'
 else 'n/a'
 end cst_gndr

, cst_create_date
from 
(
	select * from (select * , ROW_NUMBER() over (Partition by cst_id order by cst_create_date desc ) as flag_last  from bronze.crm_cust_info  ) t
	where cst_id is not null
) t where flag_last =1;



-- insert result to the silver.crm_cust_info :
INSERT INTO silver.crm_cust_info (
    cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
)
SELECT  
    cst_id, 
    cst_key, 
    TRIM(cst_firstname) AS cst_firstname, 
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Singlee'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT * 
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
    ) t
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;


select * from silver.crm_cust_info; 

