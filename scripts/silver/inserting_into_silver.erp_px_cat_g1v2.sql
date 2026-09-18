-- Check for null, empty spaces and abnormal values

insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)

select * from bronze.erp_px_cat_g1v2;
