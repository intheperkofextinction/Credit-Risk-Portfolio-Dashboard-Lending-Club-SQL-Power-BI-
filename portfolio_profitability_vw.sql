-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a view that evaluates the overall
-- profitability of the lending portfolio. The purpose of this
-- analysis is to measure how much income the portfolio
-- generates relative to the amount of capital disbursed
-- through loans.
--
-- The view aggregates loan-level financial data from the
-- loans_clean table and calculates key portfolio-level
-- profitability metrics.
--
-- Key metrics calculated:
--
--   • Total Loans
--     Total number of loans issued within the portfolio.
--
--   • Total Disbursed
--     Total amount of loan capital issued to borrowers.
--     This represents the total lending exposure.
--
--   • Total Collected
--     Total amount of payments received from borrowers,
--     including both principal and interest repayments.
--
--   • Net Profit
--     Total earnings generated from the portfolio after
--     subtracting the total loan capital disbursed.
--
--         Net Profit = Total Collected − Total Disbursed
--
--   • Profit Margin
--     Measures the profitability of the lending portfolio
--     relative to the total capital deployed.
--
--         Profit Margin = Net Profit / Total Disbursed
--
-- This view provides a simplified financial performance
-- perspective of the lending portfolio and complements the
-- credit risk analysis performed in other project views.
--
-- The results from this view can be used in dashboards or
-- financial reports to illustrate portfolio profitability,
-- capital efficiency, and overall lending performance.
-- ============================================================

DROP VIEW IF EXISTS portfolio_profitability;


CREATE VIEW portfolio_profitability AS
SELECT
    COUNT(*)::numeric(18,2) AS total_loans,

    COALESCE(SUM(loan_amnt::numeric),0)::numeric(18,2) AS total_disbursed,

    COALESCE(SUM(total_pymnt::numeric),0)::numeric(18,2) AS total_collected,

    COALESCE(
        SUM(total_pymnt::numeric) - SUM(loan_amnt::numeric),
    0)::numeric(18,2) AS net_profit,

    COALESCE(
        (SUM(total_pymnt::numeric) - SUM(loan_amnt::numeric))
        /
        NULLIF(SUM(loan_amnt::numeric),0),
    0)::numeric(10,6) AS profit_margin

FROM loans_clean;

select * from portfolio_profitability

