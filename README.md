# 🏨 Hotel Analytics End-to-End dbt & Snowflake Project

This is an end-to-end data transformation pipeline built using **dbt (Data Build Tool)** and hosted on **Snowflake**. The project ingests raw hotel booking data, applies modern data warehousing design patterns, cleanses transactional logs, and builds highly optimized analytical data marts to track revenue, staff performance, and cancellation metrics.

---

## ❄️ Snowflake Infrastructure Engineering

The project relies on a tailored, cost-effective, and secure Snowflake warehouse architecture designed to isolate compute workloads and decouple raw assets from analytical spaces:

### 1. Compute Isolation (Virtual Warehouses)
* **`TEMBO_WH`:** Engineered as an **X-Small** warehouse with an aggressive **60-second auto-suspend** policy. The **TEMBO_WH** was initially suspend. This acts as the scratchpad environment for everyday local `dbt run` compiles, keeping operational credit consumption minimal.
Permissions and privilledges to the dbt role and user were granted to tembo_wh after createing a tembo_analytics database.

### 2. Storage & Schema Architecture
The environment uses discrete logical databases and schemas to mimic stages of the lifecycle pipeline:
* **`RAW_HOTEL_DATA` (Database):** Holds raw, immutable transactional source tables. Flat reference files loaded via `dbt seed` map straight into a `SEEDS` schema here.
* **`ANALYTICS_DEV` / `ANALYTICS_PROD` (Databases):** 
  * `STAGING` Schema: Houses lightweight, logical database views (`stg_hotel_bookings.sql`) that sanitize data on the fly without wasting disk footprint.
  * `MARTS` Schema: End-point for physical tables holding complex, pre-aggregated analytics. Dashboards and BI tools query this schema directly, keeping users insulated from raw spaces.

---

## 🧼 Data Cleaning & Standardization Logic

Before building analytical dashboards, the staging layer applies rigorous programmatic cleaning steps to ensure the underlying transaction logs are accurate, uniform, and trustworthy:

* **Strict Deduplication:** Uses window functions to identify duplicate data entries. By tracking specific transaction identifiers over timeline metrics, the pipeline isolates unique entries and purges redundant rows.
* **Text Sanitization & Extraction:** Employs regular expressions to isolate numeric data from dirty string variables (such as stripping letters or currency symbols out of payment records), converting them into clean decimal formats. 
* **Null Value Handling:** Protects calculations against mathematical errors by safely forcing blank spaces or corrupted fields into formal empty states.
* **Naming Standardization (Aliasing):** Normalizes column names into descriptive business terminology (e.g., standardizing shorthand attributes into explicit structural labels like transforming room metrics or employee references).
* **Granular Date Truncation:** Groups time-series timelines systematically by cutting specific day metrics down into broad monthly buckets, streamlining aggregations for financial and operational reporting.
* **Consistent String Casing:** Enforces uniform text alignment across variable categories (like booking statuses) by capitalizing the first letter of each word to eliminate variations caused by manual user input errors.
* **Chronological Sorting:** Organizes the final data state timeline progressively by booking and checkout cycles to facilitate smooth trend tracking.

---

## 🏗️ Project Architecture & Data Flow

The project utilizes dbt to organize structural SQL transformations:

### 1. Ingestion Layer (`/seeds`)
* **Purpose:** Loads static, manual, or lookup data into the warehouse.
* **Implementation:** Converts `.csv` lookup files into queryable relational database tables via the `dbt seed` utility command.

### 2. Cleaning & Standardization Layer (`/models/staging`)
* **Purpose:** Raw source abstraction and data type normalization.
* **Key Files:** 
  * `stg_hotel_bookings.sql`: Selects directly from raw records or seeds, execution home for the data cleaning parameters.
  * `_staging.yml`: Maps structural validation configurations, column metadata, and basic integrity rules.

### 3. Business Analytics Layer (`/models/marts`)
* **Purpose:** Combines clean staging models into highly optimized, dimensional models ready for data visualization.
* **Key Analytical Models:**
  * **Financial Performance:** `mrt_total_revenue.sql`, `mrt_department_revenue.sql`, and `growth_mom_revenue.sql` track granular cash flows and time-series trends.
  * **Operations & Risk:** `cancellation.sql` and `revenue_lost` quantify booking drop-offs and leakages.
  * **Performance & Feedback:** `mrt_room_type_rating.sql`, `mrt_roomtypes_question.sql`, `mrt_staff_bookings.sql`, and `busy_and_quiet_months.sql` evaluate asset utilization.

### 4. Data Quality & Controls (`/tests`)
* **Purpose:** Asserts strict data governance and structural verification rules.
* **Implementation:** Runs schema assertions (e.g., verifying booking primary keys are unique and non-null) alongside singular business logic tests (e.g., ensuring financial losses never flag as negative balances).

### 5. Utility Layer (`/macros`)
* **Purpose:** Contains reusable, global SQL function formulas to prevent code duplication across the pipeline.

---

## 🚀 Local Development Setup

Follow these setup steps to execute this project environment locally.

### 1. Requirements & Core Prerequisites
* Python 3.10+
* Active Snowflake account access credentials

### 2. Dependency Installation
Create and activate your Python virtual environment, then install the dbt Snowflake adapter core:
```bash
# Note: The 'dbt-env/' directory is safely ignored by Git to keep the repository lightweight
python -m venv dbt-env
./dbt-env/Scripts/activate

# Install the required adapter package
pip install dbt-core dbt-snowflake
```

### 3. Core dbt Pipeline Commands
Execute your dbt tasks sequentially within your active terminal:

```bash
# 1. Ingest static CSV lookup data
dbt seed

# 2. Compile and run all staging and dimensional mart SQL models
dbt run

# 3. Execute all data quality control and logic tests
dbt test

# 4. Generate local interactive documentation and lineage graphs
dbt docs generate
dbt docs serve
```
