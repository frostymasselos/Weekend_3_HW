DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE films;

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(225),
  funds INT4
);

-- INSERT INTO customers (name, funds)
-- VALUES ('Ryan', 30);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(225),
  price INT4
);

-- INSERT INTO films (title, price)
-- VALUES ('the vvitch', 7);
-- INSERT INTO films (title) VALUES ('the bitch');

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT4 REFERENCES films(id)
);

-- CREATE TABLE screenings(
--   id SERIAL4 PRIMARY KEY,
--   film_id INT4 REFERENCES films(id),
--   thyme VARCHAR(225)
-- );
