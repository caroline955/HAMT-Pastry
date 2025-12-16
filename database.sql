USE HAMTPASTRY;
GO
/* =========================================================
   1. CREATE TABLE IF NOT EXISTS (THEO ERD + ADMINACCOUNT)
   ========================================================= */

------------------------------------------------------------
-- CATEGORY
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Category]') AND type = 'U'
)
BEGIN
    CREATE TABLE Category (
        category_id BIGINT PRIMARY KEY,
        nameC       VARCHAR(100) NOT NULL,
        parent_id   BIGINT NULL,
        CONSTRAINT FK_Category_Parent
            FOREIGN KEY (parent_id) REFERENCES Category(category_id)
    );
END
GO

------------------------------------------------------------
-- PRODUCT
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type = 'U'
)
BEGIN
    CREATE TABLE Product (
        product_id  BIGINT PRIMARY KEY,
        name        VARCHAR(200) NOT NULL,
        price       DECIMAL(18,2) NOT NULL,
        is_active   BIT NOT NULL,
        category_id BIGINT NOT NULL,
        CONSTRAINT FK_Product_Category
            FOREIGN KEY (category_id) REFERENCES Category(category_id)
    );
END
GO

------------------------------------------------------------
-- CUSTOMER
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type = 'U'
)
BEGIN
    CREATE TABLE Customer (
        customer_id  BIGINT PRIMARY KEY,
        full_name    VARCHAR(100) NOT NULL,
        email        VARCHAR(150) NOT NULL,
        phone_number VARCHAR(20)  NOT NULL
    );
END
GO

------------------------------------------------------------
-- ADMIN
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Admin]') AND type = 'U'
)
BEGIN
    CREATE TABLE Admin (
        admin_id       BIGINT PRIMARY KEY,
        full_nameAD    VARCHAR(100) NOT NULL,
        emailAD        VARCHAR(150) NOT NULL,
        phoneAD_number VARCHAR(20)  NOT NULL
    );
END
GO

------------------------------------------------------------
-- VOUCHER
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Voucher]') AND type = 'U'
)
BEGIN
    CREATE TABLE Voucher (
        voucher_id  BIGINT PRIMARY KEY,
        [type]      VARCHAR(50) NOT NULL,
        code        VARCHAR(50) NOT NULL,
        [value]     INT NOT NULL,
        start_at    DATETIME2 NOT NULL,
        end_at      DATETIME2 NOT NULL,
        customer_id BIGINT NULL,
        CONSTRAINT FK_Voucher_Customer
            FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
    );
END
GO

------------------------------------------------------------
-- ORDER (dùng [] vì ORDER là keyword)
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type = 'U'
)
BEGIN
    CREATE TABLE [Order] (
        order_id       BIGINT PRIMARY KEY,
        customer_id    BIGINT NOT NULL,
        product_id     BIGINT NOT NULL,
        unit_price     DECIMAL(18,2) NOT NULL,
        order_datetime DATETIME2 NOT NULL,
        status         VARCHAR(50) NOT NULL,
        voucher_id     BIGINT NULL,
        CONSTRAINT FK_Order_Customer
            FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
        CONSTRAINT FK_Order_Product
            FOREIGN KEY (product_id) REFERENCES Product(product_id),
        CONSTRAINT FK_Order_Voucher
            FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id)
    );
END
GO

------------------------------------------------------------
-- PAYMENT
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type = 'U'
)
BEGIN
    CREATE TABLE Payment (
        payment_id BIGINT PRIMARY KEY,
        order_id   BIGINT NOT NULL,
        method     VARCHAR(50) NOT NULL,
        amount     DECIMAL(18,2) NOT NULL,
        paid_at    DATETIME2 NOT NULL,
        CONSTRAINT FK_Payment_Order
            FOREIGN KEY (order_id) REFERENCES [Order](order_id)
    );
END
GO

------------------------------------------------------------
-- DELIVERY
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delivery]') AND type = 'U'
)
BEGIN
    CREATE TABLE Delivery (
        delivery_id    BIGINT PRIMARY KEY,
        order_id       BIGINT NOT NULL,
        admin_id       BIGINT NOT NULL,
        phoneAD_number VARCHAR(20) NOT NULL,
        CONSTRAINT FK_Delivery_Order
            FOREIGN KEY (order_id) REFERENCES [Order](order_id),
        CONSTRAINT FK_Delivery_Admin
            FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
    );
END
GO

------------------------------------------------------------
-- REVIEW
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Review]') AND type = 'U'
)
BEGIN
    CREATE TABLE Review (
        review_id   BIGINT PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        rating      INT NOT NULL,
        product_id  BIGINT NOT NULL,
        created_at  DATETIME2 NOT NULL,
        CONSTRAINT FK_Review_Customer
            FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
        CONSTRAINT FK_Review_Product
            FOREIGN KEY (product_id) REFERENCES Product(product_id)
    );
END
GO

