-- Tạo database nếu chưa có
CREATE DATABASE IF NOT EXISTS bakery_db;
USE bakery_db;

/* =========================================================
   1. CREATE TABLES
   ========================================================= */

-- CATEGORY
CREATE TABLE IF NOT EXISTS Category (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nameC       VARCHAR(100) NOT NULL,
    parent_id   BIGINT NULL,
    FOREIGN KEY (parent_id) REFERENCES Category(category_id)
);

-- PRODUCT
CREATE TABLE IF NOT EXISTS Product (
    product_id  BIGINT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(200) NOT NULL,
    price       DECIMAL(18,2) NOT NULL,
    is_active   BIT NOT NULL DEFAULT 1,
    category_id BIGINT NOT NULL,
    image       VARCHAR(255) NULL, -- Thêm cột ảnh để hiện thị trên web
    description TEXT NULL,         -- Thêm mô tả cho trang chi tiết
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- CUSTOMER
CREATE TABLE IF NOT EXISTS Customer (
    customer_id  BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL,
    phone_number VARCHAR(20)  NOT NULL
);

-- ADMIN
CREATE TABLE IF NOT EXISTS Admin (
    admin_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_nameAD    VARCHAR(100) NOT NULL,
    emailAD        VARCHAR(150) NOT NULL,
    phoneAD_number VARCHAR(20)  NOT NULL
);

-- VOUCHER
CREATE TABLE IF NOT EXISTS Voucher (
    voucher_id  BIGINT PRIMARY KEY AUTO_INCREMENT,
    type        VARCHAR(50) NOT NULL,
    code        VARCHAR(50) NOT NULL,
    value       INT NOT NULL,
    start_at    DATETIME NOT NULL,
    end_at      DATETIME NOT NULL,
    customer_id BIGINT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- ORDER (MySQL dùng dấu backtick cho từ khóa Order)
CREATE TABLE IF NOT EXISTS `Orders` (
    order_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id    BIGINT NOT NULL,
    product_id     BIGINT NOT NULL,
    unit_price     DECIMAL(18,2) NOT NULL,
    order_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status         VARCHAR(50) NOT NULL,
    voucher_id     BIGINT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id)
);

-- PAYMENT
CREATE TABLE IF NOT EXISTS Payment (
    payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id   BIGINT NOT NULL,
    method     VARCHAR(50) NOT NULL,
    amount     DECIMAL(18,2) NOT NULL,
    paid_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES `Orders`(order_id)
);

-- DELIVERY
CREATE TABLE IF NOT EXISTS Delivery (
    delivery_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id       BIGINT NOT NULL,
    admin_id       BIGINT NOT NULL,
    phoneAD_number VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `Orders`(order_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
);

-- REVIEW
CREATE TABLE IF NOT EXISTS Review (
    review_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    rating      INT NOT NULL,
    product_id  BIGINT NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- ADMIN ACCOUNT
CREATE TABLE IF NOT EXISTS AdminAccount (
    account_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
    admin_id     BIGINT NOT NULL,
    login_email  VARCHAR(150) NULL,
    login_phone  VARCHAR(20)  NULL,
    password     VARCHAR(255) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
    UNIQUE (login_email),
    UNIQUE (login_phone)
);

/* =========================================================
   2. INSERT DATA
   ========================================================= */

INSERT INTO Category (nameC, parent_id) VALUES 
('Cakes', NULL);

INSERT INTO Product (name, price, is_active, category_id, image, description) VALUES 
('Strawberry cherry blossom', 625000, 1, 1, 'pic/strawberry cherry.png', 'Delicate floral notes with fresh strawberries'),
('Tiramisu De Caramel',       625000, 1, 1, 'pic/tira cara.png', 'Coffee cake base with soft Mascarpone'),
('Passion Fruit',             625000, 1, 1, 'pic/passion furit.jpg', 'Light and refreshing sour taste'),
('Mango Coconut',             625000, 1, 1, 'pic/mango coccont.jpg', 'Tropical flavor combination'),
('Creamy Choco',              625000, 1, 1, 'pic/cream choco.jpg', 'Rich chocolate sponge cake'),
('Berry Fruit Vanilla',       625000, 1, 1, 'pic/berry.jpg', 'Soft sponge cake with Berries');

INSERT INTO Customer (full_name, email, phone_number) VALUES 
('Trang Nguyen', 'trangnguyen@gmail.com', '0356379834'),
('Duy Phung', 'duyphung47@gmail.com', '0386736592'),
('Chi Pham', 'hachi03@gmail.com', '0375898462');

INSERT INTO Admin (full_nameAD, emailAD, phoneAD_number) VALUES 
('Huyen My', 'huyenmy.admin@hamtpastry.com', '0900000001');

INSERT INTO AdminAccount (admin_id, login_email, login_phone, password) VALUES 
(1, 'huyenmy.admin@hamtpastry.com', '0900000001', 'admin123');