
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