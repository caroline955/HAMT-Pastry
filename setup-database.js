const Database = require("better-sqlite3");
const path = require("path");

const dbPath = path.join(__dirname, "hamt-pastry.db");
const db = new Database(dbPath);

console.log("🎯 Tạo database schema đầy đủ...\n");

// Enable foreign keys
db.pragma("foreign_keys = ON");

// ============================================
// DROP TABLES (đúng thứ tự để không vướng FK)
// ============================================
db.exec(`
  DROP TABLE IF EXISTS REVIEW;
  DROP TABLE IF EXISTS VOUCHER_REDEMPTION;
  DROP TABLE IF EXISTS DELIVERY;
  DROP TABLE IF EXISTS PAYMENT;
  DROP TABLE IF EXISTS ORDER_ITEM;
  DROP TABLE IF EXISTS ORDERS;
  DROP TABLE IF EXISTS MEMBERSHIP;
  DROP TABLE IF EXISTS VOUCHER;
  DROP TABLE IF EXISTS PRODUCT;
  DROP TABLE IF EXISTS CATEGORY;
  DROP TABLE IF EXISTS CUSTOMER;
  DROP TABLE IF EXISTS ADMINS;
`);

// ============================================
// CREATE TABLES
// ============================================

// 1. ADMINS
db.exec(`
  CREATE TABLE ADMINS (
    admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name TEXT,
    role TEXT CHECK (role IN ('manager', 'staff')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
`);

// 2. CUSTOMER
db.exec(`
  CREATE TABLE CUSTOMER (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone_number TEXT NOT NULL
  )
`);

// 3. MEMBERSHIP
db.exec(`
  CREATE TABLE MEMBERSHIP (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL UNIQUE,
    rank_level TEXT DEFAULT 'Đồng',
    total_spending REAL DEFAULT 0,
    assigned_by_admin INTEGER,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (assigned_by_admin) REFERENCES ADMINS(admin_id)
  )
`);

// 4. CATEGORY
db.exec(`
  CREATE TABLE CATEGORY (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    parent_id INTEGER,
    created_by_admin INTEGER,
    FOREIGN KEY (parent_id) REFERENCES CATEGORY(category_id),
    FOREIGN KEY (created_by_admin) REFERENCES ADMINS(admin_id)
  )
`);

// 5. PRODUCT
db.exec(`
  CREATE TABLE PRODUCT (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL CHECK (price >= 0),
    is_active INTEGER DEFAULT 1,
    image_url TEXT,
    category_id INTEGER,
    created_by_admin INTEGER,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
    FOREIGN KEY (created_by_admin) REFERENCES ADMINS(admin_id)
  )
`);

// 6. VOUCHER
db.exec(`
  CREATE TABLE VOUCHER (
    voucher_id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    discount_type TEXT CHECK (discount_type IN ('percent', 'fixed')),
    discount_value REAL NOT NULL,
    min_order_value REAL DEFAULT 0,
    max_discount REAL,
    usage_limit INTEGER DEFAULT 1,
    start_at DATETIME,
    end_at DATETIME,
    is_active INTEGER DEFAULT 1,
    created_by_admin INTEGER,
    FOREIGN KEY (created_by_admin) REFERENCES ADMINS(admin_id)
  )
`);

// 7. ORDERS
db.exec(`
  CREATE TABLE ORDERS (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    order_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    subtotal REAL NOT NULL,
    shipping_fee REAL DEFAULT 0,
    discount_amount REAL DEFAULT 0,
    total_amount REAL NOT NULL,
    voucher_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (voucher_id) REFERENCES VOUCHER(voucher_id)
  )
`);

// 8. ORDER_ITEM
db.exec(`
  CREATE TABLE ORDER_ITEM (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_at_time REAL NOT NULL,
    line_total REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
  )
`);

