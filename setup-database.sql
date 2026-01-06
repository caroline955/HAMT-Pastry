-- ========================================
-- SETUP DATABASE HAMT PASTRY
-- Chạy file này trong SSMS sau khi tạo login
-- ========================================

-- 1. Tạo database (nếu chưa có)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HAMT.SQL')
BEGIN
    CREATE DATABASE [HAMT.SQL];
    PRINT '✅ Database HAMT.SQL created!';
END
ELSE
BEGIN
    PRINT '✅ Database HAMT.SQL already exists!';
END
GO

-- 2. Sử dụng database
USE [HAMT.SQL];
GO

-- 3. Tạo schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'HAMT_SHOP')
BEGIN
    EXEC('CREATE SCHEMA HAMT_SHOP');
    PRINT '✅ Schema HAMT_SHOP created!';
END
ELSE
BEGIN
    PRINT '✅ Schema HAMT_SHOP already exists!';
END
GO

-- 4. Xóa table cũ nếu tồn tại
IF OBJECT_ID('HAMT_SHOP.PRODUCT', 'U') IS NOT NULL
BEGIN
    DROP TABLE HAMT_SHOP.PRODUCT;
    PRINT '→ Dropped old PRODUCT table';
END
GO

-- 5. Tạo table PRODUCT
CREATE TABLE HAMT_SHOP.PRODUCT (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(200) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    image NVARCHAR(500),
    description NVARCHAR(MAX)
);
GO

PRINT '✅ Table PRODUCT created!';
GO

-- 6. Insert sample data
INSERT INTO HAMT_SHOP.PRODUCT (name, price, image, description) VALUES
(N'Bánh Croissant', 25000, 'images/croissant.jpg', N'Bánh sừng bò Pháp truyền thống, giòn tan, thơm bơ'),
(N'Bánh Tiramisu', 45000, 'images/tiramisu.jpg', N'Bánh Tiramisu Ý nguyên bản, vị cà phê đậm đà'),
(N'Bánh Macaron', 35000, 'images/macaron.jpg', N'Bánh Macaron Pháp nhiều màu sắc, vị ngọt nhẹ'),
(N'Bánh Cheesecake', 50000, 'images/cheesecake.jpg', N'Bánh phô mai New York, béo ngậy, mềm mịn'),
(N'Bánh Éclair', 30000, 'images/eclair.jpg', N'Bánh su kem dài Pháp, nhân kem vani thơm ngon'),
(N'Bánh Mochi', 20000, 'images/mochi.jpg', N'Bánh Mochi Nhật Bản, mềm dẻo, nhân đậu đỏ'),
(N'Bánh Brownie', 28000, 'images/brownie.jpg', N'Bánh Brownie socola đậm đà, giòn ngoài mềm trong'),
(N'Bánh Cupcake', 22000, 'images/cupcake.jpg', N'Bánh Cupcake nhiều hương vị, trang trí đẹp mắt'),
(N'Bánh Tart', 38000, 'images/tart.jpg', N'Bánh Tart trái cây tươi, vỏ giòn, nhân kem mềm'),
(N'Bánh Donut', 18000, 'images/donut.jpg', N'Bánh Donut chiên giòn, phủ đường và chocolate');
GO

PRINT '✅ Inserted 10 sample products!';
GO

-- 7. Kiểm tra dữ liệu
SELECT COUNT(*) AS TotalProducts FROM HAMT_SHOP.PRODUCT;
GO

SELECT TOP 5 
    id,
    name,
    price,
    description
FROM HAMT_SHOP.PRODUCT
ORDER BY id;
GO

PRINT '';
PRINT '========================================';
PRINT 'DATABASE SETUP COMPLETED!';
PRINT '========================================';
PRINT '';
PRINT '📊 Total products: 10';
PRINT '✅ Ready to use!';
PRINT '';
PRINT 'Next step: Run server';
PRINT '  node server-sql-auth.js';
PRINT '';
GO

