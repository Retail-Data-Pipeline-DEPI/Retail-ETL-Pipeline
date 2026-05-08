# Project Proposal: Integrated Retail Data Intelligence & Pipeline

## 1. Problem Statement Profiling
The core challenge lies in data fragmentation across hypermarket operations, leading to critical visibility gaps in inventory, procurement, and market positioning. The following profile breaks down the business pain points:

| Dimension | Challenge Description | Business Impact |
| :--- | :--- | :--- |
| **Inventory & Recipe** | Difficulty in tracking the conversion of raw meat/poultry into processed goods (e.g., burgers, sausages) and reconciling system balances with physical counts. | Unexplained shrinkage (wastage) and significant profit loss in high-value departments. |
| **Procurement (Rebates)** | Lack of real-time monitoring for supplier rebate tiers and purchase volume agreements. | Missed opportunities to claim additional financial discounts upon reaching purchase targets. |
| **Market Competitiveness** | Delayed response to competitor price changes and promotions for Strategic/Key Value Items (KVIs). | Loss of market share to more agile competitors who leverage dynamic pricing. |
| **Operational Performance** | Difficulty in benchmarking branch efficiency, staff productivity, and cashier speed across time periods (YoY, MoM). | Inability to identify underperforming assets or staff for timely corrective action. |

---

## 2. Technical Roadmap (Steps & Tools)
To resolve these challenges, an end-to-end data pipeline will be implemented on the **Azure Cloud** environment. The following table outlines the technical execution:

| Technical Step | Description | Tools & Technologies |
| :--- | :--- | :--- |
| **1. Data Ingestion** | Extracting sales data from SQL, inventory logs from Parquet, and competitor prices via web scraping. | **Python, SQL Connectors, BeautifulSoup/Selenium** |
| **2. Bronze Layer (Raw)** | Landing all ingested data in its native format to ensure data lineage and reliability. | **Azure Data Lake Storage Gen2 (ADLS)** |
| **3. Silver Layer (Processing)** | Data cleaning, schema enforcement, and implementing "Recipe Logic" for meat/poultry yield/shrinkage calculations. | **Azure Databricks (PySpark)** |
| **4. Gold Layer (Business Logic)** | Calculating complex KPIs: Inventory Turnover, Rebate Tier progress, and variance reporting. | **Azure Databricks (Spark SQL)** |
| **5. Data Warehousing** | Loading structured data into a Galaxy Schema (Facts & Dimensions) for high-performance querying. | **Azure SQL Database / Synapse Analytics** |
| **6. Orchestration** | Scheduling and monitoring the entire E2E pipeline to run daily as a batch job. | **Apache Airflow (Dockerized)** |
| **7. Visualization** | Designing interactive dashboards for real-time alerts, time-series comparisons, and vendor scorecards. | **Power BI** |

---

## 3. Project Objectives
The primary goal is to build a "Commercial Control Tower" that provides actionable insights through the following objectives:

1. **Automated Inventory Reconciliation:** Automate the matching of physical vs. book inventory, specifically accounting for meat/poultry recipe breakdowns to identify real wastage.
2. **Dynamic Rebate Tracking:** Provide real-time visibility into purchase volumes vs. supplier tiers, triggering alerts when rebate targets are near achievement.
3. **Market Intelligence Hub:** Monitor competitor pricing daily and provide prescriptive pricing recommendations for strategic items to maintain market leadership.
4. **Operations Benchmarking:** Deliver a unified performance measurement framework for branches and staff, supporting advanced time-series analysis (Year-over-Year, Month-over-Month).
5. **Data-Driven Strategic Alignment:** Transform fragmented operational data into a "Single Version of Truth" to support the Commercial, Supply Chain, and Finance departments.
