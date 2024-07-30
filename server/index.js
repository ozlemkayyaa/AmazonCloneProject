// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");

// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

// INIT
const PORT = process.env.PORT || 3000;
const app = express();
const DB = "mongoDB URL BURAYA YAZ";

// MIDDLEWARE
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
/* 
app.use(authRouter); ifadesi, authRouter yönlendiricisini uygulamaya bağlar. 
Bu, authRouter içinde tanımlanan tüm yolların ve işleyicilerin (handler) uygulama tarafından kullanılabilir hale gelmesini sağlar.
*/

// CONNECTIONS
mongoose.connect(DB).then(() => {
    console.log("Connected to MongoDB");
}).catch(e => {
    console.log(e);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is running on port ${PORT}`)
});

/*
Sunucuyu Dinleme: app.listen fonksiyonu, uygulamanın belirtilen port üzerinde dinlemeye başlamasını sağlar. 
Sunucu başlatıldığında konsola bir mesaj yazdırılır.
*/