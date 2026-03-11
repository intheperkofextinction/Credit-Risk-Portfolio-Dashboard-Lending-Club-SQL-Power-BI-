
-- ============================================================
-- Project: Financial Performance & Profitability Analysis
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script performs monthly financial performance analysis
-- by combining revenue and expense data to evaluate profitability
-- trends over time.
--
-- The first query calculates monthly net profit by aggregating
-- total revenue from the sales table and total operating expenses
-- from the expenses table. The results provide insight into how
-- much profit the business generates each month.
--
-- The second query measures operational efficiency by calculating
-- the expense-to-revenue ratio for each month. This metric shows
-- what percentage of revenue is consumed by expenses and helps
-- assess cost management performance.
--
-- Key metrics produced in this script:
--    • Monthly Revenue
--    • Monthly Expenses
--    • Net Profit
--    • Expense-to-Revenue Ratio (%)
--
-- These outputs can be used in dashboards or financial reports
-- to track profitability trends and support business decision-making.
-- ============================================================

---- Monthly Net Profit ----

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY 1
),
monthly_expenses AS (
    SELECT 
        DATE_TRUNC('month', expense_date) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    GROUP BY 1
)

SELECT 
    s.month,
    s.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    s.total_revenue - COALESCE(e.total_expense, 0) AS net_profit
FROM monthly_sales s
LEFT JOIN monthly_expenses e
    ON s.month = e.month
ORDER BY s.month;


---- Expense as % of Revenue ----

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY 1
),
monthly_expenses AS (
    SELECT 
        DATE_TRUNC('month', expense_date) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    GROUP BY 1
)

SELECT 
    s.month,
    s.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    ROUND(
        COALESCE(e.total_expense, 0) / s.total_revenue * 100,
        2
    ) AS expense_ratio
FROM monthly_sales s
LEFT JOIN monthly_expenses e
    ON s.month = e.month

ORDER BY s.month;
