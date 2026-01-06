SELECT 
    p.name AS [Tên Bánh],
    r.rating AS [Số Sao],
    r.comment AS [Nội Dung],
    c.full_name AS [Người Đánh Giá]
FROM HAMT_SHOP.REVIEW r
JOIN HAMT_SHOP.PRODUCT p ON r.product_id = p.product_id
JOIN HAMT_SHOP.CUSTOMER c ON r.customer_id = c.customer_id
ORDER BY r.rating DESC;

SELECT 
    c.full_name AS [Họ Tên Khách Hàng],
    m.rank_level AS [Hạng],
    FORMAT(m.total_spending, 'N0') + ' VND' AS [Tổng Chi Tiêu],
    c.phone_number AS [Số Điện Thoại]
FROM HAMT_SHOP.CUSTOMER c
JOIN HAMT_SHOP.MEMBERSHIP m ON c.customer_id = m.customer_id
ORDER BY m.total_spending DESC;

SELECT 
    o.order_id AS [Mã Đơn],
    c.full_name AS [Người Đặt],
    d.receiver_name AS [Người Nhận],
    d.shipping_address AS [Địa Chỉ Giao],
    d.shipping_status AS [Trạng Thái]
FROM HAMT_SHOP.DELIVERY d
JOIN HAMT_SHOP.ORDERS o ON d.order_id = o.order_id
JOIN HAMT_SHOP.CUSTOMER c ON o.customer_id = c.customer_id
WHERE d.receiver_name <> c.full_name;