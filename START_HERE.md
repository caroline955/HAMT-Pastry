# 🎯 HƯỚNG DẪN SIÊU ĐƠN GIẢN - 2 BƯỚC

## ✅ BƯỚC 1: CHẠY SCRIPT SQL (2 PHÚT)

1. Mở **SQL Server Management Studio (SSMS)**
2. Connect vào `(local)\SQLEXPRESS` (Windows Authentication)
3. Click **File** → **Open** → **File**
4. Chọn file: **`complete-setup.sql`**
5. Nhấn **F5** (Execute)

**Kết quả:**
```
✅ Login exists: hamtuser
✅ Database exists: HAMT.SQL
✅ User exists in HAMT.SQL
✅ Total products: 10
```

---

## ✅ BƯỚC 2: RESTART SQL SERVER (1 PHÚT)

### Cách 1: Dùng GUI (Dễ nhất) ⭐

1. Nhấn `Win + R`
2. Gõ: `services.msc`
3. Tìm: **SQL Server (SQLEXPRESS)**
4. Click phải → **Restart**
5. Đợi 10 giây

### Cách 2: Dùng PowerShell Script

Click phải **PowerShell** → **Run as Administrator**:

```powershell
powershell -ExecutionPolicy Bypass -File restart-sql-server.ps1
```

---

## ✅ XONG! CHẠY SERVER

```powershell
node server-sql-auth.js
```

**Kết quả:**
```
✅ Connected SQL Server!
✅ Found 10 products in database
🌐 Server running at http://localhost:3000
```

Mở browser: **http://localhost:3000**

---

## 📁 FILES QUAN TRỌNG

| File | Dùng khi nào |
|------|--------------|
| **`complete-setup.sql`** ⭐ | Chạy trong SSMS (BƯỚC 1) |
| **`restart-sql-server.ps1`** | Restart SQL Server tự động |
| **`server-sql-auth.js`** | Chạy server (BƯỚC 2) |

---

## ❌ NẾU GẶP LỖI

### Lỗi khi chạy script SQL:
→ Đảm bảo connect bằng **Windows Authentication** (không phải SQL Auth)

### Lỗi khi restart:
→ Dùng **services.msc** (GUI) thay vì PowerShell

### Lỗi khi chạy server:
→ Đảm bảo đã restart SQL Server sau khi chạy script

---

## 🎯 TÓM TẮT

1. ✅ Chạy `complete-setup.sql` trong SSMS
2. ✅ Restart SQL Server (qua services.msc)
3. ✅ Chạy `node server-sql-auth.js`
4. ✅ Mở http://localhost:3000

**Total: 3 phút là xong!**

---

## 📞 HỖ TRỢ

- **Chi tiết hơn:** Đọc `FIX_RESTART_ERROR.md`
- **Hướng dẫn có hình:** Đọc `HUONG_DAN_TAO_SQL_LOGIN.md`

---

**🎉 CHỈ CẦN 2 BƯỚC: Chạy SQL script + Restart SQL Server!**

