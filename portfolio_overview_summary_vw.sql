-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a summary view that provides a
-- high-level overview of the entire loan portfolio’s
-- credit risk exposure and performance.
--
-- The purpose of this view is to consolidate key portfolio
-- metrics into a single aggregated dataset that can be used
-- for executive-level reporting and dashboard KPI cards.
--
-- The view aggregates loan-level data from the loans_clean
-- table and calculates core credit risk indicators commonly
-- used in lending portfolio analysis.
--
-- Key metrics calculated:
--
--   • Total Loans
--     Total number of loans issued in the portfolio.
--
--   • Total Exposure
--     Total loan amount issued across all borrowers,
--     representing the overall portfolio exposure.
--
--   • Total Defaults
--     Number of loans that resulted in default.
--
--   • Total Recoveries
--     Amount recovered from defaulted loans through
--     collections or recovery processes.
--
--   • Default Rate (Probability of Default - PD)
--     Percentage of loans in the portfolio that defaulted.
--
--         PD = Total Defaults / Total Loans
--
--   • Loss Given Default (LGD)
--     Proportion of defaulted exposure that was not
--     recovered after collections.
--
--         LGD = Net Loss / Defaulted Exposure
--
--   • Expected Loss (EL)
--     Estimated credit loss calculated using the
--     standard credit risk formula:
--
--         Expected Loss = Exposure × PD × LGD
--
--   • Net Loss
--     Actual realized loss from defaulted loans after
--     accounting for recoveries.
--
-- This view serves as a portfolio-level summary used in the
-- Power BI dashboard to present key risk indicators such as
-- total exposure, default rate, expected loss, and realized
-- losses. These metrics help stakeholders quickly assess the
-- overall health and risk profile of the lending portfolio.
-- ============================================================

CREATE OR REPLACE VIEW portfolio_overview_summary AS
WITH base AS (
    SELECT
        COUNT(*) AS total_loans,
        SUM(loan_amnt) AS total_exposure,
        SUM(default_flag) AS total_defaults,
        SUM(recoveries) AS total_recoveries,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1) AS net_loss,
        SUM(default_flag)::numeric / COUNT(*) AS pd,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1)
            / SUM(loan_amnt) FILTER (WHERE default_flag=1) AS lgd
    FROM loans_clean
)
SELECT
    total_loans,
    total_exposure,
    total_defaults,
    total_recoveries,
    pd AS default_rate,
    lgd,
    pd * lgd * total_exposure AS expected_loss,
    net_loss
FROM base;

SELECT * FROM portfolio_overview_summary;
