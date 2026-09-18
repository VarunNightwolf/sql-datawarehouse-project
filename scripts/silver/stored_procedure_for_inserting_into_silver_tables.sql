create or alter procedure  silver.load_silver as 
begin
BEGIN TRY
DECLARE  @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
SET @batch_start_time = GETDATE();

	Print '=================================================';
		Print '              Loading Silver Layer               ';
		Print '=================================================';

        	Print '-------------------------------------------------';
		Print '                Loading CRM TABLES               ';
		Print '-------------------------------------------------';

PRINT'------------------------------------------------';
SET @start_time = GETDATE();
PRINT'>> Truncating Data Into: silver.crm_cust_info';
Truncate table silver.crm_cust_info;
PRINT'>> Inserting Data Into: silver.crm_cust_info';
Insert into silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select cst_id, cst_key, trim(cst_firstname), trim(cst_lastname),  
case when upper(trim(cst_marital_status)) = 'M' then 'Married'
when upper(trim(cst_marital_status)) = 'S' then 'Single' else 'N/A' end as cst_marital_status,
case when upper(trim(cst_gndr))='M' then 'Male'
when upper(trim(cst_gndr)) = 'F' then 'Female' else 'N/A' End as cst_gndr, 
cst_create_date from(
select *, rank() over(partition by cst_id order by cst_create_date desc) as flag_last from bronze.crm_cust_info)t where cst_id is not null and flag_last = 1;
SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
PRINT'------------------------------------------------';
PRINT'>> Truncating Data Into: silver.crm_prd_info';

SET @start_time = GETDATE();
Truncate table silver.crm_prd_info;
PRINT'>> Inserting Data Into: silver.crm_prd_info';

insert into silver.crm_prd_info (prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)

SELECT  [prd_id],
       replace(substring(prd_key,1,5),'-','_') as cat_id,
       substring(prd_key,7,len(prd_key)) as prd_key
      ,[prd_nm]
      ,ISNULL(prd_cost,0) as prd_cost,
       case upper(trim(prd_line)) when 'M' then 'Mountain'
      when 'R' then 'Road'
      when 'S' then 'Other Sales'
      when 'T' then 'Touring'
      ELSE 'N/A' END as prd_line
      ,cast(prd_start_dt as date) as prd_start_dt
      ,cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt_test
      
  FROM [DataWareHouse].bronze.[crm_prd_info]
  SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
PRINT'------------------------------------------------';

  PRINT'------------------------------------------------';
  SET @start_time = GETDATE();
  PRINT'>> Truncating Data Into: silver.crm_sales_details';
  Truncate table silver.crm_sales_details;
PRINT'>> Inserting Data Into: silver.crm_sales_details';

insert into silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity, sls_price)

SELECT [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id],
      
      case  when sls_order_dt = 0 or len(sls_order_dt) !=8 Then Null
      else cast(cast(sls_order_dt as varchar) as date) end as sls_order_dt,
     
      case  when sls_ship_dt = 0 or len(sls_ship_dt) !=8 Then Null
      else cast(cast(sls_ship_dt as varchar) as date) end as sls_ship_dt,
      case  when sls_due_dt = 0 or len(sls_due_dt) !=8 Then Null
      else cast(cast(sls_due_dt as varchar) as date) end as sls_due_dt,
      case when sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
then sls_quantity * abs(sls_price)
else sls_sales end as sls_sales, sls_quantity,
case when sls_price<=0
then abs(sls_price)
when sls_price != sls_sales / sls_quantity then sls_sales / sls_quantity
else sls_price end as sls_price
  FROM [DataWareHouse].[bronze].[crm_sales_details]
  SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
	Print '-------------------------------------------------';
		Print '                Loading ERP TABLES               ';
		Print '-------------------------------------------------';
Print '';
PRINT'------------------------------------------------';
  PRINT'------------------------------------------------';
  SET @start_time = GETDATE();
  PRINT'>> Truncating Data Into: silver.erp_cust_az12';
Truncate table silver.erp_cust_az12;
PRINT'>> Inserting Data Into: silver.erp_cust_az12';
insert into silver.erp_cust_az12 (cid,bdate,gen)

SELECT  case when cid like 'NAS%' then substring(cid,4,len(cid))
else cid end as cid
      ,case when bdate > getdate() then NULL else bdate end as bdate
      ,case when upper(trim(gen)) in ('F','Female') then 'Female'
      when upper(trim(gen)) in ('M','Male') then 'Male'
      else 'N/A' end as gen
      
  FROM [DataWareHouse].bronze.[erp_cust_az12] 
    SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
PRINT'------------------------------------------------';
PRINT'>> Truncating Data Into: silver.erp_loc_a101';
 SET @start_time = GETDATE();
Truncate table silver.erp_loc_a101;
PRINT'>> Inserting Data Into: silver.erp_loc_a101';

insert into silver.erp_loc_a101 (cid,cntry)

select replace(cid,'-',''), 
case when trim(cntry) in ('US','Unites States','USA') then 'United States'
	when trim(cntry) = 'DE' then 'Germany'
	when trim(cntry) = '' or trim(cntry) IS NULL then 'N/A'
	else trim(cntry) end as cntry

from bronze.erp_loc_a101;
SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
PRINT'------------------------------------------------';
PRINT'------------------------------------------------';
SET @start_time = GETDATE();
PRINT'>> Truncating Data Into: silver.erp_px_cat_g1v2';
Truncate table silver.erp_px_cat_g1v2;
PRINT'>> Inserting Data Into: silver.erp_px_cat_g1v2';

insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)

select * from bronze.erp_px_cat_g1v2;
SET @end_time = GETDATE();
Print '<----------------  TIME DURATION  -------------->';
PRINT'>> Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
SET @batch_end_time = GETDATE();
PRINT'Loading Silver Layer is completed';
PRINT'>> Batch Load Duration: ' + cast(DATEDIFF(second,@batch_start_time,@batch_end_time) as nvarchar) + ' seconds';
Print '-------------------------------------------------';
Print '';
Print '';
END TRY
BEGIN CATCH
Print '-------------------------------------------------';
	Print 'Error occured during loading bronze layer'
	Print 'Error Message' + ERROR_MESSAGE();
	Print 'Error Message' + CAST(ERROR_NUMBER() as nvarchar); 
	Print 'Error Message' + CAST(ERROR_STATE() as nvarchar); 
	Print '-------------------------------------------------';
END CATCH
END
