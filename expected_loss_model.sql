-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script calculates recovery and expected credit
-- losses within the loan portfolio using loan-level
-- performance data from the loans_clean table.
--
-- The analysis focuses on estimating the proportion of losses
-- recovered after borrower defaults and quantifying the
-- expected financial impact of credit risk across loan grades.
--
-- The script performs two key analyses:
--
-- 1. Recovery Rate Calculation
--    - Measures the proportion of defaulted loan exposure that
--      has been recovered through collections or other recovery
--      processes.
--    - Formula used:
--
--        Recovery Rate =
--        Total Recoveries / Total Defaulted Loan Amount
--
--    - This metric provides insight into the effectiveness of
--      the recovery process and reduces overall loss exposure.
--
-- 2. Expected Loss by Loan Grade
--    - Estimates potential credit losses across different
--      credit grades using a standard credit risk framework.
--
--    - Key metrics calculated:
--
--        • Exposure
--          Total loan amount issued within each credit grade.
--
--        • Probability of Default (PD)
--          Proportion of loans that defaulted within each grade.
--
--        • Loss Given Default (LGD)
--          Percentage of exposure lost after accounting for
--          recoveries from defaulted loans.
--
--        • Expected Loss (EL)
--          Estimated portfolio loss calculated using the
--          standard credit risk formula:
--
--              Expected Loss = Exposure × PD × LGD
--
-- This analysis helps identify high-risk segments of the loan
-- portfolio and supports risk management decisions such as
-- capital allocation, credit policy adjustments, and portfolio
-- monitoring.
-- ============================================================

---- Calculating Recovery Rate ----

SELECT
    SUM(recoveries) / 
    SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
    AS recovery_rate
FROM loans_clean;

---- Expected Loss by Grade ----

SELECT
    grade,
    SUM(loan_amnt) AS exposure,
    SUM(default_flag)::numeric / COUNT(*) AS pd,
    (1 - (SUM(recoveries) / 
        SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
     )) AS lgd,
    SUM(loan_amnt) *
    (SUM(default_flag)::numeric / COUNT(*)) *
    (1 - (SUM(recoveries) / 
        SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
     )) AS expected_loss
FROM loans_clean

GROUP BY grade;
