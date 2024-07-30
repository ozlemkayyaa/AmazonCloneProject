// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products
          .map((x) => x.toMap())
          .toList(), // Product nesnelerini Map formatına dönüştür
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '', // Map'ten id bilgisini al, yoksa boş string
      products: List<Product>.from(map['products']?.map((x) => Product.fromMap(
          x['product']))), // Ürünleri Map formatından Product nesnesine dönüştür
      quantity: List<int>.from(
        map['products']?.map(
          (x) => x['quantity'], // Her ürünün miktarını al
        ),
      ),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  // Nesneyi JSON formatında bir string'e dönüştürür
  String toJson() => json.encode(toMap()); // JSON encode işlemi yapar

  // JSON formatındaki string'den bir Order nesnesi oluşturur
  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source)); // JSON decode ve map dönüşümü yapar
}
