---- Calculating Recovery Rate ----

SELECT
    SUM(recoveries) / 
    SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
    AS recovery_rate
FROM loans_clean;

---- Expected Loss by Grade ----

SELECT
    grade,
    SUM(loan_amnt) AS exposure,
    SUM(default_flag)::numeric / COUNT(*) AS pd,
    (1 - (SUM(recoveries) / 
        SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
     )) AS lgd,
    SUM(loan_amnt) *
    (SUM(default_flag)::numeric / COUNT(*)) *
    (1 - (SUM(recoveries) / 
        SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END)
     )) AS expected_loss
FROM loans_clean
GROUP BY grade;