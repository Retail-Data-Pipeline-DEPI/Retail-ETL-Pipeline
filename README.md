# Retail ETL Pipeline - DEPI Graduation Project

## Overview
This project is part of the **DEPI (Digital Egypt Pioneers Initiative)** - Microsoft Data Engineering Track. It demonstrates a complete, scalable, and automated ETL (Extract, Transform, Load) pipeline tailored for retail datasets, designed to handle large volumes of data efficiently.

---

## 1. Project Planning & Management

### 1.1. Team Structure
The project is executed by a dedicated data engineering team, collaborating to build a robust architecture:
*   **Esraa Soliman Mubarak** - Project Leader & Data Engineer
*   **Ali Hussein Sayed** - Data Engineer
*   **Osama Nour El-Din Mohammed** - Data Engineer
*   **Nagham Abd Elraouf Elbayoumy Rizk** - Data Engineer

### 1.2. Project Methodology & Timeline
The project follows an iterative, agile-based approach tailored for data engineering, divided into the following key phases:
1.  **Phase 1: Planning & Infrastructure Setup:** Defining the architecture, setting up Azure Data Lake, and initializing the Apache Airflow environment.
2.  **Phase 2: Data Ingestion (Bronze Layer):** Establishing hybrid data ingestion pipelines for both SQL and Parquet data sources.
3.  **Phase 3: Data Processing (Silver & Gold Layers):** Writing PySpark jobs (Spark SQL & DataFrames) to clean, transform, and aggregate the retail data.
4.  **Phase 4: Orchestration & Automation:** Configuring Apache Airflow DAGs to schedule and monitor daily workflows.
5.  **Phase 5: Testing & Documentation:** Validating data quality across layers and finalizing GitHub documentation.

---

## 2. Literature Review

### 2.1. The Challenge in Retail Data
The retail industry generates massive, diverse datasets daily (transactions, inventory, customer interactions). Traditional monolithic databases or simple CRON-based ETL jobs often fail to scale, leading to data bottlenecks, delayed reporting, and complex maintenance. 

### 2.2. Proposed Solution and Tech Stack Justification
To address these challenges, modern data engineering paradigms advocate for distributed processing and decoupled storage. 
*   **Apache Airflow** was chosen over traditional schedulers due to its dynamic, programmatic approach to authoring workflows (DAGs) and its robust dependency management and error handling.
*   **PySpark** is utilized for its in-memory processing capabilities, making it vastly superior to standard Python libraries (like Pandas) when dealing with large-scale retail data transformations.
*   **Medallion Architecture (Bronze, Silver, Gold)** logically organizes data in the Data Lake, ensuring data quality progressively improves from raw ingestion to business-ready aggregated tables.

---

## 3. Requirements Gathering

### 3.1. Functional Requirements
*   **Hybrid Data Ingestion:** The system must extract data from diverse sources, specifically relational databases (SQL) and flat file storage (Parquet).
*   **Data Transformation:** The pipeline must perform data cleansing, handle missing values, and execute complex business logic (e.g., calculating daily sales, inventory turnover) using PySpark.
*   **Workflow Orchestration:** The entire pipeline must be fully automated to run on a daily schedule without manual intervention.

### 3.2. Non-Functional Requirements
*   **Scalability:** The pipeline must efficiently handle increasing volumes of retail data using Spark's distributed processing.
*   **Reliability & Fault Tolerance:** Airflow DAGs must include retry mechanisms and alerting for failed tasks.
*   **Maintainability:** The codebase must be modular, well-documented, and version-controlled via GitHub.

---

## 4. System Analysis & Design

### 4.1. Architecture Design
The system architecture is designed around a Cloud Data Warehouse / Azure Data Lake ecosystem, orchestrated by Apache Airflow.
1.  **Source Systems:** SQL Databases and Parquet files containing raw retail data.
2.  **Orchestrator:** Apache Airflow triggers the daily extraction and transformation jobs.
3.  **Processing Engine:** PySpark scripts execute the ETL logic.
4.  **Storage (Azure Data Lake):** The data flows through the Medallion Architecture.

### 4.2. Data Modeling (Medallion Architecture)
*   **Bronze Layer (Raw):** Landing zone for raw data ingested directly from SQL and Parquet sources. Data is stored exactly as it arrives to maintain an immutable history.
*   **Silver Layer (Cleansed & Conformed):** PySpark reads from the Bronze layer, applies data quality checks, standardizes schemas, and filters out invalid records. This layer acts as the single source of truth.
*   **Gold Layer (Curated & Aggregated):** Data is aggregated and modeled (e.g., Star Schema with Fact and Dimension tables) to serve specific business use cases, such as retail performance dashboards and BI reporting.
