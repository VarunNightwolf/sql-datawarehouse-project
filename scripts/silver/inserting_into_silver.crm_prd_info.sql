-- Check for Nulls or Duplicates in Primary Key
-- Check for unwanted spaces
-- End date should be after start date
-- Check for null in prd_cost
-- Standardizing data for prd_line 
-- Expectation: No Result

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
