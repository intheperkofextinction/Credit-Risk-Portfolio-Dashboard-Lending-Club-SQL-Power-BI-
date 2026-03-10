

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
