-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script performs data cleaning and transformation on
-- the raw loan dataset to create a structured table suitable
-- for credit risk analysis and dashboard reporting.
--
-- The script creates a new table called "loans_clean" from the
-- original "loan_raw" dataset by standardizing data formats,
-- converting data types, and generating derived fields needed
-- for risk analysis.
--
-- Key transformations performed:
--   • Convert issue date from text format to a proper DATE type
--   • Convert interest rate from percentage string to numeric
--   • Select relevant financial, borrower, and loan attributes
--   • Create a binary default indicator for risk modeling
--
-- Default classification logic:
--   • Loans with status 'Charged Off' or 'Default' are marked
--     as defaulted (default_flag = 1)
--   • All other loans are marked as non-default (default_flag = 0)
--
-- This cleaned dataset serves as the primary analytical table
-- for the project and supports the following analyses:
--   • Credit risk modeling (PD, LGD, Expected Loss)
--   • Default rate monitoring
--   • Risk segmentation by loan grade
--   • Portfolio exposure analysis
--   • Dashboard visualizations in Power BI
--
-- Validation queries are included to:
--   • Verify the number of records in the cleaned dataset
--   • Inspect unique loan status categories
--   • Calculate overall default rate in the portfolio
--
-- Key fields generated or standardized:
--   • issue_date      → standardized loan origination date
--   • interest_rate   → numeric interest rate value
--   • default_flag    → binary default indicator
--
-- The resulting loans_clean table acts as the core dataset
-- for all subsequent credit risk analytics in the project.
-- ============================================================

-----CREATING TABLE AS loan_clean for cleaning and analysis -----

CREATE TABLE loans_clean AS
SELECT
    id,
    TO_DATE(issue_d, 'Mon-YYYY') AS issue_date,
    loan_amnt,
    CAST(REPLACE(int_rate, '%', '') AS NUMERIC) AS interest_rate,
    installment,
    term,
    grade,
    sub_grade,
    annual_inc,
    home_ownership,
    verification_status,
    emp_length,
    purpose,
    addr_state,
    dti,
    loan_status,
    total_pymnt,
    total_rec_prncp,
    total_rec_int,
    recoveries,
    collection_recovery_fee,
    last_pymnt_amnt,

    CASE 
        WHEN loan_status IN ('Charged Off', 'Default') THEN 1
        ELSE 0
    END AS default_flag

FROM loan_raw;

--- COUNT OF ROWS ---

SELECT COUNT(*) FROM loans_clean;

---- loan_status type----

SELECT DISTINCT loan_status FROM loans_clean;

---- DEFAULT STATUS ----
SELECT 
    COUNT(*) AS total_loans,
    SUM(default_flag) AS total_defaults,
    ROUND(SUM(default_flag)::numeric / COUNT(*) * 100, 2) AS default_rate

FROM loans_clean;
