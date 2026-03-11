-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates a view that estimates Expected Credit
-- Loss (ECL) for the loan portfolio segmented by credit grade.
--
-- The objective of this analysis is to quantify potential
-- credit risk exposure and identify which loan grades
-- contribute the most to potential portfolio losses.
--
-- The view aggregates loan-level data from the loans_clean
-- table and calculates key credit risk metrics commonly used
-- in financial risk management.
--
-- Risk metrics calculated:
--
--   • Exposure
--     Total loan amount issued within each credit grade.
--
--   • Total Loans
--     Number of loans within each credit grade segment.
--
--   • Probability of Default (PD)
--     Percentage of loans that resulted in default within
--     each grade category.
--
--   • Loss Given Default (LGD)
--     Proportion of exposure lost after accounting for
--     recoveries from defaulted loans.
--
--   • Expected Loss (EL)
--     Estimated credit loss calculated using the formula:
--
--         Expected Loss = Exposure × PD × LGD
--
-- This metric is widely used in banking and credit risk
-- management to estimate potential losses in lending
-- portfolios and support capital planning decisions.
--
-- The resulting view allows analysts to:
--   • Compare risk across loan grades
--   • Identify high-risk segments of the portfolio
--   • Support risk-adjusted lending strategies
--   • Provide inputs for dashboard visualizations
--
-- The results of this view are used in the Power BI dashboard
-- to illustrate the relationship between loan quality,
-- exposure, and expected portfolio losses.
-- ============================================================

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
