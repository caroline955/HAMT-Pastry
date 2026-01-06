const express = require("express");
const Database = require("better-sqlite3");
const path = require("path");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.static("public"));

const dbPath = path.join(__dirname, "hamt-pastry.db");
const db = new Database(dbPath);
db.pragma("foreign_keys = ON");

console.log("🎯 HAMT PASTRY - Full E-commerce System");
console.log("✅ Database: SQLite\n");

// Get all products
app.get("/api/products", (req, res) => {
  try {
    const products = db.prepare("SELECT * FROM PRODUCT WHERE is_active = 1").all();
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get product by id
app.get("/api/products/:id", (req, res) => {
  try {
    const product = db.prepare("SELECT * FROM PRODUCT WHERE product_id = ?").get(req.params.id);
    if (product) {
      res.json(product);
    } else {
      res.status(404).json({ error: "Product not found" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all categories
app.get("/api/categories", (req, res) => {
  try {
    const categories = db.prepare("SELECT * FROM CATEGORY").all();
    res.json(categories);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all vouchers
app.get("/api/vouchers", (req, res) => {
  try {
    const vouchers = db.prepare("SELECT * FROM VOUCHER WHERE is_active = 1").all();
    res.json(vouchers);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Validate voucher
app.post("/api/vouchers/validate", (req, res) => {
  try {
    const { code, orderTotal } = req.body;
    const voucher = db.prepare("SELECT * FROM VOUCHER WHERE code = ? AND is_active = 1").get(code);
    
    if (!voucher) {
      return res.status(404).json({ error: "Voucher không tồn tại" });
    }
    
    if (orderTotal < voucher.min_order_value) {
      return res.status(400).json({ 
        error: `Đơn hàng tối thiểu ${voucher.min_order_value.toLocaleString()}đ` 
      });
    }
    
    let discountAmount = 0;
    if (voucher.discount_type === "percent") {
      discountAmount = (orderTotal * voucher.discount_value) / 100;
      if (voucher.max_discount && discountAmount > voucher.max_discount) {
        discountAmount = voucher.max_discount;
      }
    } else {
      discountAmount = voucher.discount_value;
    }
    
    res.json({ valid: true, voucher, discountAmount });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GUEST CHECKOUT
app.post("/api/orders/guest", (req, res) => {
  try {
    const { items, delivery, payment, voucher_code } = req.body;
    
    if (!items || items.length === 0) {
      return res.status(400).json({ error: "Giỏ hàng trống" });
    }
    
    if (!delivery || !delivery.name || !delivery.phone || !delivery.address) {
      return res.status(400).json({ error: "Thiếu thông tin giao hàng" });
    }
    
    let subtotal = 0;
    for (const item of items) {
      const product = db.prepare("SELECT price FROM PRODUCT WHERE product_id = ?").get(item.product_id);
      if (!product) {
        return res.status(404).json({ error: `Sản phẩm ${item.product_id} không tồn tại` });
      }
      subtotal += product.price * item.quantity;
    }
    
    const shipping_fee = 30000;
    let discount_amount = 0;
    let voucher_id = null;
    
    if (voucher_code) {
      const voucher = db.prepare("SELECT * FROM VOUCHER WHERE code = ? AND is_active = 1").get(voucher_code);
      if (voucher && subtotal >= voucher.min_order_value) {
        voucher_id = voucher.voucher_id;
        if (voucher.discount_type === "percent") {
          discount_amount = (subtotal * voucher.discount_value) / 100;
          if (voucher.max_discount && discount_amount > voucher.max_discount) {
            discount_amount = voucher.max_discount;
          }
        } else {
          discount_amount = voucher.discount_value;
        }
      }
    }
    
    const total_amount = subtotal + shipping_fee - discount_amount;
    
    const transaction = db.transaction(() => {
      const orderResult = db.prepare(`INSERT INTO ORDERS (customer_id, status, subtotal, shipping_fee, discount_amount, total_amount, voucher_id) VALUES (?, ?, ?, ?, ?, ?, ?)`).run(null, "pending", subtotal, shipping_fee, discount_amount, total_amount, voucher_id);
      const order_id = orderResult.lastInsertRowid;
      for (const item of items) {
        const product = db.prepare("SELECT price FROM PRODUCT WHERE product_id = ?").get(item.product_id);
        const line_total = product.price * item.quantity;
        db.prepare(`INSERT INTO ORDER_ITEM (order_id, product_id, quantity, unit_price_at_time, line_total) VALUES (?, ?, ?, ?, ?)`).run(order_id, item.product_id, item.quantity, product.price, line_total);
      }
      db.prepare(`INSERT INTO DELIVERY (order_id, receiver_name, receiver_phone, shipping_address, shipping_status) VALUES (?, ?, ?, ?, ?)`).run(order_id, delivery.name, delivery.phone, delivery.address, "preparing");
      db.prepare(`INSERT INTO PAYMENT (order_id, method, transaction_status, amount) VALUES (?, ?, ?, ?)`).run(order_id, payment.method || "COD", "pending", total_amount);
      return order_id;
    });
    const order_id = transaction();
    res.json({ success: true, order_id, message: "Đặt hàng thành công!" });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: error.message });
  }
});

