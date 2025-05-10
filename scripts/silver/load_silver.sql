create or alter procedure silver.load_silver as 
begin 

declare @start_time datetime , @end_time datetime , @batch_start_time datetime, @batch_end_time datetime; 
 begin try 
 set @batch_start_time = GETDATE();
 print '===================';
 print 'Loading silver Layer';
 print '===================';

 print '==================';
 print 'Loading CRM Tables';
 print '==================';



 set @start_time =GETDATE();
 print '> Truncating Table : silver.crm_cust_info';
 truncate table silver.crm_cust_info;

 bulk insert silver.crm_cust_info from 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_crm\cust_info.csv'
	with (
	firstrow =2,
	fieldterminator=',',
	tablock 
	);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '>> Inserting Data Into: silver.crm_prd_info';
		BULK INSERT silver.crm_prd_info
		FROM 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';
		BULK INSERT silver.crm_sales_details
		FROM 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',


			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		BULK INSERT silver.erp_loc_a101
		FROM 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';
		BULK INSERT silver.erp_cust_az12
		FROM 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
		BULK INSERT silver.erp_px_cat_g1v2
		FROM 'C:\vs code\GitHub\sql-data-warehouse-project-Baraa\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds' ;
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'  + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING silver LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END;