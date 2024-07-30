// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/models/order.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
// Kullanıcının siparişlerini almak için bir yöntem
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    // Kullanıcı sağlayıcısını al, dinleme kapalı
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList =
        []; // Siparişleri saklamak için boş bir liste oluştur

    try {
      // API'ye GET isteği gönder, kullanıcı token'ını başlığa ekle
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'), // API endpoint'ini oluştur
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // İstek başlığı
          'x-auth-token': userProvider.user.token, // Kullanıcı token'ını ekle
        },
      );

      // Gelen yanıtı işleyin
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // JSON yanıtını decode et ve siparişleri listeye ekle
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Hata oluşursa, bir snackbar ile hata mesajını göster
      showSnackBar(context, e.toString());
    }

    // Sipariş listesini döndür
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
