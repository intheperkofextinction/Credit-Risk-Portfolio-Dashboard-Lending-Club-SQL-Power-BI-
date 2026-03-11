-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a view that analyzes credit risk
-- metrics across different loan grades within the lending
-- portfolio. Loan grades represent borrower credit quality
-- categories and are commonly used by lenders to price risk
-- and evaluate portfolio performance.
--
-- The view aggregates loan-level data from the loans_clean
-- table and calculates key risk indicators for each grade
-- category.
--
-- The script first builds a base aggregation that summarizes
-- loan activity for each credit grade, including total loans,
-- exposure, defaults, recoveries, and net losses. These
-- values are then used to derive standard credit risk metrics.
--
-- Key metrics calculated:
--
--   • Total Loans
--     Number of loans issued within each credit grade.
--
--   • Exposure
--     Total loan amount issued for each grade, representing
--     the credit exposure to that borrower segment.
--
--   • Total Defaults
--     Number of loans that resulted in default for the grade.
--
--   • Total Recoveries
--     Amount recovered from defaulted loans through
--     collection or recovery processes.
--
--   • Probability of Default (PD)
--     Percentage of loans that defaulted within each grade.
--
--         PD = Total Defaults / Total Loans
--
--   • Loss Given Default (LGD)
--     Proportion of exposure lost after recoveries from
--     defaulted loans.
--
--         LGD = Net Loss / Exposure
--
--   • Expected Loss (EL)
--     Estimated credit loss calculated using the standard
--     credit risk formula:
--
--         Expected Loss = Exposure × PD × LGD
--
--   • Net Loss
--     Total realized loss from defaulted loans after
--     accounting for recoveries.
--
-- This view allows analysts to compare credit risk levels
-- across different borrower risk segments and identify which
-- loan grades contribute the most to portfolio losses.
--
-- The results are used in the Power BI dashboard to visualize
-- the risk distribution of the portfolio and support
-- risk-based lending insights.
-- ============================================================

CREATE VIEW risk_by_grade AS
WITH base AS (
    SELECT
        grade,

        COUNT(*)::numeric(18,2) AS total_loans,

        COALESCE(SUM(loan_amnt), 0)::numeric(18,2) AS exposure,

        COALESCE(SUM(default_flag), 0)::numeric(18,2) AS total_defaults,

        COALESCE(SUM(recoveries), 0)::numeric(18,2) AS total_recoveries,

        COALESCE(
            SUM(loan_amnt - recoveries)
            FILTER (WHERE default_flag = 1),
        0)::numeric(18,2) AS net_loss

    FROM loans_clean
    GROUP BY grade
)

SELECT
    grade,
    total_loans,
    exposure,
    total_defaults,
    total_recoveries,

    -- Probability of Default
    COALESCE(
        total_defaults / NULLIF(total_loans, 0),
    0)::numeric(10,6) AS pd,

    -- Loss Given Default
    COALESCE(
        net_loss / NULLIF(exposure, 0),
    0)::numeric(10,6) AS lgd,

    -- Expected Loss
    (
        COALESCE(total_defaults / NULLIF(total_loans, 0), 0)
        *
        COALESCE(net_loss / NULLIF(exposure, 0), 0)
        *
        exposure
    )::numeric(18,2) AS expected_loss,

    net_loss

FROM base
ORDER BY grade;


SELECT * FROM risk_by_grade;