------------------------------------------------------------
-- ADMINACCOUNT (bảng login cho admin)
------------------------------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[AdminAccount]') AND type = 'U'
)
BEGIN
    CREATE TABLE AdminAccount (
        account_id   BIGINT PRIMARY KEY,
        admin_id     BIGINT NOT NULL,
        login_email  VARCHAR(150) NULL,
        login_phone  VARCHAR(20)  NULL,
        [password]   VARCHAR(255) NOT NULL,
        CONSTRAINT FK_AdminAccount_Admin
            FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
        CONSTRAINT UQ_AdminAccount_Email UNIQUE (login_email),
        CONSTRAINT UQ_AdminAccount_Phone UNIQUE (login_phone)
    );
END
GO


/* =========================================================
   2. INSERT DATA IF NOT EXISTS (IDEMPOTENT)
   ========================================================= */

-------------------------
-- CATEGORY
-------------------------
IF NOT EXISTS (SELECT 1 FROM Category WHERE category_id = 1)
    INSERT INTO Category (category_id, nameC, parent_id)
    VALUES (1, 'Cakes', NULL);
GO

-------------------------
-- PRODUCT
-------------------------
IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 1)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (1, 'Strawberry cherry blossom', 625000, 1, 1);

IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 2)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (2, 'Tiramisu De Caramel #2',   625000, 1, 1);

IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 3)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (3, 'Passion Fruit',            625000, 1, 1);

IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 4)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (4, 'Mango Coconut',            625000, 1, 1);

IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 5)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (5, 'Creamy Choco',             625000, 1, 1);

IF NOT EXISTS (SELECT 1 FROM Product WHERE product_id = 6)
    INSERT INTO Product (product_id, name, price, is_active, category_id)
    VALUES (6, 'Berry Fruit Vanilla',      625000, 1, 1);
GO

-------------------------
-- CUSTOMER
-------------------------
IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 1)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (1, 'Trang Nguyen', 'trangnguyen@gmail.com',  '0356379834');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 2)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (2, 'Duy Phung',   'duyphung47@gmail.com',   '0386736592');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 3)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (3, 'Chi Pham',    'hachi03@gmail.com',      '0375898462');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 4)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (4, 'Tam Anh',     'tama265@gmail.com',      '0976473543');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 5)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (5, 'Phuong Vu',   'vtmp.huong@gmail.com',   '0925476945');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 6)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (6, 'Bach Vu',     'dinhbach5@gmail.com',    '0387257483');

IF NOT EXISTS (SELECT 1 FROM Customer WHERE customer_id = 6)
    INSERT INTO Customer (customer_id, full_name, email, phone_number)
    VALUES (7, 'Dinh Tai',     'dinhtai7@gmail.com',    '0345678234');
GO

-------------------------
-- ADMIN
-------------------------
IF NOT EXISTS (SELECT 1 FROM Admin WHERE admin_id = 1)
    INSERT INTO Admin (admin_id, full_nameAD, emailAD, phoneAD_number)
    VALUES (1, 'Huyen My', 'huyenmy.admin@hamtpastry.com', '0900000001');
GO

-------------------------
-- VOUCHER
-------------------------
IF NOT EXISTS (SELECT 1 FROM Voucher WHERE voucher_id = 1)
    INSERT INTO Voucher (voucher_id, [type], code, [value], start_at, end_at, customer_id)
    VALUES (1, 'Gold',   'GOLD10',   10, '2024-11-01 00:00:00', '2024-12-31 23:59:59', 1);

IF NOT EXISTS (SELECT 1 FROM Voucher WHERE voucher_id = 2)
    INSERT INTO Voucher (voucher_id, [type], code, [value], start_at, end_at, customer_id)
    VALUES (2, 'Silver', 'SILVER05',  5, '2024-11-01 00:00:00', '2024-12-31 23:59:59', 3);

IF NOT EXISTS (SELECT 1 FROM Voucher WHERE voucher_id = 3)
    INSERT INTO Voucher (voucher_id, [type], code, [value], start_at, end_at, customer_id)
    VALUES (3, 'Bronze', 'BRONZE03',  3, '2024-11-01 00:00:00', '2024-12-31 23:59:59', 5);
GO

