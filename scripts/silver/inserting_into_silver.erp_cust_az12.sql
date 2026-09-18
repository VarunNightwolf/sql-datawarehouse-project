-- Strippipng NAS from CID for foreign key relationship
-- Standardizing GEN values
-- Removing future dates from bdate

insert into silver.erp_cust_az12 (cid,bdate,gen)

SELECT  case when cid like 'NAS%' then substring(cid,4,len(cid))
else cid end as cid
      ,case when bdate > getdate() then NULL else bdate end as bdate
      ,case when upper(trim(gen)) in ('F','Female') then 'Female'
      when upper(trim(gen)) in ('M','Male') then 'Male'
      else 'N/A' end as gen
      
  FROM [DataWareHouse].bronze.[erp_cust_az12] 
