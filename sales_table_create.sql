---- Create Sales Table ----

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id TEXT,
    product_category TEXT,
    revenue NUMERIC,
    region TEXT
);

---- simulate company revenue generated from customers ----

INSERT INTO sales (sale_date, customer_id, product_category, revenue, region)
SELECT
    issue_date,
    id::text,
    purpose,
    loan_amnt::numeric * 0.1,
    addr_state
FROM loans_clean;

---- Sales table view ----

SELECT *
FROM sales
LIMIT 10;