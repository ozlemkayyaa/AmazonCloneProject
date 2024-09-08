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
<img src = "https://github.com/user-attachments/assets/5cb973f9-e466-480c-95fa-5cddd33eadf9" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/eddbf0b8-af8c-4ff5-a52e-31df849fc6c8" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/6fa655b7-8ead-4967-8adf-5f6fb7ce35b0" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/45d1c223-5a7a-43ea-9e9c-cd5918ec0449b" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/7d8125fc-e01b-4eaf-996f-4090aa0caa9b" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/4d8194c5-335b-415e-a3ee-055816dc4d7c" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/31677f18-1232-40eb-97bc-ab28d85ab482" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/9ab91350-7bfa-4510-a0ac-2df816a40c77" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/aef948f7-0899-488e-b323-c01ba6dfe417" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/c7617c55-2d47-40ce-8f30-d0bf90a5979b" alt="alt text" width="150">

### Admin
<img src = "https://github.com/user-attachments/assets/f8b11324-cf46-4233-b080-99b3311cb6c1" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/1330f27f-8ce1-44b9-af51-477d75a970e4" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/189058df-5d02-4fa3-b831-a120924c352d" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/6772f903-f3d1-4cda-8ee1-e57d85afbcf4" alt="alt text" width="150">
<img src = "https://github.com/user-attachments/assets/23efbadf-f00d-44c7-a834-c2ae2e6fd283" alt="alt text" width="150">

#

Bu projeyi öğrenmemde bana yardımcı olan videoyu izlemek isterseniz aşağıya linkini bırakıyorum.
- https://www.youtube.com/watch?v=O3nmP-lZAdg&t=40183s

Son olarak, bu videoyu hazırlayan [RivaanRanawat](https://github.com/RivaanRanawat?tab=overview&from=2024-07-01&to=2024-07-30)'a teşekkürlerimi sunarım.
