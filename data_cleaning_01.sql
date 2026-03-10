-----CREATING TABLE AS loan_clean for cleaning and analysis -----

CREATE TABLE loans_clean AS
SELECT
    id,
    TO_DATE(issue_d, 'Mon-YYYY') AS issue_date,
    loan_amnt,
    CAST(REPLACE(int_rate, '%', '') AS NUMERIC) AS interest_rate,
    installment,
    term,
    grade,
    sub_grade,
    annual_inc,
    home_ownership,
    verification_status,
    emp_length,
    purpose,
    addr_state,
    dti,
    loan_status,
    total_pymnt,
    total_rec_prncp,
    total_rec_int,
    recoveries,
    collection_recovery_fee,
    last_pymnt_amnt,

    CASE 
        WHEN loan_status IN ('Charged Off', 'Default') THEN 1
        ELSE 0
    END AS default_flag

FROM loan_raw;

--- COUNT OF ROWS ---

SELECT COUNT(*) FROM loans_clean;

---- loan_status type----

SELECT DISTINCT loan_status FROM loans_clean;

---- DEFAULT STATUS ----
SELECT 
    COUNT(*) AS total_loans,
    SUM(default_flag) AS total_defaults,
    ROUND(SUM(default_flag)::numeric / COUNT(*) * 100, 2) AS default_rate
FROM loans_clean;