// 9. DELIVERY
db.exec(`
  CREATE TABLE DELIVERY (
    delivery_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL UNIQUE,
    admin_id INTEGER,
    receiver_name TEXT NOT NULL,
    receiver_phone TEXT NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_status TEXT CHECK (shipping_status IN ('preparing', 'shipping', 'delivered', 'returned')),
    estimated_arrival DATETIME,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (admin_id) REFERENCES ADMINS(admin_id)
  )
`);

// 10. PAYMENT
db.exec(`
  CREATE TABLE PAYMENT (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    method TEXT,
    transaction_status TEXT,
    amount REAL NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
  )
`);

// 11. VOUCHER_REDEMPTION
db.exec(`
  CREATE TABLE VOUCHER_REDEMPTION (
    redemption_id INTEGER PRIMARY KEY AUTOINCREMENT,
    voucher_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (voucher_id) REFERENCES VOUCHER(voucher_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
  )
`);

// 12. REVIEW
db.exec(`
  CREATE TABLE REVIEW (
    review_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    order_item_id INTEGER NOT NULL UNIQUE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id),
    FOREIGN KEY (order_item_id) REFERENCES ORDER_ITEM(item_id)
  )
`);

console.log("✅ Đã tạo tất cả các bảng!\n");

// ============================================
// INSERT SAMPLE DATA (Khớp với dataHAMT.sql)
// ============================================

console.log("📦 Đang insert dữ liệu mẫu...\n");

// 1. Insert ADMINS
const insertAdmin = db.prepare(`
  INSERT INTO ADMINS (username, password_hash, full_name, role)
  VALUES (?, ?, ?, ?)
`);
insertAdmin.run("admin", "$2b$10$adminhash01", "Shop Admin", "manager");
console.log("✅ Đã tạo 1 admin account");

// 2. Insert CUSTOMERS (10 customers)
const insertCustomer = db.prepare(`
  INSERT INTO CUSTOMER (full_name, username, password_hash, email, phone_number)
  VALUES (?, ?, ?, ?, ?)
`);

const customers = [
  ["Nguyễn Thị Thu Trang", "customer1", "$2b$10$custhash01", "customer1@example.com", "0970717355"],
  ["Giang Lê Hiệp", "customer2", "$2b$10$custhash02", "customer2@example.com", "0985131377"],
  ["Lưu Trần Tâm Anh", "customer3", "$2b$10$custhash03", "customer3@example.com", "0972498494"],
  ["Nguyễn Huyền My", "customer4", "$2b$10$custhash04", "customer4@example.com", "0970643907"],
  ["Trần Đặng Thu Hương", "customer5", "$2b$10$custhash05", "customer5@example.com", "0978161301"],
  ["Phùng Đức Duy", "customer6", "$2b$10$custhash06", "customer6@example.com", "0988837457"],
  ["Vũ Thị Minh Phương", "customer7", "$2b$10$custhash07", "customer7@example.com", "0935488219"],
  ["Phạm Hà Chi", "customer8", "$2b$10$custhash08", "customer8@example.com", "0934784691"],
  ["Vũ Đình Bách", "customer9", "$2b$10$custhash09", "customer9@example.com", "0978707214"],
  ["Phạm Hoàng Long", "customer10", "$2b$10$custhash10", "customer10@example.com", "0973855860"]
];

for (const customer of customers) {
  insertCustomer.run(...customer);
}
console.log("✅ Đã tạo 10 customers");

// 3. Insert MEMBERSHIP (10 memberships)
const insertMembership = db.prepare(`
  INSERT INTO MEMBERSHIP (customer_id, rank_level, total_spending, assigned_by_admin, updated_at)
  VALUES (?, ?, ?, ?, ?)
`);

insertMembership.run(1, "Bronze", 200000.0, 1, "2026-01-02 09:00:00");
for (let i = 2; i <= 10; i++) {
  insertMembership.run(i, "Silver", 500000.0, 1, "2026-01-02 09:00:00");
}
console.log("✅ Đã tạo 10 memberships");

