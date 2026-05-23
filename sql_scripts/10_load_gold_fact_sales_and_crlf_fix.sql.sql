/*
=================================================================================
Script Name: Load Gold Layer - Fact: Sales Transactions (with CRLF Hotfix)
Description: This script finalizes the Star Schema data model.
             Part 1: Fixes the CRLF issue in the Silver sales table (Rating column).
             Part 2: Creates the Fact table in the Gold layer and populates it 
                     by joining the cleansed Silver sales data with the Gold 
                     dimension tables to fetch the appropriate Surrogate Keys.
=================================================================================
*/

USE retail_db;
GO

---------------------------------------------------------------------------
-- PART 1: Fix the CRLF (Hidden Characters) issue in the Silver Layer
---------------------------------------------------------------------------

-- 1.1 Drop the existing Silver table
IF OBJECT_ID('silver.crm_sales_transactions', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_transactions;
GO

-- 1.2 Recreate the Silver table structure
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
    dwh_create_date          DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT PK_silver_sales_transactions PRIMARY KEY (Invoice_ID) 
);
GO

-- 1.3 Consolidate and Cleanse Data (Applying the CRLF Fix)
WITH ConsolidatedSales AS (
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
    SELECT 
        TRIM(Invoice_ID) AS Clean_Invoice_ID,
        TRIM(Branch) AS Clean_Branch,
        TRIM(City) AS Clean_City,
        TRIM(Customer_type) AS Clean_Customer_type,
        CASE 
            WHEN UPPER(TRIM(Gender)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(Gender)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END AS Clean_Gender,
        TRIM(Product_line) AS Clean_Product_line,
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
        
        -- The Fix: Remove hidden Carriage Return (CR) and Line Feed (LF) from the last column (Rating)
        ISNULL(TRY_CAST(REPLACE(REPLACE(Rating, CHAR(13), ''), CHAR(10), '') AS DECIMAL(5,2)), 0) AS Clean_Rating,
        
        ROW_NUMBER() OVER (PARTITION BY TRIM(Invoice_ID) ORDER BY [Date] DESC, [Time] DESC) AS flag_last
    FROM ConsolidatedSales
    WHERE Invoice_ID IS NOT NULL AND Invoice_ID != 'Invoice_ID'
)

-- 1.4 Insert cleansed data into the Silver layer
INSERT INTO silver.crm_sales_transactions (
    Invoice_ID, Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax_5_percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
)
SELECT Clean_Invoice_ID, Clean_Branch, Clean_City, Clean_Customer_type, Clean_Gender, Clean_Product_line, Clean_Unit_price, Clean_Quantity, Clean_Tax_5_Percent, Clean_Sales, [Date], [Time], Clean_Payment, Clean_cogs, Clean_gross_margin_percentage, Clean_gross_income, Clean_Rating
FROM DataQualityChecks
WHERE flag_last = 1;
GO

---------------------------------------------------------------------------
-- PART 2: Build the Gold Fact Table (The Star Schema Core)
---------------------------------------------------------------------------

-- 2.1 Drop the existing Fact table
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

-- 2.2 Create the Fact table structure
CREATE TABLE gold.fact_sales (
    Invoice_ID               VARCHAR(50) NOT NULL,
    Branch_ID                INT,           -- Foreign Key to dim_branches
    Customer_ID              INT,           -- Foreign Key to dim_customers
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
    
    CONSTRAINT PK_gold_fact_sales PRIMARY KEY (Invoice_ID)
);
GO

-- 2.3 Populate the Fact table by mapping business keys to surrogate keys via JOINs
INSERT INTO gold.fact_sales (
    Invoice_ID, Branch_ID, Customer_ID, Product_line, Unit_price, Quantity, 
    Tax_5_percent, Sales, [Date], [Time], Payment, cogs, gross_margin_percentage, gross_income, Rating
)
SELECT 
    s.Invoice_ID,
    b.Branch_ID,      -- Fetched from dim_branches
    c.Customer_ID,    -- Fetched from dim_customers
    s.Product_line,
    s.Unit_price,
    s.Quantity,
    s.Tax_5_Percent,
    s.Sales,
    s.[Date],
    s.[Time],
    s.Payment,
    s.cogs,
    s.gross_margin_percentage,
    s.gross_income,
    s.Rating
FROM silver.crm_sales_transactions s
-- Join on Business Keys to retrieve the efficient Analytical Surrogate Keys
LEFT JOIN gold.dim_branches b ON s.Branch = b.Branch_Name
LEFT JOIN gold.dim_customers c ON s.Customer_type = c.Customer_type AND s.Gender = c.Gender;
GO

-- 2.4 Display the final result to verify the Fact table load
SELECT TOP 10 * FROM gold.fact_sales;
GO