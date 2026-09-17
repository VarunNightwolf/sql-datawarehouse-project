use master;

--DROP and RECREATE the 'DataWareHouse' database

IF EXISTS(SELECT 1 from sys.databases where name = 'DataWareHouse')
BEGIN
	ALTER DATABASE DataWareHouse SET SINGLE_UESR WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWareHouse;
END;

-- CREATE the 'DateWareHouse' database
create database DataWareHouse;

use DataWarehouse;

-- CREATE SCHEMAS
create schema bronze;
create schema silver;
create schema gold;
