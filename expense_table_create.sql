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