-------------------------
-- ORDER (15 đơn)
-------------------------
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 1)
    INSERT INTO [Order] VALUES (1, 1, 1, 625000, '2024-11-20 09:00:00', 'Completed', 1);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 2)
    INSERT INTO [Order] VALUES (2, 2, 2, 625000, '2024-11-20 09:15:00', 'Completed', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 3)
    INSERT INTO [Order] VALUES (3, 3, 3, 625000, '2024-11-20 10:00:00', 'Completed', 2);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 4)
    INSERT INTO [Order] VALUES (4, 4, 4, 625000, '2024-11-20 10:30:00', 'Pending',   NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 5)
    INSERT INTO [Order] VALUES (5, 5, 5, 625000, '2024-11-20 11:00:00', 'Completed', 3);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 6)
    INSERT INTO [Order] VALUES (6, 6, 6, 625000, '2024-11-20 11:30:00', 'Cancelled', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 7)
    INSERT INTO [Order] VALUES (7, 7, 1, 625000, '2024-11-21 08:45:00', 'Completed', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 8)
    INSERT INTO [Order] VALUES (8, 1, 2, 625000, '2024-11-21 09:10:00', 'Completed', 1);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 9)
    INSERT INTO [Order] VALUES (9, 2, 3, 625000, '2024-11-21 09:30:00', 'Completed', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 10)
    INSERT INTO [Order] VALUES (10, 3, 4, 625000, '2024-11-21 10:00:00', 'Completed', 2);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 11)
    INSERT INTO [Order] VALUES (11, 4, 5, 625000, '2024-11-21 10:30:00', 'Pending',   NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 12)
    INSERT INTO [Order] VALUES (12, 5, 6, 625000, '2024-11-21 11:00:00', 'Completed', 3);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 13)
    INSERT INTO [Order] VALUES (13, 6, 1, 625000, '2024-11-22 08:30:00', 'Completed', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 14)
    INSERT INTO [Order] VALUES (14, 7, 2, 625000, '2024-11-22 09:00:00', 'Completed', NULL);
IF NOT EXISTS (SELECT 1 FROM [Order] WHERE order_id = 15)
    INSERT INTO [Order] VALUES (15, 3, 5, 625000, '2024-11-22 09:30:00', 'Completed', 2);
GO

-------------------------
-- PAYMENT
-------------------------
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 1)
    INSERT INTO Payment VALUES (1, 1,  'Cash',     562500, '2024-11-20 09:05:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 2)
    INSERT INTO Payment VALUES (2, 2,  'Card',     625000, '2024-11-20 09:20:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 3)
    INSERT INTO Payment VALUES (3, 3,  'E-Wallet', 593750, '2024-11-20 10:05:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 4)
    INSERT INTO Payment VALUES (4, 5,  'Card',     606250, '2024-11-20 11:05:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 5)
    INSERT INTO Payment VALUES (5, 7,  'Cash',     625000, '2024-11-21 08:50:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 6)
    INSERT INTO Payment VALUES (6, 8,  'Card',     562500, '2024-11-21 09:15:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 7)
    INSERT INTO Payment VALUES (7, 9,  'E-Wallet', 625000, '2024-11-21 09:35:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 8)
    INSERT INTO Payment VALUES (8,10,  'Card',     593750, '2024-11-21 10:05:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 9)
    INSERT INTO Payment VALUES (9,12,  'E-Wallet', 606250, '2024-11-21 11:05:00');
IF NOT EXISTS (SELECT 1 FROM Payment WHERE payment_id = 10)
    INSERT INTO Payment VALUES (10,13, 'Cash',     625000, '2024-11-22 08:35:00');
GO

-------------------------
-- DELIVERY
-------------------------
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 1)
    INSERT INTO Delivery VALUES (1, 1, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 2)
    INSERT INTO Delivery VALUES (2, 2, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 3)
    INSERT INTO Delivery VALUES (3, 3, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 4)
    INSERT INTO Delivery VALUES (4, 5, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 5)
    INSERT INTO Delivery VALUES (5, 7, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 6)
    INSERT INTO Delivery VALUES (6, 8, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 7)
    INSERT INTO Delivery VALUES (7, 9, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 8)
    INSERT INTO Delivery VALUES (8,10, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 9)
    INSERT INTO Delivery VALUES (9,12, 1, '0900000001');
IF NOT EXISTS (SELECT 1 FROM Delivery WHERE delivery_id = 10)
    INSERT INTO Delivery VALUES (10,13,1, '0900000001');
GO

-------------------------
-- REVIEW
-------------------------
IF NOT EXISTS (SELECT 1 FROM Review WHERE review_id = 1)
    INSERT INTO Review VALUES (1, 1, 5, 1, '2024-11-21 12:00:00');
IF NOT EXISTS (SELECT 1 FROM Review WHERE review_id = 2)
    INSERT INTO Review VALUES (2, 2, 4, 2, '2024-11-21 12:10:00');
IF NOT EXISTS (SELECT 1 FROM Review WHERE review_id = 3)
    INSERT INTO Review VALUES (3, 3, 5, 3, '2024-11-21 12:20:00');
IF NOT EXISTS (SELECT 1 FROM Review WHERE review_id = 4)
    INSERT INTO Review VALUES (4, 5, 4, 5, '2024-11-22 13:00:00');
IF NOT EXISTS (SELECT 1 FROM Review WHERE review_id = 5)
    INSERT INTO Review VALUES (5, 7, 5, 6, '2024-11-22 13:15:00');
GO

-------------------------
-- ADMINACCOUNT (LOGIN)
-------------------------
IF NOT EXISTS (SELECT 1 FROM AdminAccount WHERE account_id = 1)
    INSERT INTO AdminAccount (account_id, admin_id, login_email, login_phone, [password])
    VALUES (1, 1, 'huyenmy.admin@hamtpastry.com', '0900000001', 'admin123');
GO