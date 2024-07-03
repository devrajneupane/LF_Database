-- Create assignement1 schema
CREATE SCHEMA IF NOT EXISTS assignment1 AUTHORIZATION postgres;

-- Create products table
CREATE TABLE IF NOT EXISTS assignment1.products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price INT NOT NULL
);

-- Create orders table
CREATE TABLE IF NOT EXISTS assignment1.orders (
  order_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  product_id INT REFERENCES assignment1.products (product_id),
  quantity INT DEFAULT 1,
  order_date DATE DEFAULT CURRENT_DATE
);

-- Create(Insert) Operation
-- Fill products table
INSERT INTO
  assignment1.products (product_name, category, price)
VALUES
  (
    'Product A',
    'Category A',
    floor(random () * 1000) + 1
  ),
  (
    'Product B',
    'Category B',
    floor(random () * 1000) + 1
  ),
  (
    'Product C',
    'Category A',
    floor(random () * 1000) + 1
  ),
  (
    'Product D',
    'Category C',
    floor(random () * 1000) + 1
  ),
  (
    'Product E',
    'Category B',
    floor(random () * 1000) + 1
  );

-- Fill orders table
INSERT INTO
  assignment1.orders (customer_name, product_id, quantity, order_date)
VALUES
  (
    'Customer A',
    (
      SELECT
        product_id
      FROM
        assignment1.products
      ORDER BY
        random ()
      LIMIT
        1
    ),
    2,
    CURRENT_DATE
  ),
  (
    'Customer B',
    (
      SELECT
        product_id
      FROM
        assignment1.products
      ORDER BY
        random ()
      LIMIT
        1
    ),
    1,
    CURRENT_DATE
  ),
  (
    'Customer C',
    (
      SELECT
        product_id
      FROM
        assignment1.products
      ORDER BY
        random ()
      LIMIT
        1
    ),
    3,
    CURRENT_DATE
  ),
  (
    'Customer D',
    (
      SELECT
        product_id
      FROM
        assignment1.products
      ORDER BY
        random ()
      LIMIT
        1
    ),
    2,
    CURRENT_DATE
  ),
  (
    'Customer E',
    (
      SELECT
        product_id
      FROM
        assignment1.products
      ORDER BY
        random ()
      LIMIT
        1
    ),
    5,
    CURRENT_DATE
  );

-- Read (Select) Operation
-- Select all products
SELECT
  *
FROM
  assignment1.products;

-- Select a specific product by product_id
SELECT
  *
FROM
  assignment1.products
WHERE
  product_id = 1;

-- Select all orders
SELECT
  *
FROM
  assignment1.orders;

-- Select orders for a specific customer
SELECT
  *
FROM
  assignment1.orders
WHERE
  customer_name = 'Customer A';

-- Select orders for a specific product
SELECT
  *
FROM
  assignment1.orders
WHERE
  product_id = 2;

-- Update Operation
-- Update a product
UPDATE assignment1.products
SET
  product_name = 'Updated Product',
  category = 'Updated Category',
  price = 1500
WHERE
  product_id = 1;

-- Update an order
UPDATE assignment1.orders
SET
  customer_name = 'Updated Customer',
  quantity = 4
WHERE
  order_id = 1;

-- Delete Operation
-- Delete a product
DELETE FROM assignment1.products
WHERE
  product_id = 1;

-- Delete an order
DELETE FROM assignment1.orders
WHERE
  order_id = 1;

-- Calculate the total quantity ordered for each product category in the orders table.
-- Using JOIN
SELECT
  p.category,
  SUM(o.quantity) AS total_quantity_ordered
FROM
  assignment1.orders o
  JOIN assignment1.products p ON o.product_id = p.product_id
GROUP BY
  p.category
ORDER BY
  COUNT(o.order_id) DESC;

-- Without using JOIN
SELECT
  p.category,
  SUM(o.quantity) AS total_quantity_ordered
FROM
  assignment1.products p,
  (
    SELECT
      product_id,
      order_id,
      quantity
    FROM
      assignment1.orders
  ) o
WHERE
  p.product_id = o.product_id
GROUP BY
  p.category
ORDER BY
  COUNT(order_id) DESC;

-- Find categories where the total number of products ordered is greater than 5.
-- With JOIN
SELECT
  p.category,
  SUM(o.quantity) AS total_quantity_ordered
FROM
  assignment1.orders o
  JOIN assignment1.products p ON o.product_id = p.product_id
GROUP BY
  p.category
HAVING
  SUM(o.quantity) > 5;

-- Without JOIN
SELECT
  p.category,
  (
    SELECT
      SUM(o.quantity)
    FROM
      assignment1.orders o
    WHERE
      o.product_id = p.product_id
  ) AS total_quantity_ordered
FROM
  assignment1.products p
GROUP BY
  p.category
HAVING
  (
    SELECT
      SUM(o.quantity)
    FROM
      assignment1.orders o
    WHERE
      o.product_id = p.product_id
  ) > 5;
