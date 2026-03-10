CREATE OR REPLACE VIEW portfolio_overview_summary AS
WITH base AS (
    SELECT
        COUNT(*) AS total_loans,
        SUM(loan_amnt) AS total_exposure,
        SUM(default_flag) AS total_defaults,
        SUM(recoveries) AS total_recoveries,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1) AS net_loss,
        SUM(default_flag)::numeric / COUNT(*) AS pd,
        SUM(loan_amnt - recoveries) FILTER (WHERE default_flag=1)
            / SUM(loan_amnt) FILTER (WHERE default_flag=1) AS lgd
    FROM loans_clean
)
SELECT
    total_loans,
    total_exposure,
    total_defaults,
    total_recoveries,
    pd AS default_rate,
    lgd,
    pd * lgd * total_exposure AS expected_loss,
    net_loss
FROM base;

SELECT * FROM portfolio_overview_summary;