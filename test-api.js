// Test all API endpoints
const BASE_URL = "http://localhost:3000";

async function testAPI(method, endpoint, body = null) {
  try {
    const options = {
      method,
      headers: { "Content-Type": "application/json" }
    };
    
    if (body) {
      options.body = JSON.stringify(body);
    }
    
    const response = await fetch(`${BASE_URL}${endpoint}`, options);
    const data = await response.json();
    
    console.log(`✅ ${method} ${endpoint}:`, response.status, data);
    return { success: true, data };
  } catch (error) {
    console.error(`❌ ${method} ${endpoint}:`, error.message);
    return { success: false, error: error.message };
  }
}

async function runTests() {
  console.log("🧪 Testing HAMT Pastry API...\n");
  
  // Test Admin Login
  console.log("1️⃣ Testing Admin Login...");
  await testAPI("POST", "/api/admin/login", {
    username: "admin",
    password: "admin123"
  });
  
  // Test Customer Login
  console.log("\n2️⃣ Testing Customer Login...");
  await testAPI("POST", "/api/auth/login", {
    email: "customer1@example.com",
    password: "$2b$10$custhash01"
  });
  
  // Test Products
  console.log("\n3️⃣ Testing Products...");
  await testAPI("GET", "/api/products");
  await testAPI("GET", "/api/products/1");
  
  // Test Categories
  console.log("\n4️⃣ Testing Categories...");
  await testAPI("GET", "/api/categories");
  
  // Test Vouchers
  console.log("\n5️⃣ Testing Vouchers...");
  await testAPI("GET", "/api/vouchers");
  await testAPI("POST", "/api/vouchers/validate", {
    code: "KM01",
    orderTotal: 100000
  });
  
  // Test Customers
  console.log("\n6️⃣ Testing Customers...");
  await testAPI("GET", "/api/customers");
  
  // Test Orders
  console.log("\n7️⃣ Testing Orders...");
  await testAPI("GET", "/api/orders");
  
  // Test Admin Orders
  console.log("\n8️⃣ Testing Admin Orders...");
  await testAPI("GET", "/api/admin/orders");
  await testAPI("GET", "/api/admin/orders/1");
  
  console.log("\n✅ All tests completed!");
}

// Run tests
runTests();

