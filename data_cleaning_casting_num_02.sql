-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script standardizes data types for key financial
-- columns in the loans_clean table to ensure they are stored
-- as numeric values suitable for quantitative analysis.
--
-- In the original dataset, several financial fields were
-- imported as text or inconsistent data types, which prevents
-- accurate aggregation and mathematical operations.
--
-- The ALTER TABLE statements convert these columns to the
-- NUMERIC data type using explicit casting.
--
-- Columns standardized:
--   • loan_amnt        → total loan amount issued
--   • annual_inc       → borrower annual income
--   • total_rec_int    → total interest received
--   • total_rec_prncp  → total principal repaid
--   • recoveries       → amount recovered from defaulted loans
--
-- Standardizing these columns ensures compatibility with
-- portfolio-level calculations such as:
--   • exposure analysis
--   • interest income analysis
--   • loss estimation
--   • expected credit loss calculations
--
-- This step is an essential part of the data preparation
-- process before performing credit risk analytics and
-- building the Power BI dashboard.
-- ============================================================

ALTER TABLE loans_clean
ALTER COLUMN loan_amnt TYPE NUMERIC USING loan_amnt::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN annual_inc TYPE NUMERIC USING annual_inc::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN total_rec_int TYPE NUMERIC USING total_rec_int::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN total_rec_prncp TYPE NUMERIC USING total_rec_prncp::NUMERIC;

ALTER TABLE loans_clean

ALTER COLUMN recoveries TYPE NUMERIC USING recoveries::NUMERIC;
