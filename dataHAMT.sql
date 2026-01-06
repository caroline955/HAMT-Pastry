-- ==========================================
-- NHẬP DỮ LIỆU MẪU CHO HAMT_SHOP (10 DÒNG/BẢNG)
-- ==========================================

-- 1. NẠP DỮ LIỆU BẢNG ADMINS
SET IDENTITY_INSERT HAMT_SHOP.ADMINS ON;
INSERT INTO HAMT_SHOP.ADMINS (admin_id, username, password_hash, full_name, role) 
VALUES (1, 'admin', '$2b$10$adminhash01', N'Shop Admin', 'manager');
SET IDENTITY_INSERT HAMT_SHOP.ADMINS OFF;
GO

-- 2. NẠP DỮ LIỆU BẢNG CUSTOMER
SET IDENTITY_INSERT HAMT_SHOP.CUSTOMER ON;
INSERT INTO HAMT_SHOP.CUSTOMER (customer_id, full_name, username, password_hash, email, phone_number) VALUES 
(1, N'Nguyễn Thị Thu Trang', 'customer1', '$2b$10$custhash01', 'customer1@example.com', '0970717355'),
(2, N'Giang Lê Hiệp', 'customer2', '$2b$10$custhash02', 'customer2@example.com', '0985131377'),
(3, N'Lưu Trần Tâm Anh', 'customer3', '$2b$10$custhash03', 'customer3@example.com', '0972498494'),
(4, N'Nguyễn Huyền My', 'customer4', '$2b$10$custhash04', 'customer4@example.com', '0970643907'),
(5, N'Trần Đặng Thu Hương', 'customer5', '$2b$10$custhash05', 'customer5@example.com', '0978161301'),
(6, N'Phùng Đức Duy', 'customer6', '$2b$10$custhash06', 'customer6@example.com', '0988837457'),
(7, N'Vũ Thị Minh Phương', 'customer7', '$2b$10$custhash07', 'customer7@example.com', '0935488219'),
(8, N'Phạm Hà Chi', 'customer8', '$2b$10$custhash08', 'customer8@example.com', '0934784691'),
(9, N'Vũ Đình Bách', 'customer9', '$2b$10$custhash09', 'customer9@example.com', '0978707214'),
(10, N'Phạm Hoàng Long', 'customer10', '$2b$10$custhash10', 'customer10@example.com', '0973855860');
SET IDENTITY_INSERT HAMT_SHOP.CUSTOMER OFF;
GO

