-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a customer dimension table from the
-- raw loan dataset. The purpose of this step is to transform
-- loan-level data into a structured customer-level dataset
-- that can support segmentation and regional portfolio analysis.
--
-- The script extracts unique customers from the loan_raw table
-- and assigns basic attributes including geographic region
-- and customer segment based on annual income levels.
--
-- Customer segmentation logic:
--   • Customers with annual income above 100,000 are classified
--     as "Corporate".
--   • Customers with annual income at or below 100,000 are
--     classified as "Retail".
--
-- This customer table enables:
--   • Regional portfolio analysis
--   • Customer segmentation analytics
--   • Risk exposure by customer group
--   • Integration with loan-level risk metrics
--
-- Key fields created:
--   • customer_id  → unique customer identifier
--   • region       → customer geographic state
--   • segment      → customer category (Corporate / Retail)
--
-- The script also includes verification queries to preview
-- the created table and confirm the total number of customers.
-- ============================================================

---- CREATING customers TABLE FROM loan_raw ----

CREATE TABLE customers AS
SELECT DISTINCT
    id AS customer_id,
    addr_state AS region,
    
    CASE
        WHEN annual_inc::numeric > 100000 THEN 'Corporate'
        ELSE 'Retail'
    END AS segment
FROM loan_raw;

---- customers table view ----

SELECT *
FROM customers
LIMIT 10;

---- COUNT OF CUSTOMERS ----

SELECT COUNT(*) FROM customers;

