// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:amazon/constants/error_handling.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/constants/utils.dart';
import 'package:amazon/models/user.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon/common/widgets/bottom_bar.dart';

class AuthService {
  // SIGN UP USER FUNCTION
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // User modelini kullanarak yeni bir kullanıcı nesnesi oluşturur.
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      // HTTP POST isteği ile kullanıcı kayıt endpoint'ine istek gönderir.
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // HTTP yanıtını işleyerek hata olup olmadığını kontrol eder ve onSuccess durumunda snackbar ile bildirim gösterir.
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context, 'Account created! Login with the same credentials!');
        },
      );
    } catch (e) {
      // Hata oluşursa snackbar ile hata mesajını gösterir.
      showSnackBar(context, e.toString());
    }
  }

  // SIGN IN USER FUNCTION
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final currentContext = context;
    try {
      // HTTP POST isteği ile kullanıcı giriş yapma endpoint'ine istek gönderir.
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // HTTP yanıtını işleyerek hata olup olmadığını kontrol eder ve onSuccess durumunda kullanıcı bilgilerini kaydeder ve ana ekrana yönlendirir.
      httpErrorHandle(
        response: res,
        context: currentContext,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = jsonDecode(res.body)['token'];
          if (token == null) {
            showSnackBar(currentContext, 'Token is null');
            return;
          }

          print('Token: $token'); // Debug print
          print('Response body: ${res.body}'); // Debug print
          // UserProvider ile kullanıcı durumunu günceller.
          Provider.of<UserProvider>(currentContext, listen: false)
              .setUser(res.body);
          // Alınan token'ı yerel depolamada kaydeder.
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          // Kullanıcıyı HomeScreen'e yönlendirir ve önceki tüm sayfaları yığından çıkarır.
          if (currentContext.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              currentContext,
              BottomBar.routeName,
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      // Hata oluşursa snackbar ile hata mesajını gösterir.
      showSnackBar(currentContext, e.toString());
    }
  }

  // GET USER DATA FUNCTION
  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      // SharedPreferences nesnesi oluşturarak yerel depolamaya erişim sağlar.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Yerel depolamadan 'x-auth-token' adlı token değerini alır.
      String? token = prefs.getString('x-auth-token');

      // Eğer token yoksa, yerel depolamada 'x-auth-token' için boş bir string kaydeder.
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      // Token'ın geçerli olup olmadığını kontrol etmek için HTTP POST isteği gönderir.
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      // Token geçerlilik yanıtını JSON olarak çözümler.
      var response = jsonDecode(tokenRes.body);

      // Eğer token geçerliyse, kullanıcı verilerini almak için HTTP GET isteği gönderir.
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // UserProvider aracılığıyla kullanıcı durumunu günceller.
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        // Yanıttan alınan kullanıcı verilerini UserProvider'a set eder.
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      // Hata oluşursa snackbar ile hata mesajını gösterir.
      showSnackBar(context, e.toString());
    }
  }
}
