---- RISK-ADJUSTED RETURN (Return − Expected Loss) ----

SELECT
    SUM(total_rec_int) -
    SUM(loan_amnt * default_flag) AS risk_adjusted_return
FROM loans_clean;