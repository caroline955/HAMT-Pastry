# 🧪 Hướng dẫn Test Database mới

## 📋 Thông tin đăng nhập

### 🔐 Admin Login
- **URL**: http://localhost:3000/admin-login.html
- **Username**: `admin`
- **Password**: `admin123` hoặc `$2b$10$adminhash01`

### 👤 Customer Login (10 accounts)
- **URL**: http://localhost:3000/login.html

| Email | Password | Full Name | Phone |
|-------|----------|-----------|-------|
| customer1@example.com | `$2b$10$custhash01` | Nguyễn Thị Thu Trang | 0970717355 |
| customer2@example.com | `$2b$10$custhash02` | Giang Lê Hiệp | 0985131377 |
| customer3@example.com | `$2b$10$custhash03` | Lưu Trần Tâm Anh | 0972498494 |
| customer4@example.com | `$2b$10$custhash04` | Nguyễn Huyền My | 0970643907 |
| customer5@example.com | `$2b$10$custhash05` | Trần Đặng Thu Hương | 0978161301 |
| customer6@example.com | `$2b$10$custhash06` | Phùng Đức Duy | 0988837457 |
| customer7@example.com | `$2b$10$custhash07` | Vũ Thị Minh Phương | 0935488219 |
| customer8@example.com | `$2b$10$custhash08` | Phạm Hà Chi | 0934784691 |
| customer9@example.com | `$2b$10$custhash09` | Vũ Đình Bách | 0978707214 |
| customer10@example.com | `$2b$10$custhash10` | Phạm Hoàng Long | 0973855860 |

## 🧪 Test Cases

### 1. Test API Endpoints
**URL**: http://localhost:3000/api-test.html

### 2. Test Products
```bash
# Get all products
curl http://localhost:3000/api/products

# Get product by ID
curl http://localhost:3000/api/products/1
```

### 3. Test Categories
```bash
# Get all categories
curl http://localhost:3000/api/categories
```

### 4. Test Vouchers
```bash
# Get all vouchers
curl http://localhost:3000/api/vouchers

# Validate voucher
curl -X POST http://localhost:3000/api/vouchers/validate \
  -H "Content-Type: application/json" \
  -d '{"code":"KM01","orderTotal":100000}'
```

### 5. Test Customer Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"customer1@example.com","password":"$2b$10$custhash01"}'
```

### 6. Test Admin Login
```bash
curl -X POST http://localhost:3000/api/admin/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### 7. Test Orders (Admin)
```bash
# Get all orders
curl http://localhost:3000/api/admin/orders

# Get order detail
curl http://localhost:3000/api/admin/orders/1
```

## 📊 Expected Results

### Products (10 items)
- Bánh 1 - 55,000đ
- Bánh 2 - 450,000đ
- Bánh Kem Matcha - 360,000đ
- Su Kem - 15,000đ
- Macaron Set - 180,000đ
- Trà Đào - 45,000đ
- ...

### Categories (10 items with hierarchy)
- Cakes (parent)
  - Cheesecakes (child)
  - Tiramisu (child)
- Cupcakes (parent)
  - Cookies (child)
  - Brownies (child)
  - Macarons (child)
- Bánh Trung Thu
- Nước uống
- Phụ kiện sinh nhật

### Orders (10 completed orders)
- All orders: status = "completed"
- Subtotal: 150,000đ
- Shipping: 15,000đ
- Total: 165,000đ

### Deliveries (10 deliveries)
- Mix of self-delivery and gift delivery
- Example:
  - Order 1: Delivered to customer 1 (self)
  - Order 2: Delivered to "Lê Hoàng Nam" (gift)
  - Order 3: Delivered to customer 3 (self)
  - Order 4: Delivered to "Trần Minh Đức" (gift)

### Reviews (10 reviews)
- All 5 stars
- Various comments

## 🔍 Database Verification

### Check data in SQLite
```bash
# Open database
sqlite3 hamt-pastry.db

# Check tables
.tables

# Check customers
SELECT * FROM CUSTOMER;

# Check orders
SELECT * FROM ORDERS;

# Check deliveries with receiver info
SELECT o.order_id, c.username as buyer, d.receiver_name, d.receiver_phone 
FROM ORDERS o 
LEFT JOIN CUSTOMER c ON o.customer_id = c.customer_id 
LEFT JOIN DELIVERY d ON o.order_id = d.order_id;

# Exit
.quit
```

## ✅ Success Criteria

- ✅ All 10 customers can login
- ✅ Admin can login
- ✅ All products are visible
- ✅ Categories show parent-child relationship
- ✅ All vouchers are active
- ✅ All orders are completed
- ✅ Deliveries show mix of self and gift delivery
- ✅ All reviews are 5 stars

## 🐛 Troubleshooting

### Issue: Cannot login
- Check password hash matches
- Verify email exists in database

### Issue: No products showing
- Run `node setup-database.js` again
- Check `is_active = 1` in PRODUCT table

### Issue: Orders not showing
- Check foreign keys are valid
- Verify customer_id exists in CUSTOMER table

