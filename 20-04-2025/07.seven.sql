-- 3. Online Grocery Store
-- Entities: categories, products, users, carts, cart_items, orders, order_items

-- Requirements:

-- categories: category_id, category_name (unique, not null)

-- products: product_id, name (unique), category_id (FK), price (> 0), stock_quantity

-- users: user_id, username, email (unique, must contain @), phone (starts with 6–9)

-- carts: cart_id, user_id (FK), created_on (default timestamp)

-- cart_items: cart_id, product_id, quantity (1–100), composite PK (cart_id, product_id)

-- orders: order_id, user_id, order_date (default current date), status (ENUM: 'Pending', 'Shipped', 'Delivered')

-- order_items: order_id, product_id, quantity, price_at_order_time, composite PK (order_id, product_id)

-- 🛒 Constraints:

-- If stock_quantity < quantity in cart_items, should not allow insert (advanced — ideal for triggers later).

-- price_at_order_time stores product price at time of order (so price changes don’t affect past orders).


CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    category_name VARCHAR(20) UNIQUE NOT NULL CHECK (LENGTH(category_name) >= 3)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    product_name VARCHAR(70) NOT NULL UNIQUE CHECK (LENGTH(product_name) >= 3),
    category_id INTEGER REFERENCES categories(category_id) ON DELETE SET NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock_quantity SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(25) NOT NULL UNIQUE CHECK (LENGTH(username) >= 3),
    email VARCHAR(30) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0),
    phone VARCHAR(10) NOT NULL UNIQUE CHECK (
        phone ~ '^[6-9][0-9]{9}$'
    )
);

CREATE TABLE carts (
    cart_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cart_id)
);

CREATE TABLE cart_items (
    cart_id INTEGER NOT NULL REFERENCES carts(cart_id),
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    quantity SMALLINT NOT NULL CHECK (quantity BETWEEN 1 AND 100),
    PRIMARY KEY (cart_id, product_id)
);

CREATE TYPE orders_enum AS ENUM('Pending', 'Shipped', 'Delivered');

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_status orders_enum NOT NULL
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity SMALLINT NOT NULL CHECK (quantity BETWEEN 1 AND 100),
    price_at_order_time NUMERIC(10,2) NOT NULL CHECK (price_at_order_time > 0),
    PRIMARY KEY (order_id, product_id)
);