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