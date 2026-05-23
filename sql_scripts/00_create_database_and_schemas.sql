/*
=================================================================================
Script Name: Create Database and Schemas
Description: This script initializes the Data Warehouse environment. 
             It creates the main database 'retail_db' and sets up the 
             three schemas required for the Medallion Architecture 
             (Bronze, Silver, and Gold).
=================================================================================
*/

-- Switch to the system database to execute server-level commands
USE master;
GO

-- Create the main database for the Retail ETL Pipeline project
CREATE DATABASE retail_db;
GO

-- Switch to the newly created project database
USE retail_db;
GO

/*
=================================================================================
Create Medallion Architecture Schemas
=================================================================================
*/

-- 1. Create Bronze Schema: For raw, unprocessed data (As-Is from sources)
CREATE SCHEMA bronze;
GO

-- 2. Create Silver Schema: For cleaned, standardized, and transformed data
CREATE SCHEMA silver;
GO

-- 3. Create Gold Schema: For business-ready data modeled as Star Schema (Facts & Dimensions)
CREATE SCHEMA gold;
GO