# Amazon Clone

Bu projede, Amazon uygulamasının klonunu yapmayı amaçladım, kullanıcı ve yönetici paneli geliştirmek için kullanılan teknolojileri öğrendim ve uyguladım. Bu sayede aşağıdaki özellikleri kapsayan bir uygulama oluşturdum:

### Özellikler
- E-posta ve Şifre ile Kimlik Doğrulama
- Kimlik Doğrulama Durumunun Korunması
- Ürün Arama
- Ürünleri Kategorilere Göre Filtreleme
- Ürün Detayları
- Ürün Değerlendirme
- Günün Fırsatı
- Sepet
- Google/Apple Pay ile Ödeme
- Siparişlerimi Görüntüleme
- Sipariş Detaylarını ve Durumunu Görüntüleme
- Oturumu Kapatma

### Yönetici Paneli
- Tüm Ürünleri Görüntüleme
- Ürün Ekleme
- Ürün Silme
- Siparişleri Görüntüleme
- Sipariş Durumunu Değiştirme
- Toplam Kazancı Görüntüleme

## Projeyi Yerel Olarak Çalıştırma
- Bu depoyu klonladıktan sonra flutter-amazon-clone-tutorial klasörüne geçin. Aşağıdaki adımları izleyin:
- MongoDB Projesi ve Kümesi Oluşturun.
- Connect butonuna tıklayın ve yönergeleri takip ederek uri'yi elde edin. Bu uri'yi server/index.js dosyasında değiştirin.
- lib/constants/global_variables.dart dosyasına gidip IP adresinizi değiştirin.
- Cloudinary Projesi oluşturun ve ayarlardan unsigned operation'u etkinleştirin.
- lib/features/admin/services/admin_services.dart dosyasına gidip, denfgaxvg ve uszbstnu ile belirtilen alanları sırasıyla Cloud Name ve Upload Preset ile değiştirin.
- Ardından aşağıdaki komutları çalıştırın:

### Sunucu Tarafı (Server)
1. cd server
2. npm install
3. npm run dev (sürekli geliştirme için)
veya
4. npm start (tek seferlik çalıştırma için)

### İstemci Tarafı (Client)
1. flutter pub get
2. flutter run

## Kullanılan Teknolojiler
- Sunucu: Node.js, Express, Mongoose, MongoDB, Cloudinary
- İstemci: Flutter, Provider

## UI 

### User
<img src = "https://github.com/user-attachments/assets/40b620ce-e9b7-4ff0-a982-d89e9f4b034d" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/d6cc4868-467d-433f-98cb-25467ea86804" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/8d37d183-a9da-460f-be84-bb66383b2269" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/fd493ff0-9784-4591-b266-7690254eb42b" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/53f442bd-2f2c-45ec-88bb-eb34c066fa36" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/7d9bbb03-f058-4288-b7d4-2bb8f2d11af8" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/a5ebc383-871e-4d68-a733-24fd04b99747" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/a5ed6a36-ceaa-4b9d-a591-9b4a68061596" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/a41dce2e-8998-4a9d-be1f-f020500dadc7" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/da6b0c41-b19b-45f0-af3a-135a97bef419" alt="alt text" width="150">

### Admin
<img src = "https://github.com/user-attachments/assets/205617fb-3703-4534-8c93-456b19b0681f" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/4b5986d7-7740-4d9f-b963-0f43e85ec2fa" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/25b7573f-315f-4592-9140-d2c2a4984c9a" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/0a25231e-d716-4072-b47c-fe04f5d05ad9" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/fa0f866f-c27a-4229-992f-45c96f7e8b36" alt="alt text" width="150">

#

Bu projeyi öğrenmemde bana yardımcı olan videoyu izlemek isterseniz aşağıya linkini bırakıyorum.
- https://www.youtube.com/watch?v=O3nmP-lZAdg&t=40183s

Son olarak, bu videoyu hazırlayan [RivaanRanawat](https://github.com/RivaanRanawat?tab=overview&from=2024-07-01&to=2024-07-30)'a teşekkürlerimi sunarım.
