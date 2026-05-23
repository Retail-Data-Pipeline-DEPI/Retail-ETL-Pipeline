/*
=================================================================================
Script Name: Load Gold Layer - Dimension: Products
Description: This script creates and populates the Products dimension table 
             in the Gold layer. It extracts cleansed product data from the 
             Silver layer and generates a Surrogate Key (Product_Key) to 
             optimize joins and analytical queries in the Star Schema.
=================================================================================
*/

USE retail_db;
GO

-- 1. Drop the products dimension table if it already exists to ensure an idempotent load
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;
GO

-- 2. Create the products dimension table structure with a Surrogate Key
CREATE TABLE gold.dim_products (
    Product_Key      INT IDENTITY(1,1) NOT NULL, -- Fast and efficient Surrogate Key (Analytical)
    Product_Code     VARCHAR(50) NOT NULL,       -- Original Business/Operational Key from source
    Product_Name     VARCHAR(255),
    Category         VARCHAR(100),
    Cost_Price       DECIMAL(18,4),
    Selling_Price    DECIMAL(18,4),
    
    -- Set the newly generated Surrogate Key as the Primary Key for the table
    CONSTRAINT PK_gold_dim_products PRIMARY KEY (Product_Key)
);
GO

-- 3. Extract cleansed data from the Silver layer and insert into the Gold layer
INSERT INTO gold.dim_products (Product_Code, Product_Name, Category, Cost_Price, Selling_Price)
SELECT 
    Product_Code,
    Product_Name,
    Category,
    Cost_Price,
    Selling_Price
FROM silver.erp_hypermarket_products;
GO

-- 4. Query a sample of the top 10 products to verify the operation and sequencing (For validation)
SELECT TOP 10 * FROM gold.dim_products;
GO