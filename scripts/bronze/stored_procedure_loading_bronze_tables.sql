create or alter procedure bronze.load_bronze as 
begin


	SET DATEFORMAT dmy;
	
	Print '=================================================';
	Print 'Loading Bronze Layer';
	Print '=================================================';


	Print '-------------------------------------------------';
	Print 'Loading CRM TABLES';
	Print '-------------------------------------------------';

	Print '>> Truncating Table: bronze.crm_cust_info';
	
	truncate table bronze.crm_cust_info;

	Print '>> Inserting Data into: bronze.crm_cust_info'
	bulk insert bronze.crm_cust_info 
	from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' 
	with (firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	Print '-------------------------------------------------';
	Print '>> Truncating Table: bronze.crm_prd_info';
	truncate table bronze.crm_prd_info;
	Print '>> Inserting Data into: bronze.crm_prd_info'
	bulk insert bronze.crm_prd_info 
	from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
	with (firstrow = 2,
		fieldterminator = ',',
		tablock
	);
	Print '-------------------------------------------------';
	Print '>> Truncating Table: bronze.crm_sales_details';
	truncate table bronze.crm_sales_details;
	Print '>> Inserting Data into: bronze.crm_sales_details'
	bulk insert bronze.crm_sales_details 
	from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
	with (firstrow = 2,
		fieldterminator = ',',
		tablock
	);


	Print '-------------------------------------------------';
	Print 'Loading ERP TABLES';
	Print '-------------------------------------------------';

	Print '>> Truncating Table: bronze.erp_cust_az12';
	truncate table bronze.erp_cust_az12;
	Print '>> Inserting Data into: bronze.erp_cust_az12'
	bulk insert bronze.erp_cust_az12 
	from 'C:\Users\mesme\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv' 
	with (firstrow = 2,
		fieldterminator = ',',
		tablock
	);
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
END
