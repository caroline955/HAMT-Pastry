# 🍰 HAMT PASTRY - HƯỚNG DẪN CHẠY ĐƠN GIẢN

## 🎯 3 BƯỚC ĐỂ CHẠY WEB

### **BƯỚC 1: TẠO SQL LOGIN** (5 phút)

1. Mở **SQL Server Management Studio (SSMS)**
2. Connect vào `(local)\SQLEXPRESS` bằng Windows Authentication
3. Click **New Query**, copy-paste đoạn này:

```sql
-- Bật SQL Authentication
USE master;
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2;
GO

-- Tạo login
CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!';
GO
```

4. Nhấn **F5** để chạy
5. Restart SQL Server (PowerShell Admin):
```powershell
Restart-Service -Name "MSSQL$SQLEXPRESS" -Force
```

---

### **BƯỚC 2: TẠO DATABASE** (2 phút)

Trong SSMS, mở file `setup-database.sql` và nhấn **F5**

Hoặc copy-paste:
```sql
CREATE DATABASE [HAMT.SQL];
GO
-- (Xem file setup-database.sql để có script đầy đủ)
```

---

### **BƯỚC 3: CHẠY SERVER** (1 phút)

```powershell
node server-sql-auth.js
```

Mở browser: **http://localhost:3000**

---

## ✅ KẾT QUẢ MONG ĐỢI

```
✅ Connected SQL Server!
✅ Found 10 products in database
🌐 Server running at http://localhost:3000
```

---

## 📁 CẤU TRÚC PROJECT

```
HAMT-Pastry/
├── server-sql-auth.js          ⭐ Server chính (chạy file này)
├── setup-database.sql          ⭐ Script tạo database
├── HUONG_DAN_TAO_SQL_LOGIN.md  📖 Hướng dẫn chi tiết có hình
├── public/                     🌐 Frontend files
│   ├── home web.html
│   ├── products.html
│   └── ...
└── README_START_HERE.md        📖 File này
```

---

## ❌ NẾU GẶP LỖI

### Lỗi: "Login failed"
→ Chưa tạo SQL login, xem BƯỚC 1

### Lỗi: "Cannot open database"
→ Chưa tạo database, xem BƯỚC 2

### Lỗi: "Invalid object name"
→ Chưa chạy `setup-database.sql`

---

## 📖 TÀI LIỆU CHI TIẾT

- **`HUONG_DAN_TAO_SQL_LOGIN.md`** - Hướng dẫn tạo SQL Login có hình ảnh
- **`SIMPLE_SOLUTION.md`** - Giải pháp không cần TCP/IP
- **`setup-database.sql`** - Script tạo database và sample data

---

## 💡 THÔNG TIN QUAN TRỌNG

- **Server:** `(local)\SQLEXPRESS`
- **Database:** `HAMT.SQL`
- **Username:** `hamtuser`
- **Password:** `HamtPass123!`
- **Port:** `3000`

---

## 🎉 XONG!

Chỉ cần 3 bước:
1. Tạo SQL Login (5 phút)
2. Tạo Database (2 phút)
3. Chạy Server (1 phút)

**Total: 8 phút là xong!**

