/* =========================
   0) Create schema if needed
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'HAMT_SHOP')
BEGIN
    EXEC('CREATE SCHEMA HAMT_SHOP');
END
GO

/* =========================
   1) DROP TABLES (đúng thứ tự để không vướng FK)
========================= */
DROP TABLE IF EXISTS HAMT_SHOP.REVIEW;
DROP TABLE IF EXISTS HAMT_SHOP.DELIVERY;
DROP TABLE IF EXISTS HAMT_SHOP.VOUCHER_REDEMPTION;
DROP TABLE IF EXISTS HAMT_SHOP.ORDER_ITEM;
DROP TABLE IF EXISTS HAMT_SHOP.PAYMENT;            -- nếu bạn có bảng này sau này
DROP TABLE IF EXISTS HAMT_SHOP.ORDERS;
DROP TABLE IF EXISTS HAMT_SHOP.PRODUCT_IMAGE;
DROP TABLE IF EXISTS HAMT_SHOP.PRODUCT;
DROP TABLE IF EXISTS HAMT_SHOP.CATEGORY;
DROP TABLE IF EXISTS HAMT_SHOP.MEMBERSHIP;
DROP TABLE IF EXISTS HAMT_SHOP.VOUCHER;
DROP TABLE IF EXISTS HAMT_SHOP.CUSTOMER;
DROP TABLE IF EXISTS HAMT_SHOP.ADMINS;
GO

/* =========================
   2) CREATE TABLES
========================= */

-- 1. ADMINS
CREATE TABLE HAMT_SHOP.ADMINS (
    admin_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    role VARCHAR(20) CHECK (role IN ('manager', 'staff')),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. CUSTOMER
CREATE TABLE HAMT_SHOP.CUSTOMER (
    customer_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 3. MEMBERSHIP
CREATE TABLE HAMT_SHOP.MEMBERSHIP (
    membership_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL UNIQUE,
    rank_level NVARCHAR(50) DEFAULT N'Đồng',
    total_spending DECIMAL(18, 2) DEFAULT 0,
    assigned_by_admin BIGINT,
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Membership_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Membership_Admin FOREIGN KEY (assigned_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 4. CATEGORY
CREATE TABLE HAMT_SHOP.CATEGORY (
    category_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    parent_id BIGINT NULL,
    created_by_admin BIGINT,
    CONSTRAINT FK_Category_Parent FOREIGN KEY (parent_id)
        REFERENCES HAMT_SHOP.CATEGORY(category_id),
    CONSTRAINT FK_Category_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 5. PRODUCT
CREATE TABLE HAMT_SHOP.PRODUCT (
    product_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(18, 2) NOT NULL CHECK (price >= 0),
    is_active BIT DEFAULT 1,
    category_id BIGINT,
    created_by_admin BIGINT,
    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id)
        REFERENCES HAMT_SHOP.CATEGORY(category_id),
    CONSTRAINT FK_Product_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 6. PRODUCT_IMAGE
CREATE TABLE HAMT_SHOP.PRODUCT_IMAGE (
    image_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BIT DEFAULT 0,
    CONSTRAINT FK_Image_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id) ON DELETE CASCADE
);
GO

-- 7. VOUCHER
CREATE TABLE HAMT_SHOP.VOUCHER (
    voucher_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    discount_type VARCHAR(20) CHECK (discount_type IN ('percent', 'fixed')),
    discount_value DECIMAL(18, 2) NOT NULL,
    min_order_value DECIMAL(18, 2) DEFAULT 0,
    max_discount DECIMAL(18, 2),
    usage_limit INT DEFAULT 1,
    start_at DATETIME,
    end_at DATETIME,
    is_active BIT DEFAULT 1,
    created_by_admin BIGINT,
    CONSTRAINT FK_Voucher_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 8. ORDERS
CREATE TABLE HAMT_SHOP.ORDERS (
    order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_datetime DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    subtotal DECIMAL(18, 2) NOT NULL,
    shipping_fee DECIMAL(18, 2) DEFAULT 0,
    discount_amount DECIMAL(18, 2) DEFAULT 0,
    total_amount AS (subtotal + shipping_fee - discount_amount),
    voucher_id BIGINT NULL,
    CONSTRAINT FK_Order_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Order_Voucher FOREIGN KEY (voucher_id)
        REFERENCES HAMT_SHOP.VOUCHER(voucher_id)
);
GO

-- 9. ORDER_ITEM
CREATE TABLE HAMT_SHOP.ORDER_ITEM (
    item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_time DECIMAL(18, 2) NOT NULL,
    line_total AS (quantity * unit_price_at_time),
    CONSTRAINT FK_Item_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id),
    CONSTRAINT FK_Item_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id)
);
GO

-- 10. VOUCHER_REDEMPTION
CREATE TABLE HAMT_SHOP.VOUCHER_REDEMPTION (
    redemption_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    voucher_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    redeemed_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Redeem_Voucher FOREIGN KEY (voucher_id)
        REFERENCES HAMT_SHOP.VOUCHER(voucher_id),
    CONSTRAINT FK_Redeem_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Redeem_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id)
);
GO

-- 11. DELIVERY
CREATE TABLE HAMT_SHOP.DELIVERY (
    delivery_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    admin_id BIGINT,
    receiver_name NVARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    shipping_address NVARCHAR(500) NOT NULL,
    shipping_status VARCHAR(20) CHECK (shipping_status IN ('preparing', 'shipping', 'delivered', 'returned')),
    estimated_arrival DATETIME,
    CONSTRAINT FK_Delivery_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id),
    CONSTRAINT FK_Delivery_Admin FOREIGN KEY (admin_id)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 12. REVIEW
CREATE TABLE HAMT_SHOP.REVIEW (
    review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL UNIQUE,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Review_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id),
    CONSTRAINT FK_Review_Item FOREIGN KEY (order_item_id)
        REFERENCES HAMT_SHOP.ORDER_ITEM(item_id)
);
GO
/* =========================
   0) Create schema if needed
========================= */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'HAMT_SHOP')
BEGIN
    EXEC('CREATE SCHEMA HAMT_SHOP');