// 4. Insert CATEGORIES (10 categories)
const insertCategory = db.prepare(`
  INSERT INTO CATEGORY (name, parent_id, created_by_admin)
  VALUES (?, ?, ?)
`);

const categories = [
  ["Cakes", null, 1],
  ["Cupcakes", null, 1],
  ["Cheesecakes", 1, 1],
  ["Tiramisu", 1, 1],
  ["Cookies", 2, 1],
  ["Brownies", 2, 1],
  ["Macarons", 2, 1],
  ["Bánh Trung Thu", null, 1],
  ["Nước uống", null, 1],
  ["Phụ kiện sinh nhật", null, 1]
];

for (const category of categories) {
  insertCategory.run(...category);
}
console.log("✅ Đã tạo 10 categories");

// 5. Insert VOUCHERS (10 vouchers)
const insertVoucher = db.prepare(`
  INSERT INTO VOUCHER (code, discount_type, discount_value, min_order_value, usage_limit, is_active, created_by_admin)
  VALUES (?, ?, ?, ?, ?, ?, ?)
`);

for (let i = 1; i <= 10; i++) {
  insertVoucher.run(`KM0${i}`, "percent", 10, 50000, 100, 1, 1);
}
console.log("✅ Đã tạo 10 vouchers");

// 6. Insert PRODUCTS (10 products)
const insertProduct = db.prepare(`
  INSERT INTO PRODUCT (name, description, price, is_active, category_id, created_by_admin)
  VALUES (?, ?, ?, ?, ?, ?)
`);

const products = [
  ["Bánh 1", "Handmade 1", 55000, 1, 2, 1],
  ["Bánh 2", "Handmade 2", 450000, 1, 5, 1],
  ["Bánh 3", "Handmade 3", 55000, 1, 2, 1],
  ["Bánh Kem Matcha", "Trà xanh Nhật Bản", 360000, 1, 4, 1],
  ["Su Kem", "Nhân vani", 15000, 1, 2, 1],
  ["Bánh Mì Hoa Cúc", "Thơm bơ", 120000, 1, 7, 1],
  ["Macaron Set", "Đủ vị", 180000, 1, 7, 1],
  ["Trà Đào", "Giải nhiệt", 45000, 1, 9, 1],
  ["Bánh Nướng", "Truyền thống", 85000, 1, 8, 1],
  ["Nến sinh nhật", "Đủ số", 5000, 1, 10, 1]
];

for (const product of products) {
  insertProduct.run(...product);
}
console.log("✅ Đã tạo 10 products");

// 7. Insert ORDERS (10 orders)
const insertOrder = db.prepare(`
  INSERT INTO ORDERS (customer_id, order_datetime, status, subtotal, shipping_fee, discount_amount, total_amount, voucher_id)
  VALUES (?, ?, ?, ?, ?, ?, ?, ?)
`);

for (let i = 1; i <= 10; i++) {
  const subtotal = 150000;
  const shipping_fee = 15000;
  const discount_amount = 0;
  const total_amount = subtotal + shipping_fee - discount_amount;
  insertOrder.run(i, "2026-01-02", "completed", subtotal, shipping_fee, discount_amount, total_amount, null);
}
console.log("✅ Đã tạo 10 orders");

// 8. Insert ORDER_ITEM (10 order items)
const insertOrderItem = db.prepare(`
  INSERT INTO ORDER_ITEM (order_id, product_id, quantity, unit_price_at_time, line_total)
  VALUES (?, ?, ?, ?, ?)
`);

const orderItems = [
  [1, 10, 3, 120000],
  [2, 2, 1, 150000],
  [3, 3, 1, 150000],
  [4, 4, 1, 150000],
  [5, 5, 1, 150000],
  [6, 6, 1, 150000],
  [7, 7, 1, 150000],
  [8, 8, 1, 150000],
  [9, 1, 2, 55000],
  [10, 8, 1, 45000]
];

