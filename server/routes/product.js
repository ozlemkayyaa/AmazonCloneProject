const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require("../models/product");

// Ürünleri almak için GET isteği
productRouter.get("/api/products/", auth, async (req, res) => {
    try {
        // Veritabanından, sorgu parametresine göre kategoriyi filtreleyerek ürünleri bulur
        const products = await Product.find({ category: req.query.category });
        // Bulunan ürünleri JSON formatında yanıt olarak döndürür
        res.json(products);
    } catch (e) {
        // Bir hata oluşursa, 500 durum kodu ve hata mesajı ile yanıt verir
        res.status(500).json({ error: e.message });
    }
});

// Ürün aramak için GET isteği
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
    try {
        // Ürün adını içeren ürünleri bulmak için regex kullanılır
        const products = await Product.find({ 
            name: { $regex: req.params.name, $options: "i" }, // Büyük/küçük harf duyarsız arama
        });
        // Bulunan ürünleri JSON formatında yanıt olarak döndürür
        res.json(products);
    } catch (e) {
        // Bir hata oluşursa, 500 durum kodu ve hata mesajı ile yanıt verir
        res.status(500).json({ error: e.message });
    }
});

// Ürünü puanlamak için POST isteği
productRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        const { id, rating } = req.body; // İstek gövdesinden ürün ID'si ve rating alınır
        let product = await Product.findById(id); // ID'ye göre ürünü bul

        // Daha önce bu kullanıcı tarafından verilmiş bir rating varsa, onu kaldır
        for (let i = 0; i < product.ratings.length; i++) {
            if (product.ratings[i].userId == req.user) {
                product.ratings.splice(i, 1);
                break;
            }
        }

        // Yeni rating bilgilerini ekle
        const ratingSchema = {
            userId: req.user, 
            rating,
        };
        product.ratings.push(ratingSchema);

        // Ürünü güncelleyip kaydet
        product = await product.save();
        // Güncellenmiş ürünü JSON formatında yanıt olarak döndür
        res.json(product);
    } catch (e) {
        // Bir hata oluşursa, 500 durum kodu ve hata mesajı ile yanıt verir
        res.status(500).json({ error: e.message });
    }
});

// Günün fırsatı olan ürünü almak için GET isteği
productRouter.get("/api/deal-of-day", auth, async (req, res) => {
    try {
        let products = await Product.find({}); // Tüm ürünleri bul

        // Ürünleri toplam rating'e göre sıralar
        products = products.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;

            // İlk ürünün toplam rating'ini hesaplar
            for (let i = 0; i < a.ratings.length; i++) {
                aSum += a.ratings[i].rating;
            }

            // İkinci ürünün toplam rating'ini hesaplar
            for (let i = 0; i < b.ratings.length; i++) {
                bSum += b.ratings[i].rating;
            }

            // Toplam rating'e göre karşılaştırma yapar
            return aSum < bSum ? 1 : -1; // Büyüğe göre sıralama
        });

        // En yüksek rating'e sahip ürünü JSON formatında yanıt olarak döndürür
        res.json(products[0]);
    } catch (e) {
        // Bir hata oluşursa, 500 durum kodu ve hata mesajı ile yanıt verir
        res.status(500).json({ error: e.message });
    }
});

module.exports = productRouter;
