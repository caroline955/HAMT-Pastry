/**
 * main.js - Quản lý toàn bộ logic Frontend của HAMT Pastry
 * Bao gồm: Navigation, Giỏ hàng, Fetch API, Render sản phẩm
 */

// --- 1. CÁC HÀM TIỆN ÍCH CHUNG (UTILS) ---

// Định dạng tiền tệ (VND)
const formatCurrency = (amount) => {
    return Number(amount).toLocaleString('vi-VN') + ' VND';
};

// Lấy giỏ hàng từ LocalStorage
const getCart = () => {
    const cart = localStorage.getItem('cart');
    return cart ? JSON.parse(cart) : [];
};

// Lưu giỏ hàng vào LocalStorage
const saveCart = (cart) => {
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartBadge(); // Cập nhật icon ngay khi lưu
};

// Cập nhật số lượng trên icon Giỏ hàng (Menu)
const updateCartBadge = () => {
    const badge = document.getElementById('cart-badge');
    if (!badge) return;

    const cart = getCart();
    const totalItems = cart.reduce((sum, item) => sum + (item.quantity || 1), 0);

    badge.textContent = totalItems;
    if (totalItems > 0) {
        badge.classList.remove('hidden');
        badge.classList.add('updated'); // Thêm hiệu ứng nảy
        setTimeout(() => badge.classList.remove('updated'), 500);
    } else {
        badge.classList.add('hidden');
    }
};

// Tự động Active Menu (Bôi đậm link trang hiện tại)
const setActiveNav = () => {
    const navLinks = document.querySelectorAll('.nav-links a');
    // Lấy tên file hiện tại, decode để xử lý ký tự %20 (khoảng trắng)
    const currentPage = decodeURIComponent(window.location.pathname.split("/").pop()) || 'home web.html';

    navLinks.forEach(link => {
        link.classList.remove('active');
        const href = link.getAttribute('href');

        // Logic so sánh
        if (href === currentPage) {
            link.classList.add('active');
        }
        
        // Trường hợp đặc biệt: Trang chi tiết vẫn active mục PRODUCT
        if ((currentPage === 'product-detail.html' || currentPage === 'collection.html') && href === 'products.html') {
            link.classList.add('active');
        }
    });
};

// --- 2. CÁC HÀM XỬ LÝ DỮ LIỆU SẢN PHẨM (API) ---

// Biến toàn cục lưu danh sách sản phẩm để dùng chung
let globalProducts = [];

// Hàm thêm vào giỏ hàng (Dùng chung cho nút Quick Add ở Home/Products)
const quickAddToCart = (productId) => {
    const product = globalProducts.find(p => p.id === productId);
    if (!product) return;

    const cart = getCart();
    const existingItem = cart.find(item => item.id === productId);

    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push({
            id: product.id,
            name: product.name,
            price: formatCurrency(product.price), // Lưu dạng chuỗi hiển thị
            rawPrice: product.price,             // Lưu giá gốc (số) để tính toán sau này
            image: product.image,
            quantity: 1
        });
    }

    saveCart(cart);
    alert(`Đã thêm "${product.name}" vào giỏ!`);
};

// --- 3. LOGIC CHO TỪNG TRANG ---

// -> TRANG CHỦ (Home)
const loadHomeProducts = async () => {
    const container = document.getElementById('best-seller-list');
    if (!container) return; // Nếu không phải trang home thì thoát

    try {
        const res = await fetch('/api/products');
        globalProducts = await res.json();
        
        // Lấy 3 sản phẩm đầu tiên
        const top3 = globalProducts.slice(0, 3);

        container.innerHTML = top3.map(p => `
            <div class="menu-item" onclick="window.location.href='product-detail.html?id=${p.id}'" style="cursor:pointer">
                <div class="menu-item-image">
                    <img src="${p.image}" alt="${p.name}" onerror="this.src='pic/berry.jpg'">
                </div>
                <h3>${p.name}</h3>
                <p class="price">${formatCurrency(p.price)}</p>
                <button class="add-btn" style="background:#8b7355; color:white; border:none; padding:5px 10px; margin-top:5px; cursor:pointer" 
                    onclick="event.stopPropagation(); quickAddToCart(${p.id})">
                    Thêm vào giỏ
                </button>
            </div>
        `).join('');
    } catch (err) {
        console.error(err);
        container.innerHTML = '<p style="text-align:center">Lỗi tải dữ liệu...</p>';
    }
};

// -> TRANG SẢN PHẨM (Products)
const loadAllProducts = async () => {
    const container = document.querySelector('.products-grid');
    if (!container) return;

    try {
        const res = await fetch('/api/products');
        globalProducts = await res.json();

        container.innerHTML = globalProducts.map(p => `
            <div class="product-card" onclick="window.location.href='product-detail.html?id=${p.id}'">
                <div class="product-image">
                    <img src="${p.image}" alt="${p.name}" onerror="this.src='pic/berry.jpg'">
                </div>
                <div class="product-info">
                    <div class="product-name">${p.name}</div>
                    <div class="product-description">Delicious cake</div>
                    <div class="product-price">${formatCurrency(p.price)}</div>
                    <button class="add-btn" style="width:100%; background:#8b7355; color:white; border:none; padding:8px; margin-top:10px; cursor:pointer" 
                        onclick="event.stopPropagation(); quickAddToCart(${p.id})">
                        Add to Cart
                    </button>
                </div>
            </div>
        `).join('');
    } catch (err) {
        console.error(err);
        container.innerHTML = '<p>Lỗi tải sản phẩm.</p>';
    }
};

