WITH risk AS (
    SELECT
        SUM(default_flag)::numeric / COUNT(*) AS pd,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1)
            / SUM(loan_amnt) FILTER (WHERE default_flag=1) AS lgd,
        SUM(loan_amnt) AS exposure
    FROM loans_clean
)

SELECT
    pd,
    lgd,
    exposure,
    pd * lgd * exposure AS base_expected_loss,
    (pd + 0.03) * lgd * exposure AS stressed_expected_loss,
    ((pd + 0.03) * lgd * exposure) - (pd * lgd * exposure)
        AS incremental_loss
FROM risk;