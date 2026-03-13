-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL query performs a simple credit risk stress test on the lending portfolio to estimate how expected losses would change under a deterioration in borrower credit quality.
-- The analysis first calculates baseline credit risk parameters using the loans_clean dataset:
--   • Probability of Default (PD)
--       Proportion of loans that defaulted in the portfolio.
--   • Loss Given Default (LGD)
--       Percentage of loan exposure lost after accounting
--       for recoveries from defaulted loans.
--   • Exposure
--       Total loan capital issued across the portfolio.
--
-- Using these values, the script calculates the portfolio’s
-- Expected Loss (EL) based on the standard credit risk model:
--
--       Expected Loss = PD × LGD × Exposure
--
-- The query then simulates a stress scenario by increasing the Probability of Default by 3 percentage points. This represents a potential economic downturn or worsening borrower credit conditions.
--
-- The following metrics are produced:
--
--   • Base Expected Loss
--       Expected loss under normal portfolio conditions.
--
--   • Stressed Expected Loss
--       Expected loss assuming the probability of default
--       increases by 3%.
--
--   • Incremental Loss
--       Additional loss generated under the stress scenario.
--
-- This type of stress testing is commonly used in financial risk management to evaluate how sensitive a lending portfolio is to worsening economic conditions and to help institutions plan capital buffers for potential losses.
-- ============================================================

WITH risk AS (
    SELECT
        SUM(default_flag)::numeric / COUNT(*) AS pd,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1)
            / SUM(loan_amnt) FILTER (WHERE default_flag=1) AS lgd,
        SUM(loan_amnt) AS exposure
    FROM loans_clean
)

SELECT
    pd,
    lgd,
    exposure,
    pd * lgd * exposure AS base_expected_loss,
    (pd + 0.03) * lgd * exposure AS stressed_expected_loss,
    ((pd + 0.03) * lgd * exposure) - (pd * lgd * exposure)
        AS incremental_loss

FROM risk;

