CREATE TABLE restaurants (
    restaurant_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    restaurant_name VARCHAR(100) UNIQUE NOT NULL CHECK (LENGTH(restaurant_name) >= 5),
    restaurant_city VARCHAR(100) NOT NULL CHECK (LENGTH(restaurant_city) >= 3),
    restaurant_phone CHAR(10) UNIQUE NOT NULL CHECK (
        restaurant_phone ~ '^[6-9][0-9]{9}$'
    )
);

CREATE TABLE menus (
    menu_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    restaurant_id INTEGER NOT NULL REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    item_name VARCHAR(200) UNIQUE NOT NULL CHECK (LENGTH(item_name) >= 3),
    item_price SMALLINT NOT NULL CHECK (item_price > 0),
    UNIQUE (item_name, restaurant_id)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(100) NOT NULL CHECK (LENGTH(customer_name) >= 3),
    customer_phone CHAR(10) UNIQUE NOT NULL CHECK (
        customer_phone ~ '^[6-9][0-9]{9}$'
    )
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE CHECK (order_date = CURRENT_DATE)
);

CREATE TABLE order_items (
  order_item_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
  menu_id INTEGER NOT NULL REFERENCES menus(menu_id) ON DELETE CASCADE,
  order_quantity SMALLINT NOT NULL DEFAULT 1 CHECK (order_quantity BETWEEN 1 AND 50),
  order_item_price INTEGER NOT NULL CHECK (order_item_price > 0),
  UNIQUE (order_id, menu_id)
);