// -> TRANG CHI TIẾT (Product Detail)
const loadProductDetail = async () => {
    if (!window.location.pathname.includes('product-detail.html')) return;

    const params = new URLSearchParams(window.location.search);
    const id = params.get('id');

    if (!id) {
        alert('Không tìm thấy sản phẩm!');
        window.location.href = 'products.html';
        return;
    }

    try {
        const res = await fetch(`/api/products/${id}`);
        const product = await res.json();

        // Điền dữ liệu vào HTML
        document.getElementById('product-title').textContent = product.name;
        document.getElementById('product-price').textContent = formatCurrency(product.price);
        document.getElementById('product-image').src = product.image;
        
        // Xử lý mô tả (nếu DB lưu chuỗi JSON mảng)
        /* Giả sử cột description trong DB lưu dạng: ["Mô tả 1", "Mô tả 2"]
           Nếu lưu text thường thì chỉ cần gán textContent
        */
        const descContainer = document.getElementById('product-description');
        try {
            const descArray = JSON.parse(product.description || '[]');
            if(Array.isArray(descArray)) {
                descContainer.innerHTML = '<ul>' + descArray.map(i => `<li>${i}</li>`).join('') + '</ul>';
            } else {
                descContainer.innerHTML = `<p>${product.description}</p>`;
            }
        } catch (e) {
            descContainer.innerHTML = `<p>${product.description || 'Thông tin đang cập nhật...'}</p>`;
        }

        // Gắn sự kiện cho nút Add to Cart to
        const btn = document.querySelector('.add-to-cart-btn');
        btn.onclick = () => {
            const cart = getCart();
            const existingItem = cart.find(item => item.id === product.id);

            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({
                    id: product.id,
                    name: product.name,
                    price: formatCurrency(product.price),
                    rawPrice: product.price,
                    image: product.image,
                    quantity: 1
                });
            }
            saveCart(cart);
            alert('Đã thêm vào giỏ hàng!');
            window.location.href = 'cart.html';
        };

    } catch (err) {
        console.error(err);
    }
};

// -> TRANG GIỎ HÀNG (Cart)
const renderCartPage = () => {
    const container = document.getElementById('cart-items');
    if (!container) return; // Không phải trang cart

    const cart = getCart();
    const countEl = document.getElementById('cart-count');
    const subtotalEl = document.getElementById('subtotal');

    if (cart.length === 0) {
        container.innerHTML = `<div class="empty-cart"><p>Giỏ hàng trống</p><a href="products.html">Mua sắm ngay</a></div>`;
        if(countEl) countEl.textContent = '(0)';
        if(subtotalEl) subtotalEl.textContent = '0 VND';
        return;
    }

    let total = 0;
    container.innerHTML = cart.map((item, index) => {
        // Tính tiền: Ưu tiên dùng rawPrice (số), nếu không có thì parse từ chuỗi
        let priceNum = item.rawPrice;
        if (!priceNum) {
            // Fallback: Nếu dữ liệu cũ lưu dạng "600.000VND" -> Xóa chữ lấy số
            priceNum = parseInt(String(item.price).replace(/\D/g, '')) || 0;
        }
        
        total += priceNum * item.quantity;

        return `
        <div class="cart-item">
            <div class="cart-item-image">
                <img src="${item.image}" alt="${item.name}">
            </div>
            <div class="cart-item-details">
                <div class="cart-item-name">${item.name}</div>
                <div class="cart-item-price">${item.price}</div>
                <div class="quantity-control">
                    <button onclick="updateCartQuantity(${index}, -1)">-</button>
                    <input type="number" value="${item.quantity}" readonly>
                    <button onclick="updateCartQuantity(${index}, 1)">+</button>
                </div>
            </div>
            <div class="cart-item-remove">
                <button class="remove-btn" onclick="removeCartItem(${index})">🗑️</button>
            </div>
        </div>
        `;
    }).join('');

    if(countEl) countEl.textContent = `(${cart.length})`;
    if(subtotalEl) subtotalEl.textContent = formatCurrency(total);
};

// Hàm phụ cho trang Cart (cần gán vào window để HTML gọi được)
window.updateCartQuantity = (index, change) => {
    const cart = getCart();
    cart[index].quantity += change;
    if (cart[index].quantity < 1) cart.splice(index, 1);
    saveCart(cart);
    renderCartPage();
};

window.removeCartItem = (index) => {
    const cart = getCart();
    cart.splice(index, 1);
    saveCart(cart);
    renderCartPage();
};


// --- 4. KHỞI CHẠY (MAIN) ---
document.addEventListener('DOMContentLoaded', () => {
    // 1. Chạy các hàm chung
    setActiveNav();
    updateCartBadge();

    // 2. Kiểm tra đang ở trang nào để chạy hàm tương ứng
    const path = decodeURIComponent(window.location.pathname);

    if (path.includes('home web.html') || path === '/') {
        loadHomeProducts();
    } 
    else if (path.includes('products.html')) {
        loadAllProducts();
    } 
    else if (path.includes('product-detail.html')) {
        loadProductDetail();
    } 
    else if (path.includes('cart.html')) {
        renderCartPage();
    }
});