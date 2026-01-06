# 🔧 SỬA LỖI RESTART SQL SERVER

## ❌ LỖI BẠN GẶP PHẢI

```
Restart-Service : Cannot find any service with service name 'MSSQL'.
```

**Nguyên nhân:** Tên service sai hoặc SQL Server có tên khác.

---

## ✅ GIẢI PHÁP

### **Cách 1: Tìm tên service chính xác**

Chạy lệnh này trong PowerShell:

```powershell
Get-Service -Name "*SQL*" | Select-Object Name, DisplayName, Status
```

Tìm service có tên giống như:
- `MSSQL$SQLEXPRESS`
- `MSSQLSERVER`
- `SQLServerAgent`

### **Cách 2: Restart bằng tên đầy đủ**

Thử từng lệnh sau (theo thứ tự):

```powershell
# Thử 1: SQLEXPRESS instance
Restart-Service -Name "MSSQL`$SQLEXPRESS" -Force

# Thử 2: Default instance
Restart-Service -Name "MSSQLSERVER" -Force

# Thử 3: Tất cả SQL services
Get-Service -Name "*SQL*" | Where-Object {$_.Status -eq "Running"} | Restart-Service -Force
```

### **Cách 3: Dùng GUI (Đơn giản nhất)** ⭐

1. Nhấn `Win + R`
2. Gõ: `services.msc`
3. Nhấn Enter
4. Tìm **SQL Server (SQLEXPRESS)**
5. Click phải → **Restart**

---

## 🎯 SAU KHI RESTART XONG

### **Bước 1: Tạo Database**

Mở SSMS, chạy file `setup-database.sql`:

```sql
CREATE DATABASE [HAMT.SQL];
GO

USE [HAMT.SQL];
GO

-- (Xem file setup-database.sql để có script đầy đủ)
```

### **Bước 2: Tạo User cho Login**

Sau khi có database, chạy:

```sql
USE [HAMT.SQL];
GO

CREATE USER hamtuser FOR LOGIN hamtuser;
GO

ALTER ROLE db_datareader ADD MEMBER hamtuser;
ALTER ROLE db_datawriter ADD MEMBER hamtuser;
GO
```

### **Bước 3: Chạy Server**

```powershell
node server-sql-auth.js
```

---

## 📝 SCRIPT HOÀN CHỈNH (CHẠY TRONG SSMS)

Copy toàn bộ đoạn này vào SSMS và nhấn F5:

```sql
-- 1. Bật SQL Authentication
USE master;
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2;
GO

-- 2. Tạo login
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'hamtuser')
BEGIN
    CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!';
    PRINT '✅ Login created!';
END
ELSE
BEGIN
    PRINT '✅ Login already exists!';
END
GO

-- 3. Tạo database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HAMT.SQL')
BEGIN
    CREATE DATABASE [HAMT.SQL];
    PRINT '✅ Database created!';
END
ELSE
BEGIN
    PRINT '✅ Database already exists!';
END
GO

-- 4. Tạo user
USE [HAMT.SQL];
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'hamtuser')
BEGIN
    CREATE USER hamtuser FOR LOGIN hamtuser;
    PRINT '✅ User created!';
END
ELSE
BEGIN
    PRINT '✅ User already exists!';
END
GO

-- 5. Cấp quyền
ALTER ROLE db_datareader ADD MEMBER hamtuser;
ALTER ROLE db_datawriter ADD MEMBER hamtuser;
GO

PRINT '';
PRINT '========================================';
PRINT '✅ SETUP COMPLETED!';
PRINT '========================================';
PRINT '';
PRINT 'Next: Restart SQL Server';
PRINT '  1. Win + R → services.msc';
PRINT '  2. Find: SQL Server (SQLEXPRESS)';
PRINT '  3. Right-click → Restart';
PRINT '';
PRINT 'Then run: node server-sql-auth.js';
GO
```

---

## 🎯 TÓM TẮT

1. ✅ **Restart SQL Server bằng GUI** (services.msc) - Dễ nhất
2. ✅ **Chạy script hoàn chỉnh ở trên** trong SSMS
3. ✅ **Restart SQL Server lần nữa** (qua services.msc)
4. ✅ **Chạy server:** `node server-sql-auth.js`

---

**💡 Dùng GUI (services.msc) để restart là đơn giản nhất!**

