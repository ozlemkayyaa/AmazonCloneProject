import 'dart:convert';

// User sınıfı, kullanıcıya ait bilgileri temsil eder ve JSON serileştirme/deserileştirme işlemleri sağlar.
class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  // toMap, User nesnesini Map<String, dynamic> yapısına dönüştürür.
  // Bu, nesnenin JSON'a kolayca serileştirilmesini sağlar.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  // fromMap, Map<String, dynamic> yapısından bir User nesnesi oluşturur.
  // Bu, JSON'dan deserileştirme işlemi sırasında kullanılır.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      // cart verisini list of maps olarak dönüştürüyoruz.
      // Eğer cart alanı varsa, her bir öğeyi Map<String, dynamic> türüne dönüştürüp,
      // yeni bir liste oluşturuyoruz.
    );
  }

  // toJson, User nesnesini JSON string formatına dönüştürür.
  // json.encode metodu, Map yapısını JSON string'ine çevirir.
  String toJson() => json.encode(toMap());

  // fromJson, JSON string formatından bir User nesnesi oluşturur.
  // json.decode metodu, JSON string'ini Map yapısına çevirir ve fromMap ile User nesnesine dönüştürülür.
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // copyWith, mevcut User nesnesinin bir kopyasını oluşturmak ve belirli alanları güncellemek için kullanılır.
  // Bu, immutable nesnelerde değişiklik yapmanın bir yoludur. Orijinal nesne değişmeden kalır.
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
