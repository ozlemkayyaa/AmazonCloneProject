const jwt = require('jsonwebtoken');

// Kullanıcıların kimliğini doğrulamak için middleware fonksiyonu
const auth = async (req,res,next) => {
    try {
        // İstek başlığından token'ı al
        const token = req.header("x-auth-token");

        // Eğer token sağlanmamışsa, yetkisiz durumu ile cevap ver
        if(!token) 
        return res.status(401).json({msg: "No auth token, authorization denied!"});

        // Token'ı önceden tanımlanmış bir secret key kullanarak doğrula
        const verified = jwt.verify(token, 'passwordKey');

        // Eğer token doğrulama başarısız olursa, yetkisiz durumu ile cevap ver
        if (!verified) 
            return res.status(401).json({msg: "Token verification failed, authorization denied!"}); 

        // Doğrulanmış kullanıcı ID'sini ve token'ı istek objesine ekle
        req.user = verified.id;
        req.token = token;
        next(); // Bir sonraki middleware fonksiyonuna veya route handler'a geç

    } catch (err) {
        // Token doğrulama sırasında oluşan hataları işle ve sunucu hatası durumu ile cevap ver
        res.status(500).json({error: err.message});
    }
};

// Bu middleware'i uygulamanın diğer bölümlerinde kullanmak üzere export et
module.exports = auth;