USE retail_db;
GO

-- Create Stored Procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
  Begin TRY
	PRINT '=================================================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '=================================================================================';


	PRINT '=================================================================================';
	PRINT 'Loading ERP Tables';
	PRINT '=================================================================================';

	IF OBJECT_ID ('bronze.erp_hypermarket_products' , 'U') IS NOT NULL
		DROP TABLE bronze.erp_hypermarket_products;

	CREATE TABLE bronze.erp_hypermarket_products (
		Product_Code NVARCHAR(255),
		Product_Name NVARCHAR(500),
		Category NVARCHAR(255),
		Cost_Price NVARCHAR(100),
		Selling_Price NVARCHAR(100)
	);

	PRINT '>> Truncating table: bronze.erp_hypermarket_products'

	TRUNCATE TABLE bronze.erp_hypermarket_products;

	BULK INSERT bronze.erp_hypermarket_products
	FROM '/dataset/000.Hypermarket Products.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	IF OBJECT_ID ('bronze.erp_Alex_Inventory_Stock' , 'U') IS NOT NULL
		DROP TABLE bronze.erp_Alex_Inventory_Stock;

	CREATE TABLE bronze.erp_Alex_Inventory_Stock (
		Product_Code NVARCHAR(255),
		Product_Name NVARCHAR(500),
		Category NVARCHAR(255),
		Cost_Price NVARCHAR(100),
		Stock NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.erp_Alex_Inventory_Stock;

	BULK INSERT bronze.erp_Alex_Inventory_Stock
	FROM '/dataset/004.Alex Stock.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	IF OBJECT_ID ('bronze.erp_Cairo_Inventory_Stock' , 'U') IS NOT NULL
		DROP TABLE bronze.erp_Cairo_Inventory_Stock;

	CREATE TABLE bronze.erp_Cairo_Inventory_Stock (
		Product_Code NVARCHAR(255),
		Product_Name NVARCHAR(500),
		Category NVARCHAR(255),
		Cost_Price NVARCHAR(100),
		Stock NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.erp_Cairo_Inventory_Stock;

	BULK INSERT bronze.erp_Cairo_Inventory_Stock
	FROM '/dataset/005.Cairo Stock.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	IF OBJECT_ID ('bronze.erp_Giza_Inventory_Stock' , 'U') IS NOT NULL
		DROP TABLE bronze.erp_Giza_Inventory_Stock;

	CREATE TABLE bronze.erp_Giza_Inventory_Stock (
		Product_Code NVARCHAR(255),
		Product_Name NVARCHAR(500),
		Category NVARCHAR(255),
		Cost_Price NVARCHAR(100),
		Stock NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.erp_Giza_Inventory_Stock;

	BULK INSERT bronze.erp_Giza_Inventory_Stock
	FROM '/dataset/006.Giza Stock.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	PRINT '=================================================================================';
	PRINT 'Loading CRM Tables';
	PRINT '=================================================================================';

	IF OBJECT_ID ('bronze.crm_Alex_sales_transactions' , 'U') IS NOT NULL
		DROP TABLE bronze.crm_Alex_sales_transactions;

	CREATE TABLE bronze.crm_Alex_sales_transactions (
		Invoice_ID NVARCHAR(255),
		Branch NVARCHAR(100),
		City NVARCHAR(255),
		Customer_type NVARCHAR(100),
		Gender NVARCHAR(100),
		Product_line NVARCHAR(255),
		Unit_price NVARCHAR(100),
		Quantity NVARCHAR(100),
		Tax_5_Percent NVARCHAR(100),
		Sales NVARCHAR(100),
		[Date] NVARCHAR(100),
		[Time] NVARCHAR(100),
		Payment NVARCHAR(100),
		cogs NVARCHAR(100),
		gross_margin_percentage NVARCHAR(100),
		gross_income NVARCHAR(100),
		Rating NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.crm_Alex_sales_transactions;

	BULK INSERT bronze.crm_Alex_sales_transactions
	FROM '/dataset/001.Alex Branch Sales.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	IF OBJECT_ID ('bronze.crm_Cairo_sales_transactions' , 'U') IS NOT NULL
		DROP TABLE bronze.crm_Cairo_sales_transactions;

	CREATE TABLE bronze.crm_Cairo_sales_transactions (
		Invoice_ID NVARCHAR(255),
		Branch NVARCHAR(100),
		City NVARCHAR(255),
		Customer_type NVARCHAR(100),
		Gender NVARCHAR(100),
		Product_line NVARCHAR(255),
		Unit_price NVARCHAR(100),
		Quantity NVARCHAR(100),
		Tax_5_Percent NVARCHAR(100),
		Sales NVARCHAR(100),
		[Date] NVARCHAR(100),
		[Time] NVARCHAR(100),
		Payment NVARCHAR(100),
		cogs NVARCHAR(100),
		gross_margin_percentage NVARCHAR(100),
		gross_income NVARCHAR(100),
		Rating NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.crm_Cairo_sales_transactions;

	BULK INSERT bronze.crm_Cairo_sales_transactions
	FROM '/dataset/002.Cairo Branch Sales.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);

	IF OBJECT_ID ('bronze.crm_Giza_sales_transactions' , 'U') IS NOT NULL
		DROP TABLE bronze.crm_Giza_sales_transactions;

	CREATE TABLE bronze.crm_Giza_sales_transactions (
		Invoice_ID NVARCHAR(255),
		Branch NVARCHAR(100),
		City NVARCHAR(255),
		Customer_type NVARCHAR(100),
		Gender NVARCHAR(100),
		Product_line NVARCHAR(255),
		Unit_price NVARCHAR(100),
		Quantity NVARCHAR(100),
		Tax_5_Percent NVARCHAR(100),
		Sales NVARCHAR(100),
		[Date] NVARCHAR(100),
		[Time] NVARCHAR(100),
		Payment NVARCHAR(100),
		cogs NVARCHAR(100),
		gross_margin_percentage NVARCHAR(100),
		gross_income NVARCHAR(100),
		Rating NVARCHAR(100)
	);

	TRUNCATE TABLE bronze.crm_Giza_sales_transactions;

	BULK INSERT bronze.crm_Giza_sales_transactions
	FROM '/dataset/003.Giza Branch Sales.csv'
	WITH (
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		TABLOCK
	);
  END TRY
  BEGIN CATCH
	PRINT '=================================================================================';
	PRINT 'ERROR ACCURED DURING LOADING BRONZE LAYER';
	PRINT 'ERROR MESSAGE' + CAST (ERROR_MESSAGE() AS NVARCHAR);
	PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR MESSAGE' + CAST (ERROR_STATE() AS NVARCHAR);
	PRINT '=================================================================================';
  END CATCH

END;
GO -- End Procedure

EXEC bronze.load_bronze;