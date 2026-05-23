/*
=================================================================================
Script Name: Load Silver Layer - CRM Sales Transactions
Description: This script consolidates raw sales data from multiple branches 
             (Alex, Cairo, Giza) into a single, cleansed table in the Silver layer.
             It applies advanced data quality checks, data type casting, 
             standardization, and deduplication.
=================================================================================
*/

USE retail_db;
GO

-- 1. Drop the table in the Silver layer if it already exists to ensure a clean load
IF OBJECT_ID('silver.crm_sales_transactions', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_transactions;
GO

-- 2. Create the target table structure with proper strict data types and constraints
CREATE TABLE silver.crm_sales_transactions (
    Invoice_ID               VARCHAR(50) NOT NULL,
    Branch                   VARCHAR(50),
    City                     VARCHAR(50),
    Customer_type            VARCHAR(50),
    Gender                   VARCHAR(20),
    Product_line             VARCHAR(100),
    Unit_price               DECIMAL(18,4),
    Quantity                 INT,
    Tax_5_Percent            DECIMAL(18,4), 
    Sales                    DECIMAL(18,4),
    [Date]                   DATE,
    [Time]                   TIME,
    Payment                  VARCHAR(50),
    cogs                     DECIMAL(18,4),
    gross_margin_percentage  DECIMAL(18,4),
    gross_income             DECIMAL(18,4),
    Rating                   DECIMAL(5,2),
    dwh_create_date          DATETIME DEFAULT GETDATE(), -- Audit column for tracking load time
    
    CONSTRAINT PK_silver_sales_transactions PRIMARY KEY (Invoice_ID) 
);
GO

-- 3. Consolidate, Cleanse, and Protect data using Common Table Expressions (CTEs)
WITH ConsolidatedSales AS (
    -- Combine data from all three branches into a single dataset
    SELECT Invoice_ID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax_5_Percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
    FROM retail_db.bronze.crm_Alex_sales_transactions
    UNION ALL
    SELECT Invoice_ID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax_5_Percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
    FROM retail_db.bronze.crm_Cairo_sales_transactions
    UNION ALL
    SELECT Invoice_ID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax_5_Percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
    FROM retail_db.bronze.crm_Giza_sales_transactions
),

DataQualityChecks AS (
    -- Apply data cleansing, standardization, and safe type casting
    SELECT 
        TRIM(Invoice_ID) AS Clean_Invoice_ID,
        TRIM(Branch) AS Clean_Branch,
        TRIM(City) AS Clean_City,
        TRIM(Customer_type) AS Clean_Customer_type,
        
        -- Standardize Gender values
        CASE 
            WHEN UPPER(TRIM(Gender)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(Gender)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END AS Clean_Gender,
        
        TRIM(Product_line) AS Clean_Product_line,
        
        -- The Magic: TRY_CAST prevents the pipeline from failing if text is found in numeric columns.
        -- It returns NULL for invalid casts, which ISNULL then converts to 0.
        ISNULL(TRY_CAST(Unit_price AS DECIMAL(18,4)), 0) AS Clean_Unit_price,
        ISNULL(TRY_CAST(Quantity AS INT), 0) AS Clean_Quantity,
        ISNULL(TRY_CAST(Tax_5_Percent AS DECIMAL(18,4)), 0) AS Clean_Tax_5_Percent,
        ISNULL(TRY_CAST(Sales AS DECIMAL(18,4)), 0) AS Clean_Sales,
        
        [Date], 
        [Time],
        TRIM(Payment) AS Clean_Payment,
        
        ISNULL(TRY_CAST(cogs AS DECIMAL(18,4)), 0) AS Clean_cogs,
        ISNULL(TRY_CAST(gross_margin_percentage AS DECIMAL(18,4)), 0) AS Clean_gross_margin_percentage,
        ISNULL(TRY_CAST(gross_income AS DECIMAL(18,4)), 0) AS Clean_gross_income,
        ISNULL(TRY_CAST(Rating AS DECIMAL(5,2)), 0) AS Clean_Rating,
        
        -- Generate a row number to identify duplicates based on Invoice_ID (keeping the latest one)
        ROW_NUMBER() OVER (PARTITION BY TRIM(Invoice_ID) ORDER BY [Date] DESC, [Time] DESC) AS flag_last
        
    FROM ConsolidatedSales
    -- Filter out NULL Invoice IDs and accidental header rows from CSV loads
    WHERE Invoice_ID IS NOT NULL AND Invoice_ID != 'Invoice_ID'
)

-- 4. Final Insert into the Silver table
INSERT INTO silver.crm_sales_transactions (
    Invoice_ID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax_5_percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
)
SELECT 
    Clean_Invoice_ID, Clean_Branch, Clean_City, Clean_Customer_type, Clean_Gender, Clean_Product_line, 
    Clean_Unit_price, Clean_Quantity, Clean_Tax_5_Percent, Clean_Sales, [Date], [Time], Clean_Payment, 
    Clean_cogs, Clean_gross_margin_percentage, Clean_gross_income, Clean_Rating
FROM DataQualityChecks
-- Insert only the most recent unique record (Deduplication)
WHERE flag_last = 1;
GO