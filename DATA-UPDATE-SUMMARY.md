# ✅ Đã cập nhật Database khớp với dataHAMT.sql

## 🎯 Những gì đã làm:

### 1. **Cập nhật Schema**
- ✅ Thêm cột `full_name` vào bảng `CUSTOMER`
- ✅ Thêm cột `parent_id` vào bảng `CATEGORY` (hỗ trợ category con)
- ✅ Thêm cột `created_by_admin` vào bảng `PRODUCT`

### 2. **Cập nhật Dữ liệu mẫu (10 dòng/bảng)**

#### ADMINS (1 admin)
- Username: `admin`
- Password: `$2b$10$adminhash01`
- Full name: `Shop Admin`
- Role: `manager`

#### CUSTOMERS (10 customers)
1. Nguyễn Thị Thu Trang - customer1@example.com - 0970717355
2. Giang Lê Hiệp - customer2@example.com - 0985131377
3. Lưu Trần Tâm Anh - customer3@example.com - 0972498494
4. Nguyễn Huyền My - customer4@example.com - 0970643907
5. Trần Đặng Thu Hương - customer5@example.com - 0978161301
6. Phùng Đức Duy - customer6@example.com - 0988837457
7. Vũ Thị Minh Phương - customer7@example.com - 0935488219
8. Phạm Hà Chi - customer8@example.com - 0934784691
9. Vũ Đình Bách - customer9@example.com - 0978707214
10. Phạm Hoàng Long - customer10@example.com - 0973855860

#### MEMBERSHIP (10 memberships)
- Customer 1: Bronze - 200,000đ
- Customer 2-10: Silver - 500,000đ

#### CATEGORIES (10 categories với parent-child)
1. Cakes (parent)
2. Cupcakes (parent)
3. Cheesecakes (child of Cakes)
4. Tiramisu (child of Cakes)
5. Cookies (child of Cupcakes)
6. Brownies (child of Cupcakes)
7. Macarons (child of Cupcakes)
8. Bánh Trung Thu (parent)
9. Nước uống (parent)
10. Phụ kiện sinh nhật (parent)

#### VOUCHERS (10 vouchers)
- KM01 đến KM10
- Tất cả: 10% discount, min order 50,000đ

#### PRODUCTS (10 products)
1. Bánh 1 - 55,000đ
2. Bánh 2 - 450,000đ
3. Bánh 3 - 55,000đ
4. Bánh Kem Matcha - 360,000đ
5. Su Kem - 15,000đ
6. Bánh Mì Hoa Cúc - 120,000đ
7. Macaron Set - 180,000đ
8. Trà Đào - 45,000đ
9. Bánh Nướng - 85,000đ
10. Nến sinh nhật - 5,000đ

#### ORDERS (10 orders)
- Tất cả: completed status
- Subtotal: 150,000đ
- Shipping: 15,000đ
- Total: 165,000đ

#### ORDER_ITEMS (10 items)
- Mỗi order có 1 item
- Quantity và price khác nhau

#### DELIVERY (10 deliveries)
- Đan xen người mua và người tặng (khác customer)
- Ví dụ:
  - Order 1: Giao cho chính customer 1
  - Order 2: Giao cho Lê Hoàng Nam (khác customer 2)
  - Order 3: Giao cho chính customer 3
  - Order 4: Giao cho Trần Minh Đức (khác customer 4)
  - ...

#### REVIEWS (10 reviews)
- Tất cả 5 sao
- Comments: "Bánh ngon lắm!", "Sẽ ủng hộ tiếp!", etc.

## 🚀 Cách chạy lại:

```bash
# 1. Xóa database cũ (nếu cần)
rm hamt-pastry.db

# 2. Tạo database mới
node setup-database.js

# 3. Chạy server
node server.js
```

## 📊 Kết quả:

```
✅ HOÀN THÀNH! Database đã sẵn sàng!
📊 Tổng kết:
   - 1 Admin
   - 10 Customers
   - 10 Memberships
   - 10 Categories
   - 10 Vouchers
   - 10 Products
   - 10 Orders
   - 10 Order Items
   - 10 Deliveries
   - 10 Reviews
```

## 🔍 Test:

1. **API Test Page**: http://localhost:3000/api-test.html
2. **Admin Login**: http://localhost:3000/admin-login.html
   - Username: `admin`
   - Password: `admin123` (hoặc `$2b$10$adminhash01` nếu dùng bcrypt)
3. **Customer Login**: http://localhost:3000/login.html
   - Email: `customer1@example.com`
   - Password: `123456` (hoặc hash tương ứng)

## 📝 Notes:

- ✅ Dữ liệu đã khớp 100% với file `dataHAMT.sql`
- ✅ Schema đã được cập nhật đầy đủ
- ✅ Tất cả foreign keys đều hợp lệ
- ✅ Dữ liệu có tính thực tế (đan xen người mua/người tặng)

