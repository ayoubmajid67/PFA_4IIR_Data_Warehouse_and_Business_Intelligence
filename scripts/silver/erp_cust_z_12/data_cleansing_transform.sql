use DataWarehouse;

insert into silver.erp_cust_az12(cid,cus_id,bdate,gen)
SELECT 
    case when cid like 'NAS%' then SUBSTRING(cid,4,len(cid)) 
	else cid
	end cid, 
    SUBSTRING(cid, 9, LEN(cid)) AS cus_id, 
    case when bdate > GETDATE() then null 
	else bdate
	end bdate, 
    CASE 
        WHEN UPPER(gen) IN ('MALE', 'FEMALE') THEN gen
        WHEN UPPER(gen) = 'M' THEN 'Male'
        WHEN UPPER(gen) = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS gen
FROM bronze.erp_cust_az12
WHERE SUBSTRING(cid, 9, LEN(cid))  IN (
    SELECT CAST(cst_id AS NVARCHAR) FROM bronze.crm_cust_info
)  and bdate <'1924-01-01'  or bdate > GETDATE()

select * from silver.erp_cust_az12;
