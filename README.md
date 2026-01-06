# 🍰 HAMT PASTRY - CỰC KỲ ĐƠN GIẢN

## 🎯 CHỈ CẦN 1 LỆNH!

```bash
node server.js
```

**XONG!** Mở browser: **http://localhost:3000**

---

## ✅ ƯU ĐIỂM

- ✅ **KHÔNG CẦN** SQL Server Express
- ✅ **KHÔNG CẦN** cài đặt database
- ✅ **KHÔNG CẦN** tạo login
- ✅ **KHÔNG CẦN** config gì cả
- ✅ Chỉ cần chạy `node server.js`

---

## 📦 CÀI ĐẶT (NẾU CHƯA CÓ)

```bash
npm install
```

---

## 🚀 CHẠY SERVER

```bash
node server.js
```

**Kết quả:**
```
🎯 HAMT PASTRY - SQLite Version
✅ Không cần SQL Server Express!
✅ Không cần cài đặt gì thêm!

📁 Database: C:\...\hamt-pastry.db
✅ Đã tạo 10 sản phẩm mẫu!

========================================
🌐 Server running at http://localhost:3000
📂 Static files: public/
🔗 API: /api/products
========================================

✅ XONG! Mở browser: http://localhost:3000
```

---

## 📁 CẤU TRÚC

```
HAMT-Pastry/
├── server.js              ⭐ Chạy file này
├── hamt-pastry.db         📦 Database (tự động tạo)
├── package.json
└── public/                🌐 Frontend files
    ├── home web.html
    └── ...
```

---

## 🔗 API ENDPOINTS

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/api/products` | Lấy tất cả sản phẩm |
| GET | `/api/products/:id` | Lấy 1 sản phẩm |
| POST | `/api/products` | Thêm sản phẩm mới |

---

## 💡 THÔNG TIN

- **Database:** SQLite (file: `hamt-pastry.db`)
- **Port:** 3000
- **Sample data:** 10 sản phẩm bánh ngọt

---

## ❌ NẾU GẶP LỖI

### Lỗi: "Cannot find module 'better-sqlite3'"

```bash
npm install better-sqlite3
```

### Lỗi: "Port 3000 already in use"

Đổi port:
```bash
set PORT=3001 && node server.js
```

---

## 🎉 TÓM TẮT

**Chỉ cần 1 lệnh:**
```bash
node server.js
```

**Không cần:**
- ❌ SQL Server Express
- ❌ SQL Management Studio
- ❌ Tạo login/password
- ❌ Config phức tạp

**Chỉ cần:**
- ✅ Node.js
- ✅ Chạy `node server.js`
- ✅ XONG!

---

**🚀 ĐƠN GIẢN NHẤT CÓ THỂ!**

