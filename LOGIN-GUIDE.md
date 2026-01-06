# 🎯 HAMT PASTRY - E-commerce System

## ✅ Đã hoàn thành

### 🔐 Authentication System
- ✅ Customer Login/Register (`/api/auth/login`, `/api/auth/register`)
- ✅ Admin Login (`/api/admin/login`)
- ✅ Auto-fill form khi đã login
- ✅ LocalStorage để lưu session

### 📦 Features
- ✅ Product Management (Admin)
- ✅ Order Management (Admin)
- ✅ Customer Management (Admin)
- ✅ Voucher System
- ✅ Guest Checkout
- ✅ Member Checkout (tự động cập nhật membership)
- ✅ Cart System

## 🚀 Cách chạy

### 1. Cài đặt dependencies
```bash
npm install
```

### 2. Khởi tạo database
```bash
node init-db.js
```

### 3. Chạy server
```bash
node server.js
```

Server sẽ chạy tại: **http://localhost:3000**

## 📚 Trang web

### Customer Pages
- **Home**: http://localhost:3000/home%20web.html
- **Products**: http://localhost:3000/products.html
- **Cart**: http://localhost:3000/cart.html
- **Checkout**: http://localhost:3000/checkout.html
- **Login**: http://localhost:3000/login.html

### Admin Pages
- **Admin Login**: http://localhost:3000/admin-login.html
- **Admin Dashboard**: http://localhost:3000/admin.html

## 🔑 Test Accounts

### Admin Account
- Username: `admin`
- Password: `admin123`

### Customer Account (tạo mới qua Register)
- Hoặc test với email/password bất kỳ sau khi register

## 📖 API Endpoints

### Authentication
- `POST /api/auth/register` - Đăng ký customer
- `POST /api/auth/login` - Đăng nhập customer
- `GET /api/auth/me/:customer_id` - Lấy thông tin customer
- `POST /api/admin/login` - Đăng nhập admin

### Products
- `GET /api/products` - Lấy danh sách sản phẩm
- `GET /api/products/:id` - Lấy chi tiết sản phẩm
- `GET /api/categories` - Lấy danh sách categories

### Vouchers
- `GET /api/vouchers` - Lấy danh sách vouchers
- `POST /api/vouchers/validate` - Validate voucher

### Orders
- `POST /api/orders/guest` - Đặt hàng (guest)
- `POST /api/orders/member` - Đặt hàng (member, tự động cập nhật membership)
- `GET /api/admin/orders` - Lấy danh sách orders (admin)
- `GET /api/admin/orders/:id` - Lấy chi tiết order (admin)

## 🎨 Flow hoạt động

### Customer Flow
1. Vào trang Home → Browse products
2. Add to Cart
3. Checkout (có thể login hoặc guest)
4. Nếu đã login → form tự động điền thông tin
5. Submit order → Tự động cập nhật membership nếu là member

### Admin Flow
1. Vào Admin Login page
2. Login với admin account
3. Quản lý Products, Orders, Customers, Vouchers
4. Xem Reports & Analytics

## 💾 Database Schema

- **CUSTOMER** - Thông tin khách hàng
- **ADMINS** - Thông tin admin
- **MEMBERSHIP** - Hạng thành viên (Bronze/Silver/Gold)
- **PRODUCT** - Sản phẩm
- **CATEGORY** - Danh mục
- **ORDERS** - Đơn hàng
- **ORDER_ITEM** - Chi tiết đơn hàng
- **DELIVERY** - Thông tin giao hàng
- **PAYMENT** - Thông tin thanh toán
- **VOUCHER** - Mã giảm giá
- **VOUCHER_REDEMPTION** - Lịch sử sử dụng voucher
- **REVIEW** - Đánh giá sản phẩm

## 🔧 Tech Stack

- **Backend**: Node.js + Express
- **Database**: SQLite (better-sqlite3)
- **Frontend**: HTML + CSS + Vanilla JavaScript
- **No framework** - Pure JavaScript for simplicity

## 📝 Notes

- Session được lưu trong localStorage
- Admin phải login mới vào được dashboard
- Customer có thể checkout dưới dạng guest hoặc member
- Member sẽ được tích điểm và cập nhật hạng tự động

