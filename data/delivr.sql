DROP TABLE IF EXISTS "meals";
CREATE TABLE meals (
  meal_id INT,
  eatery TEXT,
  meal_price FLOAT,
  meal_cost FLOAT
);

DROP TABLE IF EXISTS "orders";
CREATE TABLE orders (
  order_date DATE,
  user_id INT,
  order_id INT,
  meal_id INT,
  order_quantity INT
);

DROP TABLE IF EXISTS "stock";
CREATE TABLE stock (
  stocking_date DATE,
  meal_id INT,
  stocked_quantity INT
);