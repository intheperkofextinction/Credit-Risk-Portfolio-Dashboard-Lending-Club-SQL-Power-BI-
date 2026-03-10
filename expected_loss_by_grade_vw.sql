CREATE OR REPLACE VIEW expected_loss_by_grade AS
SELECT
    grade,
    SUM(loan_amnt) AS exposure,
    COUNT(*) AS total_loans,
    SUM(default_flag)::numeric / COUNT(*) AS pd,
    CASE 
        WHEN SUM(CASE WHEN default_flag=1 THEN loan_amnt ELSE 0 END) = 0
        THEN 0
        ELSE 
            1 - (
                SUM(recoveries) /
                SUM(CASE WHEN default_flag=1 THEN loan_amnt ELSE 0 END)
            )
    END AS lgd,
    SUM(loan_amnt) *
    (SUM(default_flag)::numeric / COUNT(*)) *expected_loss_by_grade
    CASE 
        WHEN SUM(CASE WHEN default_flag=1 THEN loan_amnt ELSE 0 END) = 0
        THEN 0
        ELSE 
            1 - (
                SUM(recoveries) /
                SUM(CASE WHEN default_flag=1 THEN loan_amnt ELSE 0 END)
            )
    END AS expected_loss
FROM loans_clean
GROUP BY grade;

select * from expected_loss_by_grade;