for (const item of orderItems) {
  const [order_id, product_id, quantity, unit_price] = item;
  const line_total = quantity * unit_price;
  insertOrderItem.run(order_id, product_id, quantity, unit_price, line_total);
}
console.log("✅ Đã tạo 10 order items");

// 9. Insert DELIVERY (10 deliveries - đan xen người mua và người tặng)
const insertDelivery = db.prepare(`
  INSERT INTO DELIVERY (order_id, admin_id, receiver_name, receiver_phone, shipping_address, shipping_status, estimated_arrival)
  VALUES (?, ?, ?, ?, ?, ?, ?)
`);

const deliveries = [
  [1, 1, "Nguyễn Thị Thu Trang", "0396145723", "Địa chỉ 1", "delivered", "2026-01-04"],
  [2, 1, "Lê Hoàng Nam", "0912345678", "Địa chỉ 2", "delivered", "2026-01-04"],
  [3, 1, "Lưu Trần Tâm Anh", "972498494", "Địa chỉ 3", "delivered", "2026-01-04"],
  [4, 1, "Trần Minh Đức", "0988776655", "Địa chỉ 4", "delivered", "2026-01-04"],
  [5, 1, "Trần Đặng Thu Hương", "978161301", "Địa chỉ 5", "delivered", "2026-01-04"],
  [6, 1, "Phan Anh Tuấn", "0911223344", "Địa chỉ 6", "delivered", "2026-01-04"],
  [7, 1, "Vũ Thị Minh Phương", "935488219", "Địa chỉ 7", "delivered", "2026-01-04"],
  [8, 1, "Đỗ Mỹ Linh", "0909090909", "Địa chỉ 8", "delivered", "2026-01-04"],
  [9, 1, "Vũ Đình Bách", "978707214", "Địa chỉ 9", "delivered", "2026-01-04"],
  [10, 1, "Lý Hải", "0977889900", "Địa chỉ 10", "delivered", "2026-01-04"]
];

for (const delivery of deliveries) {
  insertDelivery.run(...delivery);
}
console.log("✅ Đã tạo 10 deliveries");

// 10. Insert REVIEW (10 reviews)
const insertReview = db.prepare(`
  INSERT INTO REVIEW (customer_id, product_id, order_item_id, rating, comment, created_at)
  VALUES (?, ?, ?, ?, ?, ?)
`);

const reviews = [
  [1, 10, 1, 5, "Bánh ngon lắm!", "2026-01-05"],
  [2, 2, 2, 5, "Sẽ ủng hộ tiếp!", "2026-01-05"],
  [3, 3, 3, 5, "Tuyệt vời!", "2026-01-05"],
  [4, 4, 4, 5, "Rất hài lòng!", "2026-01-05"],
  [5, 5, 5, 5, "Chất lượng tốt!", "2026-01-05"],
  [6, 6, 6, 5, "Bánh thơm!", "2026-01-05"],
  [7, 7, 7, 5, "Giao nhanh!", "2026-01-05"],
  [8, 8, 8, 5, "Đóng gói đẹp!", "2026-01-05"],
  [9, 1, 9, 5, "Bánh mỳ hoa cúc siêu ngon!", "2026-01-05"],
  [10, 8, 10, 5, "10 điểm!", "2026-01-05"]
];

for (const review of reviews) {
  insertReview.run(...review);
}
console.log("✅ Đã tạo 10 reviews");

console.log("\n========================================");
console.log("✅ HOÀN THÀNH! Database đã sẵn sàng!");
console.log("📊 Tổng kết:");
console.log("   - 1 Admin");
console.log("   - 10 Customers");
console.log("   - 10 Memberships");
console.log("   - 10 Categories");
console.log("   - 10 Vouchers");
console.log("   - 10 Products");
console.log("   - 10 Orders");
console.log("   - 10 Order Items");
console.log("   - 10 Deliveries");
console.log("   - 10 Reviews");
console.log("========================================\n");

db.close();