-- 3. NẠP DỮ LIỆU BẢNG MEMBERSHIP
SET IDENTITY_INSERT HAMT_SHOP.MEMBERSHIP ON;
INSERT INTO HAMT_SHOP.MEMBERSHIP (membership_id, customer_id, rank_level, total_spending, assigned_by_admin, updated_at) VALUES 
(1, 1, 'Bronze', 200000.0, 1, '2026-01-02 09:00:00'),
(2, 2, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(3, 3, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(4, 4, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(5, 5, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(6, 6, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(7, 7, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(8, 8, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(9, 9, 'Silver', 500000.0, 1, '2026-01-02 09:00:00'),
(10, 10, 'Silver', 500000.0, 1, '2026-01-02 09:00:00');
SET IDENTITY_INSERT HAMT_SHOP.MEMBERSHIP OFF;
GO

-- 4. NẠP DỮ LIỆU BẢNG CATEGORY
SET IDENTITY_INSERT HAMT_SHOP.CATEGORY ON;
INSERT INTO HAMT_SHOP.CATEGORY (category_id, name, parent_id, created_by_admin) VALUES 
(1, N'Cakes', NULL, 1), (2, N'Cupcakes', NULL, 1), (3, N'Cheesecakes', 1, 1),
(4, N'Tiramisu', 1, 1), (5, N'Cookies', 2, 1), (6, N'Brownies', 2, 1),
(7, N'Macarons', 2, 1), (8, N'Bánh Trung Thu', NULL, 1), (9, N'Nước uống', NULL, 1), (10, N'Phụ kiện sinh nhật', NULL, 1);
SET IDENTITY_INSERT HAMT_SHOP.CATEGORY OFF;
GO

-- 5. NẠP DỮ LIỆU BẢNG VOUCHER (Bổ sung 10 Voucher để khớp các đơn hàng)
SET IDENTITY_INSERT HAMT_SHOP.VOUCHER ON;
INSERT INTO HAMT_SHOP.VOUCHER (voucher_id, code, discount_type, discount_value, min_order_value, usage_limit, is_active, created_by_admin) VALUES 
(1, 'KM01', 'percent', 10, 50000, 100, 1, 1), (2, 'KM02', 'percent', 10, 50000, 100, 1, 1),
(3, 'KM03', 'percent', 10, 50000, 100, 1, 1), (4, 'KM04', 'percent', 10, 50000, 100, 1, 1),
(5, 'KM05', 'percent', 10, 50000, 100, 1, 1), (6, 'KM06', 'percent', 10, 50000, 100, 1, 1),
(7, 'KM07', 'percent', 10, 50000, 100, 1, 1), (8, 'KM08', 'percent', 10, 50000, 100, 1, 1),
(9, 'KM09', 'percent', 10, 50000, 100, 1, 1), (10, 'KM10', 'percent', 10, 50000, 100, 1, 1);
SET IDENTITY_INSERT HAMT_SHOP.VOUCHER OFF;
GO

-- 6. NẠP DỮ LIỆU BẢNG PRODUCT
SET IDENTITY_INSERT HAMT_SHOP.PRODUCT ON;
INSERT INTO HAMT_SHOP.PRODUCT (product_id, name, description, price, is_active, category_id, created_by_admin) VALUES 
(1, N'Bánh 1', N'Handmade 1', 55000, 1, 2, 1), (2, N'Bánh 2', N'Handmade 2', 450000, 1, 5, 1),
(3, N'Bánh 3', N'Handmade 3', 55000, 1, 2, 1), (4, N'Bánh Kem Matcha', N'Trà xanh Nhật Bản', 360000, 1, 4, 1),
(5, N'Su Kem', N'Nhân vani', 15000, 1, 2, 1), (6, N'Bánh Mì Hoa Cúc', N'Thơm bơ', 120000, 1, 7, 1),
(7, N'Macaron Set', N'Đủ vị', 180000, 1, 7, 1), (8, N'Trà Đào', N'Giải nhiệt', 45000, 1, 9, 1),
(9, N'Bánh Nướng', N'Truyền thống', 85000, 1, 8, 1), (10, N'Nến sinh nhật', N'Đủ số', 5000, 1, 10, 1);
SET IDENTITY_INSERT HAMT_SHOP.PRODUCT OFF;
GO

-- 7. NẠP DỮ LIỆU BẢNG ORDERS
SET IDENTITY_INSERT HAMT_SHOP.ORDERS ON;
INSERT INTO HAMT_SHOP.ORDERS (order_id, customer_id, order_datetime, status, subtotal, shipping_fee, discount_amount, voucher_id) VALUES 
(1, 1, '2026-01-02', 'completed', 150000, 15000, 0, NULL), (2, 2, '2026-01-02', 'completed', 150000, 15000, 0, NULL),
(3, 3, '2026-01-02', 'completed', 150000, 15000, 0, NULL), (4, 4, '2026-01-02', 'completed', 150000, 15000, 0, NULL),
(5, 5, '2026-01-02', 'completed', 150000, 15000, 0, NULL), (6, 6, '2026-01-02', 'completed', 150000, 15000, 0, NULL),
(7, 7, '2026-01-02', 'completed', 150000, 15000, 0, NULL), (8, 8, '2026-01-02', 'completed', 150000, 15000, 0, NULL),
(9, 9, '2026-01-02', 'completed', 150000, 15000, 0, NULL), (10, 10, '2026-01-02', 'completed', 150000, 15000, 0, NULL);
SET IDENTITY_INSERT HAMT_SHOP.ORDERS OFF;
GO

-- 8. NẠP DỮ LIỆU BẢNG ORDER_ITEM
SET IDENTITY_INSERT HAMT_SHOP.ORDER_ITEM ON;
INSERT INTO HAMT_SHOP.ORDER_ITEM (item_id, order_id, product_id, quantity, unit_price_at_time) VALUES 
(1, 1, 10, 3, 120000), (2, 2, 2, 1, 150000), (3, 3, 3, 1, 150000), (4, 4, 4, 1, 150000), (5, 5, 5, 1, 150000),
(6, 6, 6, 1, 150000), (7, 7, 7, 1, 150000), (8, 8, 8, 1, 150000), (9, 9, 1, 2, 55000), (10, 10, 8, 1, 45000);
SET IDENTITY_INSERT HAMT_SHOP.ORDER_ITEM OFF;
GO

-- 9. NẠP DỮ LIỆU BẢNG DELIVERY (Đan xen người mua và người tặng khác nhau)
SET IDENTITY_INSERT HAMT_SHOP.DELIVERY ON;
INSERT INTO HAMT_SHOP.DELIVERY (delivery_id, order_id, admin_id, receiver_name, receiver_phone, shipping_address, shipping_status, estimated_arrival) VALUES 
(1, 1, 1, N'Nguyễn Thị Thu Trang', '0396145723', N'Địa chỉ 1', 'delivered', '2026-01-04'),
(2, 2, 1, N'Lê Hoàng Nam', '0912345678', N'Địa chỉ 2', 'delivered', '2026-01-04'), -- Khác customer
(3, 3, 1, N'Lưu Trần Tâm Anh', '972498494', N'Địa chỉ 3', 'delivered', '2026-01-04'),
(4, 4, 1, N'Trần Minh Đức', '0988776655', N'Địa chỉ 4', 'delivered', '2026-01-04'), -- Khác customer
(5, 5, 1, N'Trần Đặng Thu Hương', '978161301', N'Địa chỉ 5', 'delivered', '2026-01-04'),
(6, 6, 1, N'Phan Anh Tuấn', '0911223344', N'Địa chỉ 6', 'delivered', '2026-01-04'), -- Khác customer
(7, 7, 1, N'Vũ Thị Minh Phương', '935488219', N'Địa chỉ 7', 'delivered', '2026-01-04'),
(8, 8, 1, N'Đỗ Mỹ Linh', '0909090909', N'Địa chỉ 8', 'delivered', '2026-01-04'), -- Khác customer
(9, 9, 1, N'Vũ Đình Bách', '978707214', N'Địa chỉ 9', 'delivered', '2026-01-04'),
(10, 10, 1, N'Lý Hải', '0977889900', N'Địa chỉ 10', 'delivered', '2026-01-04'); -- Khác customer
SET IDENTITY_INSERT HAMT_SHOP.DELIVERY OFF;
GO

-- 10. NẠP DỮ LIỆU BẢNG REVIEW
SET IDENTITY_INSERT HAMT_SHOP.REVIEW ON;
INSERT INTO HAMT_SHOP.REVIEW (review_id, customer_id, product_id, order_item_id, rating, comment, created_at) VALUES 
(1, 1, 10, 1, 5, N'Bánh ngon lắm!', '2026-01-05'), (2, 2, 2, 2, 5, N'Sẽ ủng hộ tiếp!', '2026-01-05'),
(3, 3, 3, 3, 5, N'Tuyệt vời!', '2026-01-05'), (4, 4, 4, 4, 5, N'Rất hài lòng!', '2026-01-05'),
(5, 5, 5, 5, 5, N'Chất lượng tốt!', '2026-01-05'), (6, 6, 6, 6, 5, N'Bánh thơm!', '2026-01-05'),
(7, 7, 7, 7, 5, N'Giao nhanh!', '2026-01-05'), (8, 8, 8, 8, 5, N'Đóng gói đẹp!', '2026-01-05'),
(9, 9, 1, 9, 5, N'Bánh mỳ hoa cúc siêu ngon!', '2026-01-05'), (10, 10, 8, 10, 5, N'10 điểm!', '2026-01-05');
SET IDENTITY_INSERT HAMT_SHOP.REVIEW OFF;
GO