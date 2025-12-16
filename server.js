const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const port = 3000;

// 1. Cấu hình để Server đọc được file HTML/CSS/Ảnh trong thư mục 'public'
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// 2. Kết nối Database (Điền thông tin SQL của bạn vào đây)
const db = mysql.createConnection({
    host: 'ten-host-dai-ngoang.services.clever-cloud.com', // Thay bằng Host online
    user: 'ten-user-online',
    password: 'mat-khau-online',
    database: 'ten-database-online',
    port: 3306 // Thường phải thêm cổng này
});có

db.connect(err => {
    if (err) console.log('Lỗi kết nối SQL:', err);
    else console.log('Đã kết nối MySQL thành công!');
});

// 3. Tạo API (Ví dụ API lấy danh sách sản phẩm cho trang Home)
app.get('/api/products', (req, res) => {
    const sql = "SELECT * FROM products"; // Giả sử bảng của bạn tên là products
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// 4. Chạy Server
app.listen(port, () => {
    console.log(`Web đang chạy tại: http://localhost:${port}`);
});