create or alter procedure bronze.load_bronze as 
begin
	DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		SET DATEFORMAT dmy;
		SET @batch_start_time=GETDATE();
		Print '=================================================';
		Print '              Loading Bronze Layer               ';
		Print '=================================================';


		Print '-------------------------------------------------';
		Print '                Loading CRM TABLES               ';
		Print '-------------------------------------------------';

		
		Print '>> Truncating Table: bronze.crm_cust_info';
		SET @start_time = GETDATE();
		truncate table bronze.crm_cust_info;

		Print '>> Inserting Data into: bronze.crm_cust_info'
		bulk insert bronze.crm_cust_info 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		Print '<----------------  TIME DURATION  -------------->';
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '-------------------------------------------------';
		Print '';
		Print '';
		SET @start_time = GETDATE();
		Print '>> Truncating Table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		Print '>> Inserting Data into: bronze.crm_prd_info'
		bulk insert bronze.crm_prd_info 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		Print '<----------------  TIME DURATION  -------------->';
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '-------------------------------------------------';
		Print '';
		Print '';
		SET @start_time = GETDATE();
		Print '>> Truncating Table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		Print '>> Inserting Data into: bronze.crm_sales_details'
		bulk insert bronze.crm_sales_details 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		Print '<----------------  TIME DURATION  -------------->';
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '';
		Print '';
		Print '-------------------------------------------------';
		Print '                Loading ERP TABLES               ';
		Print '-------------------------------------------------';
		Print '';
		Print '';
		SET @start_time = GETDATE();
		Print '>> Truncating Table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		Print '>> Inserting Data into: bronze.erp_cust_az12'
		bulk insert bronze.erp_cust_az12 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		Print '<----------------  TIME DURATION  -------------->';
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '';
		Print '';
		SET @start_time = GETDATE();
		Print '-------------------------------------------------';
		Print '>> Truncating Table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		Print '>> Inserting Data into: bronze.erp_loc_a101'
		bulk insert bronze.erp_loc_a101 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		Print '<----------------  TIME DURATION  -------------->';
		SET @end_time= GETDATE();
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '';
		Print '';
		SET @start_time = GETDATE();
		Print '-------------------------------------------------';
		Print '>> Truncating Table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		Print '>> Inserting Data into: bronze.erp_px_cat_g1v2'
		bulk insert bronze.erp_px_cat_g1v2 
		from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv' 
		with (firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		SET @end_time= GETDATE();
		Print '<----------------  TIME DURATION  -------------->';
		PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
		Print '';
		
	SET @batch_end_time=GETDATE();
	Print '-------------------------------------------------';
	Print '';
	Print '';
	Print '';
	Print '<-------- Loading Bronze Layer Complete  -------->'
	Print '<-------------- BATCH TIME DURATION  ------------>';
	Print 'Total time taken for batch loading: ' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + ' seconds';
	Print '-------------------------------------------------';
	
	end try
	
	begin catch
	Print '-------------------------------------------------';
	Print 'Error occured during loading bronze layer'
	Print 'Error Message' + ERROR_MESSAGE();
	Print 'Error Message' + CAST(ERROR_NUMBER() as nvarchar); 
	Print 'Error Message' + CAST(ERROR_STATE() as nvarchar); 
	Print '-------------------------------------------------';
	end catch
END
