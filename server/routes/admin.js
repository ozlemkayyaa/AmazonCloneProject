const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const { Product } = require('../models/product');
const Order = require('../models/order');

// ADD PRODUCT
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        // İstek gövdesinden ürün bilgilerini al
        const {name, description, images, quantity, price, category} = req.body;

        // Yeni bir ürün oluştur
        let product = new Product({
            name, description, images, quantity, price, category,
        });

         // Ürünü veritabanına kaydet
        product = await product.save();

        // Kaydedilen ürünü JSON formatında geri gönder
        res.json(product);

    } catch (error) {
        // Hata durumunda 500 kodu ile hata mesajını geri gönder
        res.status(500).json({error: e.message});
    }
});

// GET PRODUCT
adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        // Veritabanından tüm ürünleri bul
        const products = await Product.find({});

        // Ürünleri JSON formatında geri gönder
        res.json(products);
    } catch (e) {
        // Hata durumunda 500 kodu ile hata mesajını geri gönder
        res.status(500).json({error: e.message});
    }
});

// DELETE PRODUCT
adminRouter.post('/admin/delete-products', admin, async (req, res) => {
    try {
        // İstek gövdesinden ürün ID'sini al
        const {id} = req.body;

        // Veritabanından ürünü ID'ye göre sil
        let product = await Product.findByIdAndDelete(id);

        // Silinen ürünü JSON formatında geri gönder
        res.json(product);
    } catch (e) {
        // Hata durumunda 500 kodu ile hata mesajını geri gönder
        res.status(500).json({error: e.message});
    }
});

// GET ORDER
adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        // Veritabanından tüm siparişleri bul
        const orders = await Order.find({});

        // Siparişleri JSON formatında geri gönder
        res.json(orders);
    } catch (e) {
        // Hata durumunda 500 kodu ile hata mesajını geri gönder
        res.status(500).json({error: e.message});
    }
});


// CHANGE ORDER STATUS
adminRouter.post('/admin/change-order-status', admin, async (req, res) => {
    try {
        const {id, status} = req.body;
        let order = await Order.findById(id);
        order.status = status;
        order = await order.save();
        res.json(order);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for(let i = 0; i < orders.length; i++) {
            for (let j =0; j < orders[i].products.length; j++) {
                totalEarnings += 
                orders[i].products[j].quantity * 
                orders[i].products[j].product.price;
            }
        }
        // CATEGORY WISE ORDER FETCHING
        let mobileEarnings = await fetchCategoryWiseProduct('Mobiles');
        let essentialsEarnings = await fetchCategoryWiseProduct('Essentials');
        let appliancesEarnings = await fetchCategoryWiseProduct('Appliances');
        let booksEarnings = await fetchCategoryWiseProduct('Books');
        let fashionEarnings = await fetchCategoryWiseProduct('Fashion');
        
        let earnings = {
            totalEarnings,
            mobileEarnings,
            essentialsEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings,
        };

        res.json(earnings);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

async function fetchCategoryWiseProduct(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({
        "products.product.category": category
    });

    for(let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            earnings += 
            categoryOrders[i].products[j].quantiity * 
            categoryOrders[i].products[j].product.price;
        }
    }
    return earnings;
}

// adminRouter modülü dışa aktarılır, böylece diğer dosyalarda kullanılabilir.
module.exports = adminRouter;