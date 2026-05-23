/*
=================================================================================
Script Name: Load Bronze Layer
Description: This stored procedure loads raw data from CSV files into the bronze 
             layer tables. It handles both ERP (Products/Inventory) and 
             CRM (Sales Transactions) sources.
             The process uses a Full Load pattern (Drop -> Create -> Truncate -> Insert).
=================================================================================
*/

USE retail_db;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    BEGIN TRY
        PRINT '=================================================================================';
        PRINT 'Starting Pipeline: Loading Bronze Layer';
        PRINT '=================================================================================';

        ---------------------------------------------------------------------------
        -- Section 1: ERP Tables (Enterprise Resource Planning)
        -- Loading Product Definitions and Inventory Stock across branches
        ---------------------------------------------------------------------------
        PRINT '=================================================================================';
        PRINT 'Loading ERP Tables...';
        PRINT '=================================================================================';

        -- 1.1 Load Hypermarket Products
        -- Drop table if it already exists to ensure a clean state
        IF OBJECT_ID ('bronze.erp_hypermarket_products' , 'U') IS NOT NULL
            DROP TABLE bronze.erp_hypermarket_products;

        -- Create table with NVARCHAR data types to prevent casting errors during raw load
        CREATE TABLE bronze.erp_hypermarket_products (
            Product_Code NVARCHAR(255),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(255),
            Cost_Price NVARCHAR(100),
            Selling_Price NVARCHAR(100)
        );

        PRINT '>> Truncating table: bronze.erp_hypermarket_products';
        TRUNCATE TABLE bronze.erp_hypermarket_products;

        -- Bulk insert data directly from the local Docker volume
        PRINT '>> Inserting data into: bronze.erp_hypermarket_products';
        BULK INSERT bronze.erp_hypermarket_products
        FROM '/dataset/000.Hypermarket Products.csv'
        WITH (
            FORMAT = 'CSV',
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FIRSTROW = 2,
            TABLOCK
        );

        -- 1.2 Load Alex Inventory Stock
        IF OBJECT_ID ('bronze.erp_Alex_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE bronze.erp_Alex_Inventory_Stock;

        CREATE TABLE bronze.erp_Alex_Inventory_Stock (
            Product_Code NVARCHAR(255),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(255),
            Cost_Price NVARCHAR(100),
            Stock NVARCHAR(100)
        );

        PRINT '>> Truncating and Inserting: bronze.erp_Alex_Inventory_Stock';
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

        -- 1.3 Load Cairo Inventory Stock
        IF OBJECT_ID ('bronze.erp_Cairo_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE bronze.erp_Cairo_Inventory_Stock;

        CREATE TABLE bronze.erp_Cairo_Inventory_Stock (
            Product_Code NVARCHAR(255),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(255),
            Cost_Price NVARCHAR(100),
            Stock NVARCHAR(100)
        );

        PRINT '>> Truncating and Inserting: bronze.erp_Cairo_Inventory_Stock';
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

        -- 1.4 Load Giza Inventory Stock
        IF OBJECT_ID ('bronze.erp_Giza_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE bronze.erp_Giza_Inventory_Stock;

        CREATE TABLE bronze.erp_Giza_Inventory_Stock (
            Product_Code NVARCHAR(255),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(255),
            Cost_Price NVARCHAR(100),
            Stock NVARCHAR(100)
        );

        PRINT '>> Truncating and Inserting: bronze.erp_Giza_Inventory_Stock';
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

        ---------------------------------------------------------------------------
        -- Section 2: CRM Tables (Customer Relationship Management)
        -- Loading Sales Transactions across branches
        ---------------------------------------------------------------------------
        PRINT '=================================================================================';
        PRINT 'Loading CRM Tables...';
        PRINT '=================================================================================';

        -- 2.1 Load Alex Sales Transactions
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

        PRINT '>> Truncating and Inserting: bronze.crm_Alex_sales_transactions';
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

        -- 2.2 Load Cairo Sales Transactions
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

        PRINT '>> Truncating and Inserting: bronze.crm_Cairo_sales_transactions';
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

        -- 2.3 Load Giza Sales Transactions
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

        PRINT '>> Truncating and Inserting: bronze.crm_Giza_sales_transactions';
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
        
        PRINT '=================================================================================';
        PRINT 'Bronze Layer Loaded Successfully!';
        PRINT '=================================================================================';

    END TRY
    
    ---------------------------------------------------------------------------
    -- Error Handling Section
    ---------------------------------------------------------------------------
    BEGIN CATCH
        PRINT '=================================================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
        PRINT '=================================================================================';
    END CATCH
END;
GO 

-- Execute the Stored Procedure
EXEC bronze.load_bron