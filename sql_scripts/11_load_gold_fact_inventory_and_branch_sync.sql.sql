/*
=================================================================================
Script Name: Load Gold Layer - Fact: Inventory (with Branch Name Sync)
Description: This script finalizes the inventory pipeline.
             Part 1: Modifies the Silver inventory load to harmonize branch names 
                     ('Alex' instead of 'Alexandria') ensuring compatibility with CRM data.
             Part 2: Creates the Inventory Fact table in the Gold layer, mapping 
                     business keys to analytical Surrogate Keys via dimension lookups.
=================================================================================
*/

USE retail_db;
GO

---------------------------------------------------------------------------
-- PART 1: Data Harmonization in the Silver Layer
---------------------------------------------------------------------------

-- 1.1 Drop the existing Silver inventory table
IF OBJECT_ID('silver.erp_inventory_stock', 'U') IS NOT NULL
    DROP TABLE silver.erp_inventory_stock;
GO

-- 1.2 Recreate the Silver table structure
CREATE TABLE silver.erp_inventory_stock (
    Product_Code      VARCHAR(50) NOT NULL,
    Product_Name      VARCHAR(255),
    Category          VARCHAR(100),
    Cost_Price        DECIMAL(18,4),
    Stock             INT,
    Branch            VARCHAR(50) NOT NULL,
    dwh_create_date   DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT PK_silver_inventory_stock PRIMARY KEY (Product_Code, Branch)
);
GO

-- 1.3 Consolidate and Harmonize Data
WITH ConsolidatedInventory AS (
    -- The Harmonization Fix: Hardcoding 'Alex' instead of 'Alexandria' 
    -- to match the CRM sales data and the dim_branches dimension.
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Alex' AS Branch 
    FROM retail_db.bronze.erp_Alex_Inventory_Stock
    UNION ALL
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Cairo' AS Branch
    FROM retail_db.bronze.erp_Cairo_Inventory_Stock
    UNION ALL
    SELECT Product_Code, Product_Name, Category, Cost_Price, Stock, 'Giza' AS Branch
    FROM retail_db.bronze.erp_Giza_Inventory_Stock
),

DataQualityChecks AS (
    SELECT 
        TRIM(Product_Code) AS Clean_Product_Code,
        TRIM(Product_Name) AS Clean_Product_Name,
        TRIM(Category) AS Clean_Category,
        ISNULL(TRY_CAST(Cost_Price AS DECIMAL(18,4)), 0) AS Clean_Cost_Price,
        ISNULL(TRY_CAST(Stock AS INT), 0) AS Clean_Stock,
        Branch,
        ROW_NUMBER() OVER (PARTITION BY TRIM(Product_Code), Branch ORDER BY (SELECT NULL)) AS flag_last
    FROM ConsolidatedInventory
    WHERE Product_Code IS NOT NULL AND Product_Code != 'Product_Code'
)

-- 1.4 Insert harmonized data into the Silver layer
INSERT INTO silver.erp_inventory_stock (Product_Code, Product_Name, Category, Cost_Price, Stock, Branch)
SELECT Clean_Product_Code, Clean_Product_Name, Clean_Category, Clean_Cost_Price, Clean_Stock, Branch
FROM DataQualityChecks
WHERE flag_last = 1;
GO


---------------------------------------------------------------------------
-- PART 2: Build the Gold Inventory Fact Table
---------------------------------------------------------------------------

-- 2.1 Drop the existing Gold Fact table
IF OBJECT_ID('gold.fact_inventory', 'U') IS NOT NULL
    DROP TABLE gold.fact_inventory;
GO

-- 2.2 Create the Inventory Fact table structure
CREATE TABLE gold.fact_inventory (
    Product_Key      INT NOT NULL,   -- Foreign Key to dim_products
    Branch_ID        INT NOT NULL,   -- Foreign Key to dim_branches
    Stock            INT,
    Cost_Price       DECIMAL(18,4),
    
    -- Composite Primary Key since a product has a specific stock level per branch
    CONSTRAINT PK_gold_fact_inventory PRIMARY KEY (Product_Key, Branch_ID)
);
GO

-- 2.3 Populate the Fact table by mapping business keys to surrogate keys via JOINs
INSERT INTO gold.fact_inventory (Product_Key, Branch_ID, Stock, Cost_Price)
SELECT 
    p.Product_Key,   
    b.Branch_ID,     
    i.Stock,
    i.Cost_Price
FROM silver.erp_inventory_stock i
LEFT JOIN gold.dim_products p ON i.Product_Code = p.Product_Code
LEFT JOIN gold.dim_branches b ON i.Branch = b.Branch_Name;
GO

-- 2.4 Display the final result to verify the Fact table load
SELECT TOP 300 * FROM gold.fact_inventory;
GO