const express = require('express');
const userRouter = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');
const User = require("../models/user");
const Order = require('../models/order');

// ADD TO CART
userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body; // İstek gövdesinden ürün ID'sini alıyoruz
        const product = await Product.findById(id); // Veritabanından ürünü ID ile buluyoruz
        let user = await User.findById(req.user); // İstekten gelen kullanıcıyı buluyoruz

        // Kullanıcının sepeti boşsa, ürünü sepete ekliyoruz
        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 }); // Sepete ürün ve miktar ekliyoruz
        } else {
            let isProductFound = false; // Ürünün sepette olup olmadığını kontrol etmek için bayrak

            // Sepetteki ürünleri kontrol ediyoruz
            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(product._id)) {
                    isProductFound = true; // Ürün sepette bulunursa bayrağı ayarlıyoruz
                }
            }

            // Ürün sepette bulunuyorsa, miktarı artırıyoruz
            if (isProductFound) {
                let producttt = user.cart.find((productt) =>
                productt.product._id.equals(product._id)
                );
                producttt.quantity += 1; // Ürün miktarını artırıyoruz
            } else {
                // Ürün sepette bulunmuyorsa, yeni ürünü sepete ekliyoruz
                user.cart.push({ product, quantity: 1 });
            }
        }

        // Kullanıcıyı güncellenmiş sepet ile kaydediyoruz
        user = await user.save();
        res.json(user); // Güncellenmiş kullanıcıyı JSON olarak döndürüyoruz

    } catch (error) {
        // Hata durumunda 500 kodu ile hata mesajını geri gönderme
        res.status(500).json({ error: error.message });
    }
});

// DELETE PRODUCT
userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {
    try {
        const { id } = req.params; // URL parametrelerinden ürün id al
        const product = await Product.findById(id); // Ürünü id'ye göre bul
        let user = await User.findById(req.user); // İstek nesnesinden kullanıcı idsine göre kullanıcıyı bul

         // Kullanıcının sepetini döngüye al
        for (let i = 0; i < user.cart.length; i++) {
            // Sepetteki mevcut ürünün silinecek ürünle eşleşip eşleşmediğini kontrol et
            if (user.cart[i].product._id.equals(product._id)) {
                if (user.cart[i].quantity == 1) {
                    // Miktar 1 ise, ürünü sepetten kaldır
                    user.cart.splice(i, 1);
                } else {
                    // Miktar 1'den fazlaysa, miktarı 1 azalt
                    user.cart[i].quantity -= 1;
                }
            }
        } 
        user = await user.save(); // Güncellenmiş kullanıcı belgesini kaydet
        res.json(user); // Güncellenmiş kullanıcı belgesini yanıt olarak gönder
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// SAVE USER ADDRESS
userRouter.post('/api/save-user-address', auth, async (req, res) => {
    try {
        const {address} = req.body; // İstek gövdesinden adresi al
        let user =  await User.findById(req.user); // İstek nesnesinden kullanıcı idsine göre kullanıcıyı bul
        user.address = address; // Kullanıcının adresini güncelle
        user = await user.save(); // Güncellenmiş kullanıcı belgesini kaydet
        res.json(user);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// ORDER PRODUCT
userRouter.post('/api/order', auth, async (req, res) => {
    try {
        const {cart, totalPrice, address} = req.body; // İstek gövdesinden sepet, toplam fiyat ve adresi al
        let products = [];
        
        // İstek gövdesinden sepet, toplam fiyat ve adresi al
        for (let i = 0; i < cart.length; i++) {
            let product = await Product.findById(cart[i].product._id); // Ürünü id'ye göre bul
            if (product.quantity >= cart[i].quantity){
                 // Ürün yeterli miktarda ise, miktarı azalt
                product.quantity -= cart[i].quantity;
                products.push({product, quantity: cart[i].quantity}); // Ürünü ve miktarını products dizisine ekle
                await product.save(); // Güncellenmiş ürün belgesini kaydet
            } else {
                return res.status(400).json({msg: `${product.name} is out of stock!`}); // Ürün stokta yoksa 400 hata yanıtı gönder
            }
        }

        let user = await User.findById(req.user); // İstek nesnesinden kullanıcı idsine göre kullanıcıyı bul
        user.cart = []; // Kullanıcının sepetini temizle
        user = await user.save(); // Güncellenmiş kullanıcı belgesini kaydet

        // Sağlanan detaylarla yeni bir sipariş oluştur
        let order = new Order ({
            products,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        });
        order = await order.save(); // Yeni sipariş belgesini kaydet
        res.json(order);// Yeni sipariş belgesini yanıt olarak gönder
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// USER ORDER
// Kullanıcının kendi siparişlerini almak için bir GET isteği tanımlar
userRouter.get('/api/orders/me', auth, async (req, res) => {
    try {
        // Kullanıcının kimliğini 'req.user' üzerinden alarak ilgili siparişleri sorgular
        const orders = await Order.find({ userId: req.user });
        
        // Siparişleri JSON formatında döner
        res.json(orders);
    } catch (error) {
        // Hata oluşursa, HTTP 500 (İç Sunucu Hatası) kodu ile hata mesajını döner
        res.status(500).json({ error: error.message });
    }
});

module.exports = userRouter;