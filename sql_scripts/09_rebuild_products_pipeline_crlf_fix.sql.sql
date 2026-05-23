/*
=================================================================================
Script Name: Rebuild Products Pipeline (CRLF Hotfix)
Description: This script addresses a common CSV parsing issue where carriage 
             returns and line feeds corrupt the last column's data. 
             Part 1: Cleanses and reloads the Silver products table using REPLACE.
             Part 2: Drops, recreates, and reloads the Gold dimensions table 
                     to reflect the cleansed data and generate fresh Surrogate Keys.
=================================================================================
*/

USE retail_db;
GO

---------------------------------------------------------------------------
-- PART 1: Fix the root cause in the Silver Layer
---------------------------------------------------------------------------

-- 1.1 Drop the existing Silver table
IF OBJECT_ID('silver.erp_hypermarket_products', 'U') IS NOT NULL
    DROP TABLE silver.erp_hypermarket_products;
GO

-- 1.2 Recreate the Silver table structure
CREATE TABLE silver.erp_hypermarket_products (
    Product_Code      VARCHAR(50) NOT NULL,
    Product_Name      VARCHAR(255),
    Category          VARCHAR(100),
    Cost_Price        DECIMAL(18,4),
    Selling_Price     DECIMAL(18,4),
    dwh_create_date   DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT PK_silver_products PRIMARY KEY (Product_Code)
);
GO

-- 1.3 Apply Advanced Data Quality Checks (The CRLF Fix)
WITH DataQualityChecks AS (
    SELECT 
        TRIM(Product_Code) AS Clean_Product_Code,
        TRIM(Product_Name) AS Clean_Product_Name,
        TRIM(Category) AS Clean_Category,
        
        ISNULL(TRY_CAST(Cost_Price AS DECIMAL(18,4)), 0) AS Clean_Cost_Price,
        
        -- The Magic Fix: Remove hidden Carriage Return (CR) and Line Feed (LF) characters 
        -- before casting to DECIMAL, preventing the values from turning into NULL/0.
        ISNULL(TRY_CAST(REPLACE(REPLACE(Selling_Price, CHAR(13), ''), CHAR(10), '') AS DECIMAL(18,4)), 0) AS Clean_Selling_Price,
        
        ROW_NUMBER() OVER (PARTITION BY TRIM(Product_Code) ORDER BY (SELECT NULL)) AS flag_last
        
    FROM retail_db.bronze.erp_hypermarket_products
    WHERE Product_Code IS NOT NULL AND Product_Code != 'Product_Code'
)

-- 1.4 Final Insert into the cleansed Silver table
INSERT INTO silver.erp_hypermarket_products (
    Product_Code, Product_Name, Category, Cost_Price, Selling_Price
)
SELECT Clean_Product_Code, Clean_Product_Name, Clean_Category, Clean_Cost_Price, Clean_Selling_Price
FROM DataQualityChecks
WHERE flag_last = 1;
GO


---------------------------------------------------------------------------
-- PART 2: Rebuild the Gold Layer with the cleansed data
---------------------------------------------------------------------------

-- 2.1 Drop the existing Gold table
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO

-- 2.2 Recreate the Gold table structure with the Surrogate Key
CREATE TABLE gold.dim_products (
    Product_Key      INT IDENTITY(1,1) NOT NULL, 
    Product_Code     VARCHAR(50) NOT NULL,       
    Product_Name     VARCHAR(255),
    Category         VARCHAR(100),
    Cost_Price       DECIMAL(18,4),
    Selling_Price    DECIMAL(18,4),
    
    CONSTRAINT PK_gold_dim_products PRIMARY KEY (Product_Key)
);
GO

-- 2.3 Insert the fully cleansed data from Silver to Gold
INSERT INTO gold.dim_products (Product_Code, Product_Name, Category, Cost_Price, Selling_Price)
SELECT Product_Code, Product_Name, Category, Cost_Price, Selling_Price
FROM silver.erp_hypermarket_products;
GO

-- 2.4 Display the final result to verify the fix
SELECT TOP 10 * FROM gold.dim_products;
GO