DROP VIEW IF EXISTS portfolio_profitability;


CREATE VIEW portfolio_profitability AS
SELECT
    COUNT(*)::numeric(18,2) AS total_loans,

    COALESCE(SUM(loan_amnt::numeric),0)::numeric(18,2) AS total_disbursed,

    COALESCE(SUM(total_pymnt::numeric),0)::numeric(18,2) AS total_collected,

    COALESCE(
        SUM(total_pymnt::numeric) - SUM(loan_amnt::numeric),
    0)::numeric(18,2) AS net_profit,

    COALESCE(
        (SUM(total_pymnt::numeric) - SUM(loan_amnt::numeric))
        /
        NULLIF(SUM(loan_amnt::numeric),0),
    0)::numeric(10,6) AS profit_margin

FROM loans_clean;

select * from portfolio_profitability
