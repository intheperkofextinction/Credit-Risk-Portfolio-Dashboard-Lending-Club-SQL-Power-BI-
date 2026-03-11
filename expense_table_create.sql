-- ============================================================
-- Project: Credit Risk Portfolio Dashboard
-- Author: Amal S
-- Tool: PostgreSQL
--
-- Description:
-- This SQL script creates and populates an expenses table used
-- to simulate operational costs associated with managing the
-- lending portfolio. Since the original loan dataset does not
-- include internal operational expenses, synthetic cost data
-- is generated to enable financial performance analysis.
--
-- The script performs the following steps:
--
-- 1. Create the "expenses" table
--    - Stores departmental expense records including:
--        • expense date
--        • department responsible for the cost
--        • expense amount
--        • cost category
--
-- 2. Generate synthetic operational costs
--    - Operational expenses are estimated as a percentage of
--      the loan amount issued.
--    - In this simulation, operational cost is assumed to be
--      3% of the loan amount for each issued loan.
--    - These costs are assigned to the "Operations" department
--      and categorized as "Operational Cost".
--
-- 3. Validate the table
--    - A sample query retrieves the first few records to
--      confirm successful data generation and insertion.
--
-- Purpose of this table:
-- The expenses dataset allows the project to extend beyond
-- pure credit risk analysis and simulate basic financial
-- performance metrics such as:
--
--   • operational cost analysis
--   • profitability calculations
--   • revenue vs expense comparisons
--   • net profit estimation
--
-- This synthetic expense structure supports additional
-- analytics used in the Power BI dashboard to illustrate
-- portfolio profitability and cost efficiency.
-- ============================================================
---- Create Expenses Table ----

CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    expense_date DATE,
    department TEXT,
    amount NUMERIC,
    category TEXT
);

---- Inserting synthetic department costs ----

INSERT INTO expenses (expense_date, department, amount, category)
SELECT
    issue_date,
    'Operations',
    loan_amnt::numeric * 0.03,
    'Operational Cost'
FROM loans_clean;

---- expense table view ----

SELECT *
FROM expenses
LIMIT 10;


