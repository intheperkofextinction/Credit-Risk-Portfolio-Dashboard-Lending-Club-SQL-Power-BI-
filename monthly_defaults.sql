-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a view that analyzes loan default
-- trends over time by aggregating portfolio performance on a
-- monthly basis.
--
-- The objective of this analysis is to monitor the evolution
-- of credit risk within the loan portfolio and identify
-- potential periods of increasing default activity.
--
-- The view aggregates loan-level data from the loans_clean
-- table and calculates key portfolio risk indicators for
-- each loan issuance month.
--
-- Metrics calculated:
--
--   • Total Loans
--     Total number of loans issued in each month.
--
--   • Total Defaults
--     Number of loans that resulted in default within
--     each monthly cohort.
--
--   • Default Rate
--     Proportion of loans that defaulted within each
--     monthly cohort.
--
--         Default Rate = Total Defaults / Total Loans
--
--   • Total Exposure
--     Total loan amount issued in each month, representing
--     the portfolio exposure for that time period.
--
-- This view enables analysts to:
--   • Track credit performance over time
--   • Detect early warning signals of rising default risk
--   • Compare loan issuance volumes with default behavior
--   • Support time-series visualizations in the dashboard
--
-- The results from this view are used in the Power BI
-- dashboard to visualize monthly credit risk trends
-- and portfolio exposure dynamics.
-- ============================================================

CREATE OR REPLACE VIEW monthly_defaults AS
SELECT
    DATE_TRUNC('month', issue_date) AS month,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS total_defaults,
    SUM(default_flag)::numeric / COUNT(*) AS default_rate,
    SUM(loan_amnt) AS total_exposure
FROM loans_clean
GROUP BY DATE_TRUNC('month', issue_date)
ORDER BY month;

SELECT * FROM monthly_defaults;

