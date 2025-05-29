-- View all inserted records in the Silver table
SELECT * FROM silver.erp_cust_az12;

-- Verify if any future birthdates exist (they shouldn't)
SELECT * 
FROM silver.erp_cust_az12 
WHERE bdate > GETDATE();

-- Ensure no records with very old birthdates exist
SELECT * 
FROM silver.erp_cust_az12 
WHERE bdate < '1924-01-01';


-- List any rows where gender is not properly normalized
SELECT * 
FROM silver.erp_cust_az12 
WHERE gen NOT IN ('Male', 'Female', 'N/A');


-- Look for remaining 'NAS' prefixes in cid (should be cleaned)
SELECT * 
FROM silver.erp_cust_az12 
WHERE cid LIKE 'NAS%';

-- Group and count records by normalized gender
SELECT gen, COUNT(*) AS gender_count
FROM silver.erp_cust_az12
GROUP BY gen;
