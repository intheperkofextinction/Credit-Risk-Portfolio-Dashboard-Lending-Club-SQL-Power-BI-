ALTER TABLE loans_clean
ALTER COLUMN loan_amnt TYPE NUMERIC USING loan_amnt::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN annual_inc TYPE NUMERIC USING annual_inc::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN total_rec_int TYPE NUMERIC USING total_rec_int::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN total_rec_prncp TYPE NUMERIC USING total_rec_prncp::NUMERIC;

ALTER TABLE loans_clean
ALTER COLUMN recoveries TYPE NUMERIC USING recoveries::NUMERIC;