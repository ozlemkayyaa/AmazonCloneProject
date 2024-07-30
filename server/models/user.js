const mongoose = require('mongoose');
const { productSchema } = require('./product');

// Mongoose şeması, MongoDB'deki User koleksiyonu için veri yapısını ve kurallarını tanımlar.
const userSchema = mongoose.Schema({
    // Kullanıcı adı alanı, zorunlu ve boşlukları kaldıran bir String tipindedir.
    name: {
        required: true,
        type: String,
        trim: true,
    },
    // E-posta alanı, zorunlu ve boşlukları kaldıran bir String tipindedir.
    // Ayrıca, geçerli bir e-posta adresi olup olmadığını kontrol eden bir doğrulama içerir.
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            // E-posta adresinin geçerli bir formatta olup olmadığını kontrol eden RegEx doğrulayıcısı.
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: 'Please enter a valid email address',
        }
    },
    // Şifre alanı, zorunlu bir String tipindedir ve en az 6 karakter uzunluğunda olmalıdır.
    password: {
        required: true,
        type: String,
        validate: {
            // Şifrenin uzunluğunu kontrol eden doğrulayıcı.
            validator: (value) => {
                return value.length >= 6;
            },
            message: 'Please enter a longer password',
        }
    },
    // Adres alanı, opsiyonel bir String tipindedir ve varsayılan değeri boş bir string'dir.
    address: {
        type: String,
        default: '',
    },
    // Kullanıcı tipi alanı, opsiyonel bir String tipindedir ve varsayılan değeri 'user'dır.
    type: {
        type: String,
        default: 'user',
    },
    // Kullanıcının sepeti, ürünlerin bulunduğu ve miktar bilgisinin yer aldığı bir dizi içerir.
    // Her ürün, productSchema şemasına göre tanımlanmıştır ve miktar bilgisi zorunludur.
    cart: [
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
            },
        },
    ],
});

// User modeli, userSchema şemasını kullanarak oluşturulur ve dışa aktarılır.
const User = mongoose.model("User", userSchema);
module.exports = User;