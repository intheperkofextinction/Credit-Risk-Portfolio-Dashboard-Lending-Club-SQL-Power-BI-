-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates and populates a synthetic sales
-- dataset used to simulate revenue generated from lending
-- activities. Since the original loan dataset does not
-- contain explicit revenue records, this table is created
-- to model how a lending institution may generate income
-- from its customer base.
--
-- The script performs the following steps:
--
-- 1. Create the "sales" table
--    - Stores simulated revenue transactions associated
--      with lending operations.
--    - Key attributes include:
--        • sale_date (transaction date)
--        • customer_id (borrower identifier)
--        • product_category (loan purpose)
--        • revenue (simulated income generated)
--        • region (borrower location)
--
-- 2. Generate synthetic revenue records
--    - Revenue is estimated as a percentage of the loan
--      amount issued to each borrower.
--    - In this simulation, revenue is assumed to be
--      10% of the loan amount.
--    - Loan purpose is used as the product category,
--      while the borrower's state represents the region.
--
-- 3. Validate the dataset
--    - A sample query retrieves a limited number of rows
--      to verify successful table creation and data insertion.
--
-- Purpose of this table:
-- The sales dataset enables the project to extend beyond
-- pure credit risk analysis and simulate business revenue
-- streams. This allows additional analytics such as:
--
--   • revenue trend analysis
--   • profitability calculations
--   • revenue vs expense comparisons
--   • financial performance dashboards
--
-- These simulated revenue metrics support the financial
-- analytics components of the Power BI dashboard and help
-- demonstrate portfolio profitability alongside credit risk.
-- ============================================================

---- Create Sales Table ----

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id TEXT,
    product_category TEXT,
    revenue NUMERIC,
    region TEXT
);

---- simulate company revenue generated from customers ----

INSERT INTO sales (sale_date, customer_id, product_category, revenue, region)
SELECT
    issue_date,
    id::text,
    purpose,
    loan_amnt::numeric * 0.1,
    addr_state
FROM loans_clean;

---- Sales table view ----

SELECT *
FROM sales

LIMIT 10;
