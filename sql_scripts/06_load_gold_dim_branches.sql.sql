/*
=================================================================================
Script Name: Load Gold Layer - Dimension: Branches
Description: This script creates and populates the Branches dimension table 
             in the Gold layer. It extracts unique branch names from the 
             Silver layer and generates a Surrogate Key (Branch_ID) for 
             optimal performance in the Star Schema.
=================================================================================
*/

USE retail_db;
GO

-- 1. Create the Gold schema if it does not exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO

-- 2. Drop the branches dimension table if it already exists to ensure an idempotent load
IF OBJECT_ID('gold.dim_branches', 'U') IS NOT NULL
    DROP TABLE gold.dim_branches;
GO

-- 3. Create the branches dimension table structure
CREATE TABLE gold.dim_branches (
    Branch_ID   INT IDENTITY(1,1) NOT NULL, -- IDENTITY automatically generates a sequential Surrogate Key (1, 2, 3...)
    Branch_Name VARCHAR(50) NOT NULL,
    
    CONSTRAINT PK_gold_dim_branches PRIMARY KEY (Branch_ID)
);
GO

-- 4. Extract unique branch names from the Silver sales table and insert them
INSERT INTO gold.dim_branches (Branch_Name)
SELECT DISTINCT Branch 
FROM silver.crm_sales_transactions
WHERE Branch IS NOT NULL;
GO

-- 5. Query the table to verify the inserted data (Optional/For debugging)
SELECT * FROM gold.dim_branches;
GO