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

