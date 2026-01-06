// Test if server can start
try {
  console.log("Loading modules...");
  const express = require("express");
  const Database = require("better-sqlite3");
  const path = require("path");
  const cors = require("cors");
  
  console.log("Creating app...");
  const app = express();
  const PORT = 3000;
  
  console.log("Setting up middleware...");
  app.use(cors());
  app.use(express.json());
  app.use(express.static("public"));
  
  console.log("Connecting to database...");
  const dbPath = path.join(__dirname, "hamt-pastry.db");
  console.log("Database path:", dbPath);
  const db = new Database(dbPath);
  db.pragma("foreign_keys = ON");
  
  console.log("Database connected!");
  
  // Simple test endpoint
  app.get("/api/test", (req, res) => {
    res.json({ message: "Server is working!" });
  });
  
  console.log("Starting server...");
  app.listen(PORT, () => {
    console.log(`✅ Server started on http://localhost:${PORT}`);
  });
  
} catch (error) {
  console.error("❌ Error starting server:", error);
  process.exit(1);
}

