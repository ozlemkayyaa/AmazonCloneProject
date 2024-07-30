import 'package:amazon/models/user.dart';
import 'package:flutter/material.dart';

// UserProvider, uygulama genelinde kullanıcı bilgilerini yöneten bir state management sınıfıdır.
// ChangeNotifier'ı extend ederek, değişiklik olduğunda dinleyicilere haber verir.
class UserProvider extends ChangeNotifier {
  // _user, varsayılan değerleri boş stringler olan bir User nesnesi ile başlatılır.
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  // user getter'ı, _user nesnesinin dışarıya açık olan kısmını sağlar.
  User get user => _user;

  // setUser, JSON formatındaki bir kullanıcı bilgisini alır, User nesnesine dönüştürür ve
  // _user değişkenini günceller. Değişiklik olduğunda dinleyicileri bilgilendirir.
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners(); // Dinleyicilere değişiklik olduğunu bildirir.
  }

  // setUserFromModel, mevcut User modelini alır ve _user değişkenini bu yeni kullanıcı
  // modeli ile günceller. Değişiklik olduğunda dinleyicilere haber verir.
  void setUserFromModel(User user) {
    _user = user; // _user değişkenini yeni User modeli ile günceller.
    notifyListeners(); // Dinleyicilere değişiklik olduğunu bildirir.
  }
}