END
GO

/* =========================
   1) DROP TABLES (đúng thứ tự để không vướng FK)
========================= */
DROP TABLE IF EXISTS HAMT_SHOP.REVIEW;
DROP TABLE IF EXISTS HAMT_SHOP.DELIVERY;
DROP TABLE IF EXISTS HAMT_SHOP.VOUCHER_REDEMPTION;
DROP TABLE IF EXISTS HAMT_SHOP.ORDER_ITEM;
DROP TABLE IF EXISTS HAMT_SHOP.PAYMENT;            -- nếu bạn có bảng này sau này
DROP TABLE IF EXISTS HAMT_SHOP.ORDERS;
DROP TABLE IF EXISTS HAMT_SHOP.PRODUCT_IMAGE;
DROP TABLE IF EXISTS HAMT_SHOP.PRODUCT;
DROP TABLE IF EXISTS HAMT_SHOP.CATEGORY;
DROP TABLE IF EXISTS HAMT_SHOP.MEMBERSHIP;
DROP TABLE IF EXISTS HAMT_SHOP.VOUCHER;
DROP TABLE IF EXISTS HAMT_SHOP.CUSTOMER;
DROP TABLE IF EXISTS HAMT_SHOP.ADMINS;
GO

/* =========================
   2) CREATE TABLES
========================= */

