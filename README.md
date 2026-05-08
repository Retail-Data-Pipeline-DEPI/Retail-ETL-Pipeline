# 🛒 Retail ETL Pipeline - DEPI Graduation Project

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=Apache%20Airflow&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=databricks&logoColor=white)

## 📌 Overview
This project is part of the **DEPI (Digital Egypt Pioneers Initiative)** - Microsoft Data Engineering Track. It demonstrates a complete, scalable, and automated ETL (Extract, Transform, Load) pipeline tailored for the retail sector. 

Beyond standard data movement, this pipeline acts as a **Commercial Control Tower**, addressing complex retail challenges such as resolving inventory shrinkage, decoding meat/poultry "Recipe" conversions, and tracking dynamic supplier rebate tiers. It transforms fragmented raw datasets into a "Single Version of Truth" to drive proactive business decisions.

---

## 👥 1. Project Planning & Management

### 1.1. Team Structure
This project is architected and executed by a dedicated data engineering team:
* **Esraa Soliman Mubarak** - Project Leader & Data Engineer
* **Ali Hussein Sayed** - Data Engineer
* **Osama Nour El-Din Mohammed** - Data Engineer
* **Nagham Abd Elraouf Elbayoumy Rizk** - Data Engineer

### 1.2. Project Methodology & Timeline
The project follows an iterative, Agile-based approach tailored for data engineering, divided into the following key phases (Sprints):
1.  **Phase 1: Planning & Infrastructure Setup:** Defining the architecture, configuring Azure Data Lake Storage (ADLS), and initializing the Apache Airflow environment.
2.  **Phase 2: Data Ingestion (Bronze Layer):** Establishing hybrid data ingestion pipelines for relational databases (SQL) and flat-file storage (Parquet).
3.  **Phase 3: Data Processing (Silver & Gold Layers):** Writing PySpark jobs to clean, transform, apply complex business logic (e.g., Recipe yields, Inventory Turnover), and aggregate the retail data.
4.  **Phase 4: Orchestration & Automation:** Configuring Apache Airflow DAGs to schedule, monitor, and alert daily workflows.
5.  **Phase 5: Testing & Documentation:** Validating data quality across the Medallion architecture and finalizing CI/CD & GitHub documentation.

---

## 📂 2. Repository Structure

```text
Retail-ETL-Pipeline/
│
├── dags/                        # Apache Airflow DAGs
│   ├── retail_etl_dag.py
│   └── config_dag.py
│
├── src/                         # Core PySpark & Python Scripts
│   ├── __init__.py
│   ├── ingestion/
│   │   ├── sql_ingestion.py
│   │   └── parquet_ingestion.py
│   ├── transformation/
│   │   ├── bronze_to_silver.py
│   │   └── silver_to_gold.py
│   └── utils/
│       ├── spark_session.py
│       └── logger.py
│
├── config/                      # Configuration Files
│   ├── db_config.json
│   └── spark_config.json
│
├── tests/                       # Unit & Integration Tests
│   ├── test_ingestion.py
│   └── test_transformation.py
│
├── docs/
│   ├── 01_Project_Proposal.md 
│   ├── 02_Requirements.md        
│   ├── 03_System_Architecture.md  
│   └── 04_Testing_and_Deployment.m   # Project Documentation
│   ├── 05_architecture.png
│   ├── 06_data_dictionary.md
│   └── 07_Retail_ETL_Presentation.pptx
│   └── 07_Retail_ETL_Presentation.pdf
│
├── .gitignore
├── requirements.txt
└── README.md
