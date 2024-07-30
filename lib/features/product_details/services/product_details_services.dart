// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/product.dart';
import 'package:amazon/models/user.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {
  // Sepete Ürün Ekleme
  void addToCart({
    required BuildContext context,
    required Product product, // Sepete eklenecek ürün
  }) async {
    // Kullanıcı bilgilerinin alındığı provider.
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // HTTP POST isteği gönderme.
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        // Gönderilecek veri (ürün ID'si).
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      // Hata işleme fonksiyonu.
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Başarılı olduğunda kullanıcı sepetini güncelle
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);

          // Güncellenmiş kullanıcıyı provider'a kaydet
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      // Hata durumunda kullanıcıya gösterilecek mesaj.
      showSnackBar(context, e.toString());
    }
  }

  // Ürüne Puan(Rating) Verme
  void rateProduct({
    required BuildContext context,
    required Product product, // Rating verilecek ürün.
    required double rating, // Kullanıcı tarafından verilen rating.
  }) async {
    // Kullanıcı bilgilerinin alındığı provider.
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // HTTP POST isteği gönderme.
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type':
              'application/json; charset=UTF-8', // JSON formatında veri gönderileceğini belirtir.
          'x-auth-token': userProvider.user.token, // Kullanıcının token'ı
        },
        // Gönderilecek veri (ürün ID'si ve rating).
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );

      // Hata işleme fonksiyonu.
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      // Hata durumunda kullanıcıya gösterilecek mesaj.
      showSnackBar(context, e.toString());
    }
  }
}
