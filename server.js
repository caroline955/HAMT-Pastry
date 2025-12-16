const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const port = 3000;

// 1. Cấu hình thư mục chứa giao diện (Lưu ý: Public viết hoa chữ P nếu thư mục là Public)
app.use(express.static(path.join(__dirname, 'Public')));
app.use(express.json());

// 2. Kết nối Database
// LƯU Ý QUAN TRỌNG: Bạn nhớ thay các thông tin bên dưới bằng thông tin thật của Database Online nhé
const db = mysql.createConnection({
    host: 'ten-host-dai-ngoang.services.clever-cloud.com', 
    user: 'ten-user-online',
    password: 'mat-khau-online',
    database: 'ten-database-online',
    port: 3306 
});

db.connect(err => {
    if (err) console.log('Lỗi kết nối SQL:', err);
    else console.log('Đã kết nối MySQL thành công!');
});

// 3. API lấy danh sách sản phẩm
app.get('/api/products', (req, res) => {
    const sql = "SELECT * FROM products";
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// API lấy chi tiết 1 sản phẩm (Cần thêm cái này để trang Detail chạy)
app.get('/api/products/:id', (req, res) => {
    const id = req.params.id;
    const sql = "SELECT * FROM products WHERE id = ?";
    db.query(sql, [id], (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length === 0) return res.status(404).json({message: "Not found"});
        res.json(results[0]);
    });
});

// 4. Chạy Server
app.listen(port, () => {
    console.log(`Web đang chạy tại: http://localhost:${port}`);
});