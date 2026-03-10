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