const express = require("express"); // Sunucu uygulaması oluşturmak için
const User = require("../models/user"); // Kullanıcı modelini içeren dosyayı projeye dahil eder. Bu model MongoDB ile etkileşim kurarak kullanıcı verilerini yönetir.
const bcryptjs = require("bcryptjs"); // Kullanıcı şifrelerini güvenli bir şekilde hash'ler.
const jwt = require("jsonwebtoken"); // Kullanıcıların kimliklerini doğrulamak için kullanılır.
const auth = require("../middlewares/auth");
const authRouter = express.Router(); // Kimlik doğrulama ile ilgili yönlendirmeleri tanımlamak için kullanılır.

// SIGN UP 
authRouter.post('/api/signup', async (req, res) => {
    try {
        // İstek gövdesinden isim, e-posta ve şifre bilgilerini alır.
        const { name, email, password } = req.body;

        // Veritabanında bu e-posta adresine sahip bir kullanıcı olup olmadığını kontrol eder.
        const existingUser = await User.findOne({ email });
        // Eğer aynı e-posta adresine sahip bir kullanıcı varsa, hata mesajı ile birlikte 400 durum kodu döndürür.
        if (existingUser) {
            return res.status(400).json({ msg: "User with same email already exists!" });
        }

        // Kullanıcının şifresini güvenli bir şekilde hash'ler. İkinci parametre olarak verilen 8, saltRound değeridir.
        const hashedPassword = await bcryptjs.hash(password, 8);

        // Yeni bir kullanıcı nesnesi oluşturur ve verilen bilgilerle doldurur.
        let user = new User({
            email,
            password: hashedPassword, // Hash'lenmiş şifreyi kullanır.
            name,
        });

        // Yeni kullanıcıyı veritabanına kaydeder ve kaydedilen kullanıcıyı değişkene atar.
        user = await user.save();
        // Kayıt başarılı olursa, kullanıcı bilgilerini içeren bir JSON nesnesi döndürür.
        res.json(user);
    } catch (e) {
        // Herhangi bir hata oluşursa, hata mesajı ile birlikte 500 durum kodu döndürür.
        res.status(500).json({ error: e.message });
    }
});

// SIGN IN 
authRouter.post('/api/signin', async (req, res) => {
    try {
        // İstek gövdesinden e-posta ve şifre bilgilerini alır.
        const { email, password } = req.body;

        // Veritabanında bu e-posta adresine sahip bir kullanıcı olup olmadığını kontrol eder.
        const user = await User.findOne({ email });
        // Eğer kullanıcı bulunamazsa, hata mesajı ile birlikte 400 durum kodu döndürür.
        if (!user) {
            return res.status(400).json({ msg: "User with this email does not exist!" });
        }

        // Kullanıcının girdiği şifre ile veritabanındaki hash'lenmiş şifreyi karşılaştırır.
        const isMatch = await bcryptjs.compare(password, user.password);
        // Şifreler uyuşmuyorsa, hata mesajı ile birlikte 400 durum kodu döndürür.
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password!" });
        }

        // Şifre doğruysa, kullanıcı için bir JWT (JSON Web Token) oluşturur.
        const token = jwt.sign({ id: user._id }, "passwordKey");
        // Oluşturulan token ve kullanıcı bilgilerini içeren bir JSON nesnesi döndürür.
        res.json({ token, ...user._doc });

    } catch (e) {
        // Herhangi bir hata oluşursa, hata mesajı ile birlikte 500 durum kodu döndürür.
        res.status(500).json({ error: e.message });
    }
});

// TOKEN VALIDATION
authRouter.post('/tokenIsValid', async (req, res) => {
    try {
        // İstek başlığından JWT token'ını alır.
        const token = req.header('x-auth-token');
        // Eğer token yoksa, geçersiz olarak işaretlenmiş bir JSON yanıt döndürür.
        if (!token) return res.json(false);
        // JWT token'ını doğrular.
        const verified = jwt.verify(token, 'passwordKey');
        // Eğer token doğrulanamazsa, geçersiz olarak işaretlenmiş bir JSON yanıt döndürür.
        if (!verified) return res.json(false);

        // JWT içindeki kullanıcı kimliği (verified.id) ile veritabanında kullanıcıyı arar.
        const user = await User.findById(verified.id);
        // Eğer kullanıcı bulunamazsa, geçersiz olarak işaretlenmiş bir JSON yanıt döndürür.
        if (!user) return res.json(false);
        // Kullanıcı bulunursa, geçerli olarak işaretlenmiş bir JSON yanıt döndürür.
        res.json(true);

    } catch (e) {
        // Herhangi bir hata oluşursa, hata mesajı ile birlikte 500 durum kodu döndürür.
        res.status(500).json({ error: e.message });
    }
});

// GET USER DATA
authRouter.get('/', auth, async (req, res) => {
    // Kimlik doğrulama middleware'i (auth) tarafından sağlanan kullanıcı kimliği (req.user) ile veritabanından kullanıcıyı arar.
    const user = await User.findById(req.user);
    // Kullanıcı bulunduysa, kullanıcı bilgilerini ve geçerli JWT token'ını içeren bir JSON nesnesi döndürür.
    res.json({...user._doc, token: req.token});
});

// auth.js dosyasını diğer dosyalardan kullanılabilir hale getirir. Bu sayede, sunucu uygulamasının diğer yerlerinde kimlik doğrulama işlemleri için authRouter'u kullanabilir.
module.exports = authRouter;