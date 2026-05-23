# Retail ETL Pipeline - DEPI Graduation Project

## Overview
This project is part of the **DEPI (Digital Egypt Pioneers Initiative)** - Microsoft Data Engineering Track. It demonstrates a complete, scalable, and automated ETL (Extract, Transform, Load) pipeline tailored for the retail sector. 

Beyond standard data movement, this pipeline acts as a **Commercial Control Tower**, addressing complex retail challenges such as resolving inventory shrinkage, decoding meat/poultry "Recipe" conversions, and tracking dynamic supplier rebate tiers. It transforms fragmented raw datasets into a "Single Version of Truth" to drive proactive business decisions.
---


The project strictly follows the **Medallion Architecture** (Bronze, Silver, Gold layers) to ensure data quality, traceability, and performance.

## Architecture & Data Flow
![Medallion Architecture Pipeline Design](https://github.com/Retail-Data-Pipeline-DEPI/Retail-ETL-Pipeline/raw/aedb4a95a47553a3a5e673a63a88ec103be9a740/Visuals/Medallion%20Architecture%20Pipeline%20Design.png)

## Project Structure
Below is the directory structure of the repository:

```text
Retail-Data-Warehouse
 |- BI_Team_Analysis        # Power BI dashboard and exported reports based on the Gold layer
 |  |- analysis dashboard.pbix
 |  |- analysis dashboard.pdf
 |- Visuals                 # Architectural diagrams and pipeline workflows
 |  |- Medallion Architecture Pipeline Design.png
 |- data_source             # Raw CSV datasets from CRM and ERP systems
 |  |- 000.Hypermarket Products.csv
 |  |- 001.Alex Branch Sales.csv
 |  |- 002.Cairo Branch Sales.csv
 |  |- 003.Giza Branch Sales.csv
 |  |- 004.Alex Stock.csv
 |  |- 005.Cairo Stock.csv
 |  |- 006.Giza Stock.csv
 |- docs                    # Comprehensive project documentation
 |  |- 01_Project_Proposal.md
 |  |- 02_Requirements.md
 |  |- 03_System_Architecture.md
 |  |- 04_Testing_and_Deployment.md
 |  |- data_dictionary.md
 |- sql_scripts             # ETL pipeline stored procedures and schema definitions
 |  |- 00_create_database_and_schemas.sql
 |  |- ... (Bronze, Silver, and Gold Layer Scripts)
 |  |- 12_rebuild_inventory_pipeline_final_fix.sql
 |- docker-compose.yml      # Infrastructure setup for SQL Server
 |- README.md               # Project overview and execution guide

---
د---
### 1.2. Project Methodology & Timeline
The project follows an iterative, Agile-based approach tailored for data engineering, divided into the following key phases (Sprints):
1.  **Phase 1: Planning & Infrastructure Setup:** Defining the architecture, configuring Azure Data Lake Storage (ADLS), and initializing the Apache Airflow environment.
2.  **Phase 2: Data Ingestion (Bronze Layer):** Establishing hybrid data ingestion pipelines for relational databases (SQL) and flat-file storage (Parquet).
3.  **Phase 3: Data Processing (Silver & Gold Layers):** Writing PySpark jobs to clean, transform, apply complex business logic (e.g., Recipe yields, Inventory Turnover), and aggregate the retail data.
4.  **Phase 4: Orchestration & Automation:** Configuring Apache Airflow DAGs to schedule, monitor, and alert daily workflows.
5.  **Phase 5: Testing & Documentation:** Validating data quality across the Medallion architecture and finalizing CI/CD & GitHub documentation.

---
