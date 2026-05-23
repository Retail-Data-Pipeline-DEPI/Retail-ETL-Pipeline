/*
=================================================================================
Script Name: Load Silver Layer - ERP Inventory Stock
Description: This script consolidates raw inventory data from multiple branches 
             into a single unified table in the Silver layer. It dynamically 
             injects a 'Branch' identifier, enforces a composite primary key, 
             and applies robust data quality checks and deduplication.
=================================================================================
*/

USE retail_db;
GO

-- 1. Drop the table if it already exists to ensure an idempotent load
IF OBJECT_ID('silver.erp_inventory_stock', 'U') IS NOT NULL
    DROP TABLE silver.erp_inventory_stock;
GO

-- 2. Create the unified inventory table structure with precise data types
CREATE TABLE silver.erp_inventory_stock (
    Product_Code      VARCHAR(50) NOT NULL,
    Product_Name      VARCHAR(255),
    Category          VARCHAR(100),
    Cost_Price        DECIMAL(18,4),
    Stock             INT,
    Branch            VARCHAR(50) NOT NULL,       -- Injected column to distinguish between branches
    dwh_create_date   DATETIME DEFAULT GETDATE(), -- Metadata column for auditing (Audit trail)
    
    -- Composite Primary Key (Product_Code + Branch) since a product exists in multiple branches
    CONSTRAINT PK_silver_inventory_stock PRIMARY KEY (Product_Code, Branch)
);
GO

-- 3. Apply Data Quality Checks and ETL transformations using CTEs
WITH ConsolidatedInventory AS (
    -- a. Consolidate the three branch tables and programmatically inject the Branch column
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Alexandria' AS Branch
    FROM retail_db.bronze.erp_Alex_Inventory_Stock
    UNION ALL
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Cairo' AS Branch
    FROM retail_db.bronze.erp_Cairo_Inventory_Stock
    UNION ALL
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Giza' AS Branch
    FROM retail_db.bronze.erp_Giza_Inventory_Stock
),

DataQualityChecks AS (
    -- b. Cleanse text and protect the code from failing using TRY_CAST
    SELECT 
        TRIM(Product_Code) AS Clean_Product_Code,
        TRIM(Product_Name) AS Clean_Product_Name,
        TRIM(Category) AS Clean_Category,
        
        -- Defensive protection against text or empty spaces in pricing and quantities
        ISNULL(TRY_CAST(Cost_Price AS DECIMAL(18,4)), 0) AS Clean_Cost_Price,
        ISNULL(TRY_CAST(Stock AS INT), 0) AS Clean_Stock,
        
        Branch,
        
        -- c. Deduplication to handle cases where a product is duplicated within the SAME branch
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(Product_Code), Branch 
            ORDER BY (SELECT NULL)
        ) AS flag_last

    FROM ConsolidatedInventory
    -- Exclude fully NULL rows and header rows if accidentally imported from CSVs
    WHERE Product_Code IS NOT NULL AND Product_Code != 'Product_Code'
)

-- 4. Final Insert into the Silver inventory table
INSERT INTO silver.erp_inventory_stock (
    Product_Code, Product_Name, Category, Cost_Price, Stock, Branch
)
SELECT 
    Clean_Product_Code,
    Clean_Product_Name,
    Clean_Category,
    Clean_Cost_Price,
    Clean_Stock,
    Branch
FROM DataQualityChecks
WHERE flag_last = 1; -- The magic filter to prevent duplicates
GO