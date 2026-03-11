-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a view that analyzes the evolution
-- of credit risk metrics across the loan portfolio on a
-- monthly basis. The purpose of this analysis is to monitor
-- changes in portfolio risk over time and quantify potential
-- credit losses.
--
-- The view aggregates loan-level data from the loans_clean
-- table and computes key credit risk indicators for each
-- loan issuance month.
--
-- The script first builds a base aggregation containing
-- monthly portfolio statistics, including loan counts,
-- total exposure, default counts, recoveries, and net losses.
-- These aggregated metrics are then used to derive standard
-- credit risk measures.
--
-- Key metrics calculated:
--
--   • Total Loans
--     Number of loans issued within each month.
--
--   • Exposure
--     Total loan amount issued during the month,
--     representing portfolio exposure.
--
--   • Total Defaults
--     Number of loans that resulted in default.
--
--   • Total Recoveries
--     Amount recovered from defaulted loans through
--     collections or recovery efforts.
--
--   • Probability of Default (PD)
--     Percentage of loans that defaulted during
--     the period.
--
--         PD = Total Defaults / Total Loans
--
--   • Loss Given Default (LGD)
--     Proportion of exposure lost after recoveries
--     from defaulted loans.
--
--         LGD = Net Loss / Exposure
--
--   • Expected Loss (EL)
--     Estimated credit loss calculated using the
--     standard credit risk formula:
--
--         Expected Loss = Exposure × PD × LGD
--
--   • Net Loss
--     Total loss amount from defaulted loans after
--     accounting for recoveries.
--
-- This view provides a time-series risk perspective that
-- helps analysts identify trends in credit performance,
-- detect deterioration in loan quality, and support
-- risk monitoring dashboards.
--
-- The results of this view are used in the Power BI
-- dashboard to visualize portfolio risk trends and
-- expected loss dynamics over time.
-- ============================================================

CREATE VIEW monthly_risk_trend AS
WITH base AS (
    SELECT
        DATE_TRUNC('month', issue_date) AS month,
        COUNT(*)::numeric(18,2) AS total_loans,
        COALESCE(SUM(loan_amnt), 0)::numeric(18,2) AS exposure,
        COALESCE(SUM(default_flag), 0)::numeric(18,2) AS total_defaults,
        COALESCE(SUM(recoveries), 0)::numeric(18,2) AS total_recoveries,
        COALESCE(
            SUM(loan_amnt - recoveries)
            FILTER (WHERE default_flag = 1),
        0)::numeric(18,2) AS net_loss
    FROM loans_clean
    GROUP BY DATE_TRUNC('month', issue_date)
)

SELECT
    month,
    total_loans,
    exposure,
    total_defaults,
    total_recoveries,

    -- PD
    COALESCE(
        total_defaults / NULLIF(total_loans, 0),
    0)::numeric(10,6) AS pd,

    -- LGD
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
ORDER BY month;



SELECT * FROM monthly_risk_trend;
