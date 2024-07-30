// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/product.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  // Bu fonksiyon, belirli bir kategorideki ürünleri sunucudan alır.
  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    // Kullanıcı verilerini sağlayıcıdan (Provider) alır.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Alınan ürünleri saklamak için bir liste oluşturur.
    List<Product> productList = [];

    try {
      // Sunucudan veri almak için HTTP GET isteği yapar.
      http.Response res = await http
          .get(Uri.parse('$uri/api/products/search/$searchQuery'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':
            userProvider.user.token, // Kimlik doğrulama için token ekler.
      });

      // HTTP isteği başarılı olduğunda verileri işler.
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Gelen yanıtın her bir öğesini Product modeline dönüştürür ve listeye ekler.
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Bir hata oluşursa, kullanıcıya hata mesajını gösterir.
      showSnackBar(context, e.toString());
    }
    // Alınan ürünlerin listesini döndürür.
    return productList;
  }
}
