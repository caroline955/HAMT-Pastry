-- ========================================
-- SETUP HOÀN CHỈNH HAMT PASTRY
-- Chạy toàn bộ script này trong SSMS (nhấn F5)
-- ========================================

PRINT '========================================';
PRINT 'HAMT PASTRY - COMPLETE SETUP';
PRINT '========================================';
PRINT '';

-- ========================================
-- BƯỚC 1: BẬT SQL AUTHENTICATION
-- ========================================

PRINT '[1/5] Enabling SQL Authentication...';

USE master;
GO

EXEC xp_instance_regwrite 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode', 
    REG_DWORD, 
    2;
GO

PRINT '  ✅ SQL Authentication enabled!';
PRINT '  ⚠️  Cần restart SQL Server sau khi chạy xong script này';
PRINT '';

-- ========================================
-- BƯỚC 2: TẠO LOGIN
-- ========================================

PRINT '[2/5] Creating SQL Login...';

-- Xóa login cũ nếu tồn tại
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'hamtuser')
BEGIN
    DROP LOGIN hamtuser;
    PRINT '  → Removed existing login';
END

-- Tạo login mới
CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!', CHECK_POLICY = OFF;
PRINT '  ✅ Login created: hamtuser';
PRINT '  🔑 Password: HamtPass123!';
PRINT '';

-- ========================================
-- BƯỚC 3: TẠO DATABASE
-- ========================================

PRINT '[3/5] Creating database...';

-- Xóa database cũ nếu tồn tại (cẩn thận!)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HAMT.SQL')
BEGIN
    ALTER DATABASE [HAMT.SQL] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [HAMT.SQL];
    PRINT '  → Removed existing database';
END

-- Tạo database mới
CREATE DATABASE [HAMT.SQL];
PRINT '  ✅ Database created: HAMT.SQL';
PRINT '';

-- ========================================
-- BƯỚC 4: TẠO SCHEMA VÀ TABLE
-- ========================================

PRINT '[4/5] Creating schema and tables...';

USE [HAMT.SQL];
GO

-- Tạo schema
CREATE SCHEMA HAMT_SHOP;
PRINT '  ✅ Schema created: HAMT_SHOP';

-- Tạo table PRODUCT
CREATE TABLE HAMT_SHOP.PRODUCT (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(200) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    image NVARCHAR(500),
    description NVARCHAR(MAX)
);
PRINT '  ✅ Table created: PRODUCT';

-- Insert sample data
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

PRINT '  ✅ Inserted 10 sample products';
PRINT '';

-- ========================================
-- BƯỚC 5: TẠO USER VÀ CẤP QUYỀN
-- ========================================

PRINT '[5/5] Creating user and granting permissions...';

-- Tạo user
CREATE USER hamtuser FOR LOGIN hamtuser;
PRINT '  ✅ User created in database';

-- Cấp quyền
ALTER ROLE db_datareader ADD MEMBER hamtuser;
ALTER ROLE db_datawriter ADD MEMBER hamtuser;
PRINT '  ✅ Granted db_datareader role';
PRINT '  ✅ Granted db_datawriter role';
PRINT '';

-- ========================================
-- VERIFICATION
-- ========================================

PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';
PRINT '';

-- Kiểm tra login
IF EXISTS (SELECT * FROM master.sys.server_principals WHERE name = 'hamtuser')
    PRINT '✅ Login exists: hamtuser';
ELSE
    PRINT '❌ Login NOT found!';

-- Kiểm tra database
IF EXISTS (SELECT * FROM master.sys.databases WHERE name = 'HAMT.SQL')
    PRINT '✅ Database exists: HAMT.SQL';
ELSE
    PRINT '❌ Database NOT found!';

-- Kiểm tra user
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'hamtuser')
    PRINT '✅ User exists in HAMT.SQL';
ELSE
    PRINT '❌ User NOT found!';

-- Kiểm tra số lượng sản phẩm
DECLARE @productCount INT;
SELECT @productCount = COUNT(*) FROM HAMT_SHOP.PRODUCT;
PRINT '✅ Total products: ' + CAST(@productCount AS VARCHAR(10));

PRINT '';

-- ========================================
-- NEXT STEPS
-- ========================================

PRINT '========================================';
PRINT 'SETUP COMPLETED!';
PRINT '========================================';
PRINT '';
PRINT '📝 Next steps:';
PRINT '';
PRINT '1. RESTART SQL SERVER:';
PRINT '   • Win + R → services.msc';
PRINT '   • Find: SQL Server (SQLEXPRESS)';
PRINT '   • Right-click → Restart';
PRINT '';
PRINT '   OR run PowerShell (Admin):';
PRINT '   powershell -ExecutionPolicy Bypass -File restart-sql-server.ps1';
PRINT '';
PRINT '2. TEST CONNECTION:';
PRINT '   sqlcmd -S (local)\SQLEXPRESS -U hamtuser -P HamtPass123! -Q "SELECT @@VERSION"';
PRINT '';
PRINT '3. RUN SERVER:';
PRINT '   node server-sql-auth.js';
PRINT '';
PRINT '4. OPEN BROWSER:';
PRINT '   http://localhost:3000';
PRINT '';
PRINT '========================================';
PRINT '';

GO

