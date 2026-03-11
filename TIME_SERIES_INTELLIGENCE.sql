
-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script analyzes the trend of loan defaults over time
-- to monitor portfolio credit risk and identify potential
-- deterioration in loan performance.
--
-- The first query calculates the monthly default rate by
-- aggregating loans issued each month and measuring the
-- proportion of loans that resulted in default.
--
-- The second query calculates a rolling 3-month average
-- default rate using a window function. This smoothing
-- technique reduces short-term volatility and helps
-- highlight underlying trends in credit risk.
--
-- Key metrics generated:
--    • Monthly loan volume
--    • Monthly default rate (%)
--    • Rolling 3-month default rate (%)
--
-- These metrics are commonly used in credit risk monitoring
-- to detect early warning signals of increasing default risk
-- within a lending portfolio.
-- ============================================================

--- Monthly Default Trend ----

SELECT
    DATE_TRUNC('month', issue_date) AS month,
    COUNT(*) AS total_loans,
    ROUND(SUM(default_flag)::numeric / COUNT(*) * 100,2) AS default_rate
FROM loans_clean
GROUP BY 1
ORDER BY 1;

---- Rolling 3-Month Default Rate ----

SELECT
    month,
    ROUND(
        AVG(default_rate) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),2
    ) AS rolling_3m_default_rate
FROM (
    SELECT
        DATE_TRUNC('month', issue_date) AS month,
        SUM(default_flag)::numeric / COUNT(*) * 100 AS default_rate
    FROM loans_clean
    GROUP BY 1

) t;
