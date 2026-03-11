-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script supports the Credit Risk Portfolio Dashboard
-- by generating portfolio-level summary metrics and analyzing
-- the risk–return tradeoff across loan grades.
--
-- The first section creates a view called `portfolio_summary`
-- which aggregates key portfolio statistics such as:
--    • Total number of loans
--    • Total portfolio exposure (sum of loan amounts)
--    • Total interest earned from borrowers
--    • Overall portfolio default rate
--
-- These metrics provide a high-level overview of portfolio
-- performance and credit risk exposure.
--
-- The second section analyzes the risk–return relationship
-- across loan grades by calculating:
--    • Number of loans issued per grade
--    • Total exposure per grade
--    • Default rate per grade (credit risk)
--    • Return percentage based on interest income
--
-- This analysis helps identify whether higher-risk loan grades
-- provide sufficient return to compensate for higher default risk.
--
-- The output of these queries is used for portfolio monitoring
-- and is visualized in the Power BI dashboard.
-- ============================================================

---- portfolio_summary ----

CREATE VIEW portfolio_summary AS
SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS total_exposure,
    SUM(total_rec_int) AS total_interest_earned,
    ROUND(SUM(default_flag)::numeric / COUNT(*) * 100,2) AS default_rate
FROM loans_clean;


SELECT *
FROM portfolio_summary;

---- Risk-Return Tradeoff ----

SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS exposure,
    ROUND(SUM(default_flag)::numeric / COUNT(*) * 100,2) AS default_rate,
    ROUND(SUM(total_rec_int) / SUM(loan_amnt) * 100,2) AS return_pct
FROM loans_clean
GROUP BY grade

ORDER BY grade;
