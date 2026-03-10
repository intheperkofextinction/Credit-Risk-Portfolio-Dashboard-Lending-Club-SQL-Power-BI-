CREATE VIEW monthly_risk_trend AS
WITH base AS (
    SELECT
        DATE_TRUNC('month', issue_date) AS month,
        COUNT(*)::numeric(18,2) AS total_loans,
        COALESCE(SUM(loan_amnt), 0)::numeric(18,2) AS exposure,
        COALESCE(SUM(default_flag), 0)::numeric(18,2) AS total_defaults,
        COALESCE(SUM(recoveries), 0)::numeric(18,2) AS total_recoveries,
        COALESCE(
            SUM(loan_amnt - recoveries)
            FILTER (WHERE default_flag = 1),
        0)::numeric(18,2) AS net_loss
    FROM loans_clean
    GROUP BY DATE_TRUNC('month', issue_date)
)

SELECT
    month,
    total_loans,
    exposure,
    total_defaults,
    total_recoveries,

    -- PD
    COALESCE(
        total_defaults / NULLIF(total_loans, 0),
    0)::numeric(10,6) AS pd,

    -- LGD
    COALESCE(
        net_loss / NULLIF(exposure, 0),
    0)::numeric(10,6) AS lgd,

    -- Expected Loss
    (
        COALESCE(total_defaults / NULLIF(total_loans, 0), 0)
        *
        COALESCE(net_loss / NULLIF(exposure, 0), 0)
        *
        exposure
    )::numeric(18,2) AS expected_loss,

    net_loss

FROM base
ORDER BY month;


SELECT * FROM monthly_risk_trend;