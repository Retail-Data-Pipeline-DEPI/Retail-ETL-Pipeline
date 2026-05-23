/*
=================================================================================
Script Name: Load Silver Layer - ERP Hypermarket Products
Description: This script loads raw product data from the Bronze layer into the 
             Silver layer. It applies defensive programming techniques, 
             data type casting, whitespace trimming, and deduplication to 
             ensure a clean, reliable dimension table.
=================================================================================
*/

-- 1. Drop the table in the Silver layer if it already exists to ensure a clean load
IF OBJECT_ID('silver.erp_hypermarket_products', 'U') IS NOT NULL
    DROP TABLE silver.erp_hypermarket_products;
GO

-- 2. Create the target table structure with proper strict data types and constraints
CREATE TABLE silver.erp_hypermarket_products (
    Product_Code      VARCHAR(50) NOT NULL,
    Product_Name      VARCHAR(255),
    Category          VARCHAR(100),
    Cost_Price        DECIMAL(18,4),
    Selling_Price     DECIMAL(18,4),
    dwh_create_date   DATETIME DEFAULT GETDATE(), -- Audit column for tracking load time
    
    -- Primary key to enforce uniqueness at the database level
    CONSTRAINT PK_silver_products PRIMARY KEY (Product_Code)
);
GO

-- 3. Apply data cleansing and defensive programming using a CTE
WITH DataQualityChecks AS (
    SELECT 
        TRIM(Product_Code) AS Clean_Product_Code,
        TRIM(Product_Name) AS Clean_Product_Name,
        TRIM(Category) AS Clean_Category,
        
        -- Defensive programming: TRY_CAST prevents pipeline failure if text is found in price columns.
        -- Invalid casts return NULL, which are then converted to 0 by ISNULL.
        ISNULL(TRY_CAST(Cost_Price AS DECIMAL(18,4)), 0) AS Clean_Cost_Price,
        ISNULL(TRY_CAST(Selling_Price AS DECIMAL(18,4)), 0) AS Clean_Selling_Price,
        
        -- Deduplication: Assign a row number to handle accidentally duplicated product codes
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(Product_Code) 
            ORDER BY (SELECT NULL)
        ) AS flag_last
        
    FROM retail_db.bronze.erp_hypermarket_products
    -- Filter out NULL Product Codes and accidental header rows from CSV loads
    WHERE Product_Code IS NOT NULL AND Product_Code != 'Product_Code'
)

-- 4. Final Insert into the Silver table
INSERT INTO silver.erp_hypermarket_products (
    Product_Code, Product_Name, Category, Cost_Price, Selling_Price
)
SELECT 
    Clean_Product_Code, 
    Clean_Product_Name, 
    Clean_Category, 
    Clean_Cost_Price, 
    Clean_Selling_Price
FROM DataQualityChecks
-- Insert only the unique records (Deduplication filter)
WHERE flag_last = 1;
GO