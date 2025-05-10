select * from bronze.crm_cust_info;

-- check duplicate cust_id : 
select cst_id , count(*)  from bronze.crm_cust_info
group by cst_id 
having count(*) > 1 or cst_id is null ;
-- example : 
select * from bronze.crm_cust_info
where cst_id= 29449;

-- check  retrieve but  the most recent record for each customer 
select * from (select * , ROW_NUMBER() over (Partition by cst_id order by cst_create_date desc ) as flag_last  from bronze.crm_cust_info  ) t
where flag_last !=1 ;


-- check for unwanted spaces : 
select cst_firstname , len(cst_firstname) as cst_firstname_length ,LTRIM(RTRIM(cst_firstname)) AS cst_clean_firstname,len(LTRIM(RTRIM(cst_firstname))) as cst_firstname_length 
from bronze.crm_cust_info
where len(cst_firstname) >  len(LTRIM(RTRIM(cst_firstname))); 


-- check Data Standardization & Consistency : 
select distinct cst_gndr from bronze.crm_cust_info