-- 1. ADMINS
CREATE TABLE HAMT_SHOP.ADMINS (
    admin_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    role VARCHAR(20) CHECK (role IN ('manager', 'staff')),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. CUSTOMER
CREATE TABLE HAMT_SHOP.CUSTOMER (
    customer_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 3. MEMBERSHIP
CREATE TABLE HAMT_SHOP.MEMBERSHIP (
    membership_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL UNIQUE,
    rank_level NVARCHAR(50) DEFAULT N'Đồng',
    total_spending DECIMAL(18, 2) DEFAULT 0,
    assigned_by_admin BIGINT,
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Membership_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Membership_Admin FOREIGN KEY (assigned_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 4. CATEGORY
CREATE TABLE HAMT_SHOP.CATEGORY (
    category_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    parent_id BIGINT NULL,
    created_by_admin BIGINT,
    CONSTRAINT FK_Category_Parent FOREIGN KEY (parent_id)
        REFERENCES HAMT_SHOP.CATEGORY(category_id),
    CONSTRAINT FK_Category_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 5. PRODUCT
CREATE TABLE HAMT_SHOP.PRODUCT (
    product_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(18, 2) NOT NULL CHECK (price >= 0),
    is_active BIT DEFAULT 1,
    category_id BIGINT,
    created_by_admin BIGINT,
    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id)
        REFERENCES HAMT_SHOP.CATEGORY(category_id),
    CONSTRAINT FK_Product_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 6. PRODUCT_IMAGE
CREATE TABLE HAMT_SHOP.PRODUCT_IMAGE (
    image_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BIT DEFAULT 0,
    CONSTRAINT FK_Image_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id) ON DELETE CASCADE
);
GO

-- 7. VOUCHER
CREATE TABLE HAMT_SHOP.VOUCHER (
    voucher_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    discount_type VARCHAR(20) CHECK (discount_type IN ('percent', 'fixed')),
    discount_value DECIMAL(18, 2) NOT NULL,
    min_order_value DECIMAL(18, 2) DEFAULT 0,
    max_discount DECIMAL(18, 2),
    usage_limit INT DEFAULT 1,
    start_at DATETIME,
    end_at DATETIME,
    is_active BIT DEFAULT 1,
    created_by_admin BIGINT,
    CONSTRAINT FK_Voucher_Admin FOREIGN KEY (created_by_admin)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 8. ORDERS
CREATE TABLE HAMT_SHOP.ORDERS (
    order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_datetime DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    subtotal DECIMAL(18, 2) NOT NULL,
    shipping_fee DECIMAL(18, 2) DEFAULT 0,
    discount_amount DECIMAL(18, 2) DEFAULT 0,
    total_amount AS (subtotal + shipping_fee - discount_amount),
    voucher_id BIGINT NULL,
    CONSTRAINT FK_Order_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Order_Voucher FOREIGN KEY (voucher_id)
        REFERENCES HAMT_SHOP.VOUCHER(voucher_id)
);
GO

-- 9. ORDER_ITEM
CREATE TABLE HAMT_SHOP.ORDER_ITEM (
    item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_time DECIMAL(18, 2) NOT NULL,
    line_total AS (quantity * unit_price_at_time),
    CONSTRAINT FK_Item_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id),
    CONSTRAINT FK_Item_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id)
);
GO

-- 10. VOUCHER_REDEMPTION
CREATE TABLE HAMT_SHOP.VOUCHER_REDEMPTION (
    redemption_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    voucher_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    redeemed_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Redeem_Voucher FOREIGN KEY (voucher_id)
        REFERENCES HAMT_SHOP.VOUCHER(voucher_id),
    CONSTRAINT FK_Redeem_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Redeem_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id)
);
GO

-- 11. DELIVERY
CREATE TABLE HAMT_SHOP.DELIVERY (
    delivery_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    admin_id BIGINT,
    receiver_name NVARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    shipping_address NVARCHAR(500) NOT NULL,
    shipping_status VARCHAR(20) CHECK (shipping_status IN ('preparing', 'shipping', 'delivered', 'returned')),
    estimated_arrival DATETIME,
    CONSTRAINT FK_Delivery_Order FOREIGN KEY (order_id)
        REFERENCES HAMT_SHOP.ORDERS(order_id),
    CONSTRAINT FK_Delivery_Admin FOREIGN KEY (admin_id)
        REFERENCES HAMT_SHOP.ADMINS(admin_id)
);
GO

-- 12. REVIEW
CREATE TABLE HAMT_SHOP.REVIEW (
    review_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL UNIQUE,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Customer FOREIGN KEY (customer_id)
        REFERENCES HAMT_SHOP.CUSTOMER(customer_id),
    CONSTRAINT FK_Review_Product FOREIGN KEY (product_id)
        REFERENCES HAMT_SHOP.PRODUCT(product_id),
    CONSTRAINT FK_Review_Item FOREIGN KEY (order_item_id)
        REFERENCES HAMT_SHOP.ORDER_ITEM(item_id)
);
GO
