-- ============================================================
--  Shopping Cart Schema
--  DB: MySQL / MariaDB  (adjust types for PostgreSQL if needed)
-- ============================================================
DROP DATABASE IF EXISTS shopping_cart_db;
CREATE DATABASE IF NOT EXISTS shopping_cart_db;
USE shopping_cart_db;

-- ── 1. USER ─────────────────────────────────────────────────
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)        NOT NULL,
    email         VARCHAR(150)        NOT NULL UNIQUE,
    phone         VARCHAR(20),
    created_at    TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── 2. WALLET (1-to-1 with user) ────────────────────────────
CREATE TABLE wallet (
    wallet_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT            NOT NULL UNIQUE,   -- 1-to-1
    balance    DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_wallet_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ── 3. PRODUCT / INVENTORY ──────────────────────────────────
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(200)   NOT NULL,
    price      DECIMAL(10, 2) NOT NULL,
    stock_qty  INT            NOT NULL DEFAULT 0,
    category   VARCHAR(100),
    CONSTRAINT chk_price     CHECK (price     >= 0),
    CONSTRAINT chk_stock_qty CHECK (stock_qty >= 0)
);

-- ── 4. CART ──────────────────────────────────────────────────
--  status: ACTIVE | CHECKED_OUT
CREATE TABLE cart (
    cart_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT         NOT NULL,
    status     ENUM('ACTIVE', 'CHECKED_OUT') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ── 5. CART ITEM ─────────────────────────────────────────────
CREATE TABLE cart_item (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id      INT NOT NULL,
    product_id   INT NOT NULL,
    quantity     INT NOT NULL,
    CONSTRAINT fk_ci_cart    FOREIGN KEY (cart_id)    REFERENCES cart(cart_id),
    CONSTRAINT fk_ci_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT uq_cart_product UNIQUE (cart_id, product_id),   -- one row per product per cart
    CONSTRAINT chk_qty CHECK (quantity > 0)
);

-- ── 6. BILL (composition root; one per checkout) ────────────
CREATE TABLE bill (
    bill_id      INT AUTO_INCREMENT PRIMARY KEY,
    cart_id      INT            NOT NULL UNIQUE,   -- 1 cart → 1 bill
    user_id      INT            NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    billed_at    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bill_cart FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
    CONSTRAINT fk_bill_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ── 7. BILL ITEM (composition child; one per product line) ───
CREATE TABLE bill_item (
    bill_item_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id      INT            NOT NULL,
    product_id   INT            NOT NULL,
    product_name VARCHAR(200)   NOT NULL,   -- snapshot (price may change later)
    quantity     INT            NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL,
    line_total   DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    CONSTRAINT fk_bi_bill    FOREIGN KEY (bill_id)    REFERENCES bill(bill_id),
    CONSTRAINT fk_bi_product FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- ── SEED DATA ────────────────────────────────────────────────
INSERT INTO users (name, email, phone) VALUES
  ('Alice Sharma',  'alice@example.com', '9876543210'),
  ('Bob Patel',     'bob@example.com',   '9123456780');

INSERT INTO wallet (user_id, balance) VALUES
  (1, 100000.00),
  (2,  10000.00);

INSERT INTO product (name, price, stock_qty, category) VALUES
  ('Laptop Pro 15',    75000.00,  5, 'Electronics'),
  ('Wireless Mouse',    1200.00, 20, 'Electronics'),
  ('USB-C Hub',         2500.00, 15, 'Electronics'),
  ('Desk Lamp',          800.00, 30, 'Furniture'),
  ('Coffee Mug',         250.00, 50, 'Kitchen');
