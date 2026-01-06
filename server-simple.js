const express = require("express");
const Database = require("better-sqlite3");
const path = require("path");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());
app.use(express.static("Public"));

const dbPath = path.join(__dirname, "hamt-pastry.db");
console.log("📂 Database path:", dbPath);

let db;
try {
  db = new Database(dbPath);
  db.pragma("foreign_keys = ON");
  console.log("✅ Database connected");
} catch (error) {
  console.error("❌ Database error:", error);
  process.exit(1);
}

// Test route
app.get("/", (req, res) => {
  res.send("Server is running!");
});

// Get all products
app.get("/api/products", (req, res) => {
  try {
    console.log("Getting products...");
    const products = db.prepare("SELECT * FROM PRODUCT WHERE is_active = 1").all();
    console.log("Found", products.length, "products");
    res.json(products);
  } catch (error) {
    console.error("Error getting products:", error);
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});

