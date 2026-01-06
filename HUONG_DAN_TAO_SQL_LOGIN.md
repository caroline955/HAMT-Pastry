# 🎯 HƯỚNG DẪN TẠO SQL LOGIN (CÓ HÌNH ẢNH)

## BƯỚC 1: KẾT NỐI VÀO SQL SERVER

Bạn đang ở màn hình Connect rồi! Làm như sau:

1. **Server Name:** `(local)\SQLEXPRESS` (giữ nguyên)
2. **Authentication:** `Windows Authentication` (giữ nguyên)
3. Click **Connect**

---

## BƯỚC 2: BẬT SQL AUTHENTICATION MODE

Sau khi connect thành công:

1. Trong **Object Explorer** (bên trái), click phải vào **(local)\SQLEXPRESS** (server name ở trên cùng)
2. Chọn **Properties**
3. Trong cửa sổ Properties:
   - Click vào **Security** (bên trái)
   - Trong phần **Server authentication**, chọn:
     - ✅ **SQL Server and Windows Authentication mode** (Mixed Mode)
   - Click **OK**

4. Một popup sẽ hiện ra nói "Changes will take effect after restart"
   - Click **OK**

---

## BƯỚC 3: TẠO SQL LOGIN

### Cách 1: Dùng GUI (Đơn giản)

1. Trong **Object Explorer**, mở rộng:
   - **(local)\SQLEXPRESS**
   - **Security**
   - Click phải vào **Logins**
   - Chọn **New Login...**

2. Trong cửa sổ **Login - New**:
   - **Login name:** `hamtuser`
   - Chọn **SQL Server authentication**
   - **Password:** `HamtPass123!`
   - **Confirm password:** `HamtPass123!`
   - ❌ Bỏ tick **Enforce password policy** (để đơn giản)
   - ❌ Bỏ tick **User must change password at next login**

3. Trong phần **Select a page** (bên trái):
   - Click vào **User Mapping**
   - Tick vào database **HAMT.SQL**
   - Trong phần **Database role membership for: HAMT.SQL**, tick:
     - ✅ **db_datareader**
     - ✅ **db_datawriter**

4. Click **OK**

### Cách 2: Dùng SQL Script (Nhanh hơn)

1. Click vào nút **New Query** (hoặc nhấn Ctrl+N)
2. Copy-paste đoạn code sau:

```sql
-- 1. Tạo login
USE master;
GO

CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!';
GO

-- 2. Tạo user trong database HAMT.SQL
USE [HAMT.SQL];
GO

CREATE USER hamtuser FOR LOGIN hamtuser;
GO

-- 3. Cấp quyền
ALTER ROLE db_datareader ADD MEMBER hamtuser;
ALTER ROLE db_datawriter ADD MEMBER hamtuser;
GO

-- 4. Kiểm tra
SELECT 'Login created successfully!' AS Status;
GO
```

3. Nhấn **F5** hoặc click nút **Execute**
4. Xem kết quả ở phần **Messages**: "Login created successfully!"

---

## BƯỚC 4: RESTART SQL SERVER

Mở **PowerShell** với quyền Administrator:

```powershell
Restart-Service -Name "MSSQL$SQLEXPRESS" -Force
```

Hoặc qua Services:
1. Nhấn `Win + R` → gõ `services.msc`
2. Tìm **SQL Server (SQLEXPRESS)**
3. Click phải → **Restart**

---

## BƯỚC 5: KIỂM TRA LOGIN

Quay lại SSMS, disconnect và connect lại:

1. Click **Disconnect** (hoặc đóng SSMS)
2. Mở lại SSMS
3. Trong màn hình Connect:
   - **Server Name:** `(local)\SQLEXPRESS`
   - **Authentication:** Chọn **SQL Server Authentication**
   - **Login:** `hamtuser`
   - **Password:** `HamtPass123!`
   - Click **Connect**

Nếu connect thành công → ✅ Hoàn thành!

---

## BƯỚC 6: CHẠY SERVER

Mở PowerShell trong thư mục project:

```powershell
node server-sql-auth.js
```

Kết quả:
```
✅ Connected SQL Server!
✅ Found 10 products in database
🌐 http://localhost:3000
```

Mở browser: **http://localhost:3000**

---

## ❌ NẾU GẶP LỖI

### Lỗi: "Cannot open database 'HAMT.SQL'"

**Giải pháp:** Database chưa tồn tại, tạo database:

```sql
CREATE DATABASE [HAMT.SQL];
GO
```

Sau đó chạy file `setup-database.sql` (tôi sẽ tạo file này)

### Lỗi: "Login failed for user 'hamtuser'"

**Nguyên nhân:** Chưa restart SQL Server sau khi bật Mixed Mode

**Giải pháp:** Restart SQL Server (xem BƯỚC 4)

### Lỗi: "User already exists"

**Giải pháp:** Xóa user cũ trước:

```sql
USE [HAMT.SQL];
GO
DROP USER hamtuser;
GO

USE master;
GO
DROP LOGIN hamtuser;
GO
```

Sau đó tạo lại (BƯỚC 3)

---

## 📝 TÓM TẮT

1. ✅ Connect vào SSMS bằng Windows Auth
2. ✅ Bật Mixed Mode (SQL + Windows Auth)
3. ✅ Tạo login `hamtuser` / `HamtPass123!`
4. ✅ Cấp quyền db_datareader + db_datawriter
5. ✅ Restart SQL Server
6. ✅ Chạy `node server-sql-auth.js`

---

**🎉 Xong! Giờ bạn có thể kết nối backend rồi!**

