-- Check for Nulls or Duplicates in Primary Key
-- Check for unwanted spaces
-- Standardizing values for cst_gndr and cst_marital_status
-- Expectation: No Result

Insert into silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select cst_id, cst_key, trim(cst_firstname), trim(cst_lastname),  
case when upper(trim(cst_marital_status)) = 'M' then 'Married'
when upper(trim(cst_marital_status)) = 'S' then 'Single' else 'N/A' end as cst_marital_status,
case when upper(trim(cst_gndr))='M' then 'Male'
when upper(trim(cst_gndr)) = 'F' then 'Female' else 'N/A' End as cst_gndr, 
cst_create_date from(
select *, rank() over(partition by cst_id order by cst_create_date desc) as flag_last from bronze.crm_cust_info)t where cst_id is not null and flag_last = 1;

