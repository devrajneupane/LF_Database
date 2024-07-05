-- Create assignement4 schema
CREATE SCHEMA IF NOT EXISTS assignment4 AUTHORIZATION postgres;

-- Create employees table
CREATE TABLE IF NOT EXISTS assignment4.employees (
  employee_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  sex CHAR(1) CHECK (sex IN ('M', 'F', 'O')) NOT NULL,
  doj DATE,
  current_date_ DATE DEFAULT CURRENT_DATE NOT NULL,
  designation VARCHAR(100) NOT NULL,
  age INTEGER,
  salary NUMERIC(10, 2) CHECK (salary >= 0) NOT NULL,
  unit VARCHAR(100) NOT NULL,
  leaves_used INTEGER,
  leaves_remaining INTEGER,
  ratings NUMERIC,
  past_exp INTEGER NOT NULL
);

-- Populate employees from csv file
COPY assignment4.employees (
  first_name,
  last_name,
  sex,
  doj,
  current_date_,
  designation,
  age,
  salary,
  unit,
  leaves_used,
  leaves_remaining,
  ratings,
  past_exp
)
FROM
  '/Salary Prediction of Data Professions.csv' DELIMITER ',' CSV HEADER;

SELECT
  *
FROM
  assignment4.employees;

-- Common Table Expressions (CTEs):
-- Question 1: Calculate the average salary by department for all Analysts.
WITH
  analysts AS (
    SELECT
      unit,
      ROUND(AVG(salary), 2) AS average_salary
    FROM
      assignment4.employees
    WHERE
      designation LIKE '%Analyst'
    GROUP BY
      unit
  )
SELECT
  *
FROM
  analysts;

-- Question 2: List all employees who have used more than 10 leaves.
WITH
  employees AS (
    SELECT
      CONCAT(first_name, ' ', last_name) AS full_name,
      leaves_used
    FROM
      assignment4.employees
    WHERE
      leaves_used > 10
    ORDER BY
      leaves_used DESC
  )
SELECT
  *
FROM
  employees;

-- Views:
-- Question 3: Create a view to show the details of all Senior Analysts.
CREATE VIEW IF NOT EXISTS assignment4.senior_analysts AS
SELECT
  *
FROM
  assignment4.employees
WHERE
  designation = 'Senior Analyst';

SELECT
  *
FROM
  assignment4.senior_analysts;

-- Materialized Views:
-- Question 4: Create a materialized view to store the count of employees by department.
CREATE MATERIALIZED VIEW assignment4.employees_by_department AS
SELECT
  unit AS department,
  COUNT(employee_id) AS employees_count
FROM
  assignment4.employees
GROUP BY
  department
ORDER BY
  employees_count DESC;

SELECT
  *
FROM
  assignment4.employees_by_department;

-- Procedures (Stored Procedures):
-- Question 6: Create a procedure to update an employee's salary by their first name and last name.
CREATE
OR REPLACE PROCEDURE assignment4.update_salary (
  firstName VARCHAR,
  lastName VARCHAR,
  updatePercentage DECIMAL
) LANGUAGE PLPGSQL AS $$
BEGIN

  UPDATE
    assignment4.employees
  SET
    salary = salary + salary * updatePercentage
  WHERE
    first_name = firstName
    and last_name = lastName;

  COMMIT;

END;$$;

-- Call update_dalary procedure
CALL assignment4.update_salary ('BELLE', 'ARDS', 0.2);

SELECT
  *
FROM
  assignment4.employees e
WHERE
  e.first_name = 'BELLE'
  AND e.last_name = 'ARDS';

-- Question 7: Create a procedure to calculate the total number of leaves used across all departments.
CREATE
OR REPLACE PROCEDURE assignment4.calculate_total_leaves (
  INOUT total_leaves INT DEFAULT 0
)
LANGUAGE PLPGSQL AS $$
BEGIN

  SELECT
    sum(leaves_used)
  FROM
    assignment4.employees

  INTO total_leaves;

END;$$;

-- Call calculate_total_leaves procedure
CALL assignment4.calculate_total_leaves ();
