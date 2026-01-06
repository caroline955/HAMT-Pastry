// Test loading server.js to find syntax errors
console.log("Starting test...");

try {
  console.log("Step 1: Loading modules...");
  const express = require("express");
  const Database = require("better-sqlite3");
  const path = require("path");
  const cors = require("cors");
  console.log("✅ Modules loaded");

  console.log("Step 2: Creating app...");
  const app = express();
  console.log("✅ App created");

  console.log("Step 3: Setting up middleware...");
  app.use(cors());
  app.use(express.json());
  app.use(express.static("public"));
  console.log("✅ Middleware set up");

  console.log("Step 4: Connecting to database...");
  const dbPath = path.join(__dirname, "hamt-pastry.db");
  const db = new Database(dbPath);
  db.pragma("foreign_keys = ON");
  console.log("✅ Database connected");

  console.log("Step 5: Testing a simple query...");
  const result = db.prepare("SELECT COUNT(*) as count FROM CUSTOMER").get();
  console.log("✅ Query successful, customer count:", result.count);

  console.log("Step 6: Loading server.js...");
  // This will execute the file and show where it fails
  require("./server.js");
  
} catch (error) {
  console.error("❌ Error:", error.message);
  console.error("Stack:", error.stack);
  process.exit(1);
}

