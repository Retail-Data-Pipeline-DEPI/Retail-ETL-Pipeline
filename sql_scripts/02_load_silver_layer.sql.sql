/*
=================================================================================
Script Name: Load Silver Layer
Description: This stored procedure performs the Extract, Transform, Load (ETL) 
             from the Bronze layer to the Silver layer. 
             It applies data cleansing (e.g., TRIM) and casts raw NVARCHAR 
             data into proper SQL data types (DECIMAL, DATE, TIME) for analysis.
=================================================================================
*/

USE retail_db;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
    BEGIN TRY
        PRINT '=================================================================================';
        PRINT 'Starting Pipeline: Loading Silver Layer (Cleansing & Transformation)';
        PRINT '=================================================================================';

        ---------------------------------------------------------------------------
        -- Section 1: ERP Tables (Enterprise Resource Planning)
        ---------------------------------------------------------------------------
        PRINT '=================================================================================';
        PRINT 'Loading and Transforming ERP Tables...';
        PRINT '=================================================================================';

        -- 1.1 Transform & Load Hypermarket Products
        IF OBJECT_ID ('silver.erp_hypermarket_products' , 'U') IS NOT NULL
            DROP TABLE silver.erp_hypermarket_products;

        -- Creating table with STRICT data types
        CREATE TABLE silver.erp_hypermarket_products (
            Product_Code NVARCHAR(50),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(100),
            Cost_Price DECIMAL(10,2),
            Selling_Price DECIMAL(10,2)
        );

        PRINT '>> Inserting transformed data into: silver.erp_hypermarket_products';
        -- Reading from BRONZE, casting, and inserting into SILVER
        INSERT INTO silver.erp_hypermarket_products (
            Product_Code, Product_Name, Category, Cost_Price, Selling_Price
        )
        SELECT 
            TRIM(Product_Code), 
            TRIM(Product_Name), 
            TRIM(Category), 
            CAST(Cost_Price AS DECIMAL(10,2)), 
            CAST(Selling_Price AS DECIMAL(10,2))
        FROM bronze.erp_hypermarket_products;

        -- 1.2 Transform & Load Alex Inventory Stock
        IF OBJECT_ID ('silver.erp_Alex_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE silver.erp_Alex_Inventory_Stock;

        CREATE TABLE silver.erp_Alex_Inventory_Stock (
            Product_Code NVARCHAR(50),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(100),
            Cost_Price DECIMAL(10,2),
            Stock INT
        );

        PRINT '>> Inserting transformed data into: silver.erp_Alex_Inventory_Stock';
        INSERT INTO silver.erp_Alex_Inventory_Stock
        SELECT 
            TRIM(Product_Code), 
            TRIM(Product_Name), 
            TRIM(Category), 
            CAST(Cost_Price AS DECIMAL(10,2)), 
            CAST(Stock AS INT)
        FROM bronze.erp_Alex_Inventory_Stock;

        -- 1.3 Transform & Load Cairo Inventory Stock
        IF OBJECT_ID ('silver.erp_Cairo_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE silver.erp_Cairo_Inventory_Stock;

        CREATE TABLE silver.erp_Cairo_Inventory_Stock (
            Product_Code NVARCHAR(50),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(100),
            Cost_Price DECIMAL(10,2),
            Stock INT
        );

        PRINT '>> Inserting transformed data into: silver.erp_Cairo_Inventory_Stock';
        INSERT INTO silver.erp_Cairo_Inventory_Stock
        SELECT 
            TRIM(Product_Code), 
            TRIM(Product_Name), 
            TRIM(Category), 
            CAST(Cost_Price AS DECIMAL(10,2)), 
            CAST(Stock AS INT)
        FROM bronze.erp_Cairo_Inventory_Stock;

        -- 1.4 Transform & Load Giza Inventory Stock
        IF OBJECT_ID ('silver.erp_Giza_Inventory_Stock' , 'U') IS NOT NULL
            DROP TABLE silver.erp_Giza_Inventory_Stock;

        CREATE TABLE silver.erp_Giza_Inventory_Stock (
            Product_Code NVARCHAR(50),
            Product_Name NVARCHAR(500),
            Category NVARCHAR(100),
            Cost_Price DECIMAL(10,2),
            Stock INT
        );

        PRINT '>> Inserting transformed data into: silver.erp_Giza_Inventory_Stock';
        INSERT INTO silver.erp_Giza_Inventory_Stock
        SELECT 
            TRIM(Product_Code), 
            TRIM(Product_Name), 
            TRIM(Category), 
            CAST(Cost_Price AS DECIMAL(10,2)), 
            CAST(Stock AS INT)
        FROM bronze.erp_Giza_Inventory_Stock;

        ---------------------------------------------------------------------------
        -- Section 2: CRM Tables (Customer Relationship Management)
        ---------------------------------------------------------------------------
        PRINT '=================================================================================';
        PRINT 'Loading and Transforming CRM Tables...';
        PRINT '=================================================================================';

        -- 2.1 Transform & Load Alex Sales Transactions
        IF OBJECT_ID ('silver.crm_Alex_sales_transactions' , 'U') IS NOT NULL
            DROP TABLE silver.crm_Alex_sales_transactions;

        CREATE TABLE silver.crm_Alex_sales_transactions (
            Invoice_ID NVARCHAR(50),
            Branch NVARCHAR(50),
            City NVARCHAR(50),
            Customer_type NVARCHAR(50),
            Gender NVARCHAR(50),
            Product_line NVARCHAR(100),
            Unit_price DECIMAL(10,2),
            Quantity INT,
            Tax_5_Percent DECIMAL(10,4),
            Sales DECIMAL(10,2),
            [Date] DATE,
            [Time] TIME,
            Payment NVARCHAR(50),
            cogs DECIMAL(10,2),
            gross_margin_percentage DECIMAL(10,4),
            gross_income DECIMAL(10,2),
            Rating DECIMAL(3,1)
        );

        PRINT '>> Inserting transformed data into: silver.crm_Alex_sales_transactions';
        INSERT INTO silver.crm_Alex_sales_transactions
        SELECT 
            TRIM(Invoice_ID),
            TRIM(Branch),
            TRIM(City),
            TRIM(Customer_type),
            TRIM(Gender),
            TRIM(Product_line),
            CAST(Unit_price AS DECIMAL(10,2)),
            CAST(Quantity AS INT),
            CAST(Tax_5_Percent AS DECIMAL(10,4)),
            CAST(Sales AS DECIMAL(10,2)),
            CAST([Date] AS DATE),
            CAST([Time] AS TIME),
            TRIM(Payment),
            CAST(cogs AS DECIMAL(10,2)),
            CAST(gross_margin_percentage AS DECIMAL(10,4)),
            CAST(gross_income AS DECIMAL(10,2)),
            CAST(Rating AS DECIMAL(3,1))
        FROM bronze.crm_Alex_sales_transactions;

        -- 2.2 Transform & Load Cairo Sales Transactions
        IF OBJECT_ID ('silver.crm_Cairo_sales_transactions' , 'U') IS NOT NULL
            DROP TABLE silver.crm_Cairo_sales_transactions;

        CREATE TABLE silver.crm_Cairo_sales_transactions (
            Invoice_ID NVARCHAR(50),
            Branch NVARCHAR(50),
            City NVARCHAR(50),
            Customer_type NVARCHAR(50),
            Gender NVARCHAR(50),
            Product_line NVARCHAR(100),
            Unit_price DECIMAL(10,2),
            Quantity INT,
            Tax_5_Percent DECIMAL(10,4),
            Sales DECIMAL(10,2),
            [Date] DATE,
            [Time] TIME,
            Payment NVARCHAR(50),
            cogs DECIMAL(10,2),
            gross_margin_percentage DECIMAL(10,4),
            gross_income DECIMAL(10,2),
            Rating DECIMAL(3,1)
        );

        PRINT '>> Inserting transformed data into: silver.crm_Cairo_sales_transactions';
        INSERT INTO silver.crm_Cairo_sales_transactions
        SELECT 
            TRIM(Invoice_ID), TRIM(Branch), TRIM(City), TRIM(Customer_type), TRIM(Gender), TRIM(Product_line),
            CAST(Unit_price AS DECIMAL(10,2)), CAST(Quantity AS INT), CAST(Tax_5_Percent AS DECIMAL(10,4)),
            CAST(Sales AS DECIMAL(10,2)), CAST([Date] AS DATE), CAST([Time] AS TIME), TRIM(Payment),
            CAST(cogs AS DECIMAL(10,2)), CAST(gross_margin_percentage AS DECIMAL(10,4)),
            CAST(gross_income AS DECIMAL(10,2)), CAST(Rating AS DECIMAL(3,1))
        FROM bronze.crm_Cairo_sales_transactions;

        -- 2.3 Transform & Load Giza Sales Transactions
        IF OBJECT_ID ('silver.crm_Giza_sales_transactions' , 'U') IS NOT NULL
            DROP TABLE silver.crm_Giza_sales_transactions;

        CREATE TABLE silver.crm_Giza_sales_transactions (
            Invoice_ID NVARCHAR(50),
            Branch NVARCHAR(50),
            City NVARCHAR(50),
            Customer_type NVARCHAR(50),
            Gender NVARCHAR(50),
            Product_line NVARCHAR(100),
            Unit_price DECIMAL(10,2),
            Quantity INT,
            Tax_5_Percent DECIMAL(10,4),
            Sales DECIMAL(10,2),
            [Date] DATE,
            [Time] TIME,
            Payment NVARCHAR(50),
            cogs DECIMAL(10,2),
            gross_margin_percentage DECIMAL(10,4),
            gross_income DECIMAL(10,2),
            Rating DECIMAL(3,1)
        );

        PRINT '>> Inserting transformed data into: silver.crm_Giza_sales_transactions';
        INSERT INTO silver.crm_Giza_sales_transactions
        SELECT 
            TRIM(Invoice_ID), TRIM(Branch), TRIM(City), TRIM(Customer_type), TRIM(Gender), TRIM(Product_line),
            CAST(Unit_price AS DECIMAL(10,2)), CAST(Quantity AS INT), CAST(Tax_5_Percent AS DECIMAL(10,4)),
            CAST(Sales AS DECIMAL(10,2)), CAST([Date] AS DATE), CAST([Time] AS TIME), TRIM(Payment),
            CAST(cogs AS DECIMAL(10,2)), CAST(gross_margin_percentage AS DECIMAL(10,4)),
            CAST(gross_income AS DECIMAL(10,2)), CAST(Rating AS DECIMAL(3,1))
        FROM bronze.crm_Giza_sales_transactions;

        PRINT '=================================================================================';
        PRINT 'Silver Layer Loaded Successfully!';
        PRINT '=================================================================================';

    END TRY
    
    ---------------------------------------------------------------------------
    -- Error Handling Section
    ---------------------------------------------------------------------------
    BEGIN CATCH
        PRINT '=================================================================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + CAST(ERROR_MESSAGE() AS NVARCHAR(4000));
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
        PRINT '=================================================================================';
    END CATCH
END;
GO 

-- Execute the Stored Procedure
EXEC silver.load_silver;