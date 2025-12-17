const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const port = 3000;

// 1. SỬA LỖI ĐƯỜNG DẪN: Public viết hoa
app.use(express.static(path.join(__dirname, 'Public')));
app.use(express.json());

// 2. SỬA LỖI DATABASE: Điền thông tin thật của bạn vào đây
const db = mysql.createConnection({
    host: 'localhost',      // Hoặc host online của bạn
    user: 'root',           // User MySQL
    password: '',           // Mật khẩu MySQL
    database: 'bakery_db',  // Tên Database
    port: 3306
}); // Đã xóa chữ "có" thừa ở đây

db.connect(err => {
    if (err) console.log('Lỗi kết nối SQL:', err);
    else console.log('Đã kết nối MySQL thành công!');
});

// API lấy danh sách sản phẩm
app.get('/api/products', (req, res) => {
    const sql = "SELECT * FROM products";
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// API lấy chi tiết sản phẩm (cần cho trang product-detail.html)
app.get('/api/products/:id', (req, res) => {
    const id = req.params.id;
    const sql = "SELECT * FROM products WHERE id = ?";
    db.query(sql, [id], (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length === 0) return res.status(404).json({message: "Not found"});
        res.json(results[0]);
    });
});

app.listen(port, () => {
    console.log(`Web đang chạy tại: http://localhost:${port}`);
});