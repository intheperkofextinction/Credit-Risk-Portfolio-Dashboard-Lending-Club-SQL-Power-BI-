---- CREATING customers TABLE FROM loan_raw ----

CREATE TABLE customers AS
SELECT DISTINCT
    id AS customer_id,
    addr_state AS region,
    
    CASE
        WHEN annual_inc::numeric > 100000 THEN 'Corporate'
        ELSE 'Retail'
    END AS segment
FROM loan_raw;

---- customers table view ----

SELECT *
FROM customers
LIMIT 10;

---- COUNT OF CUSTOMERS ----

SELECT COUNT(*) FROM customers;
