CREATE OR REPLACE VIEW capital_adequacy_summary AS
WITH base AS (
    SELECT
        COALESCE(SUM(loan_amnt), 0)::numeric(18,2) AS total_exposure,
        COALESCE(SUM(default_flag), 0)::numeric(18,2) AS total_defaults,
        COALESCE(SUM(recoveries), 0)::numeric(18,2) AS total_recoveries,
        COALESCE(
            SUM(loan_amnt - recoveries)
            FILTER (WHERE default_flag = 1),
        0)::numeric(18,2) AS net_loss,
        COUNT(*)::numeric(18,2) AS total_loans
    FROM loans_clean
),
risk_calc AS (
    SELECT
        total_exposure,

        -- Probability of Default
        COALESCE(
            total_defaults / NULLIF(total_loans, 0),
        0)::numeric(10,6) AS pd,

        -- Loss Given Default
        COALESCE(
            net_loss / NULLIF(total_exposure, 0),
        0)::numeric(10,6) AS lgd,

        net_loss
    FROM base
)

SELECT
    total_exposure,
    pd,
    lgd,

    -- Expected Loss
    (pd * lgd * total_exposure)::numeric(18,2) AS expected_loss,

    net_loss,

    -- 10% Capital Buffer
    (total_exposure * 0.10)::numeric(18,2) AS capital_buffer,

    -- Capital Ratio
    0.10::numeric(5,2) AS capital_ratio,

    -- Remaining Capital After EL
    ((total_exposure * 0.10) -
     (pd * lgd * total_exposure)
    )::numeric(18,2) AS capital_after_expected_loss

FROM risk_calc;

SELECT * FROM capital_adequacy_summary;

