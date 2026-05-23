/*
=================================================================================
Script Name: Load Gold Layer - Dimension: Customers
Description: This script creates and populates the Customers dimension table 
             in the Gold layer. It extracts unique combinations of customer 
             types and genders from the Silver layer and generates a 
             Surrogate Key (Customer_ID) using the IDENTITY property.
=================================================================================
*/

USE retail_db;
GO

-- 1. Drop the customers dimension table if it already exists to ensure an idempotent load
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;
GO

-- 2. Create the customers dimension table structure
CREATE TABLE gold.dim_customers (
    Customer_ID   INT IDENTITY(1,1) NOT NULL, -- Automatically generates a sequential Surrogate Key (1, 2, 3...)
    Customer_type VARCHAR(50) NOT NULL,
    Gender        VARCHAR(20) NOT NULL,
    
    -- Primary Key constraint
    CONSTRAINT PK_gold_dim_customers PRIMARY KEY (Customer_ID)
);
GO

-- 3. Extract unique combinations of customer attributes from Silver layer and insert them
INSERT INTO gold.dim_customers (Customer_type, Gender)
SELECT DISTINCT 
    Customer_type, 
    Gender 
FROM silver.crm_sales_transactions
WHERE Customer_type IS NOT NULL AND Gender IS NOT NULL;
GO

-- 4. Query the table to verify the final structure and data (For validation purposes)
SELECT * FROM gold.dim_customers;
GO