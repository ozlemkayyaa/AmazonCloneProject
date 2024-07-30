import 'package:amazon/common/widgets/custom_button.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/common/widgets/custom_textfield.dart';
import 'package:amazon/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

// Kimlik doğrulama durumlarını yönetmek için enum
enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Kullanıcı kayıt ve giriş durumunu tutan enum değişkeni
  Auth _auth = Auth.signup;
  // Form anahtarları
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  // Servis nesnesi
  final AuthService authService = AuthService();
  // Text editing controller'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // Controller'ları temizle
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  // Kullanıcı kayıt fonksiyonu
  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  // Kullanıcı giriş fonksiyonu
  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                // Kayıt olma seçeneği
                ListTile(
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: const Text(
                    "Create Account.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: Auth
                        .signup, // Radio butonunun değeri (kayıt olma durumu)
                    groupValue:
                        _auth, // Seçili olan radio butonunu belirleyen grup değeri
                    onChanged: (Auth? val) {
                      // Radio butonu değiştiğinde tetiklenen fonksiyon
                      setState(() {
                        _auth =
                            val!; // Seçilen değere göre _auth durumunu güncelle
                      });
                    },
                    activeColor: GlobalVariables
                        .secondaryColor, // Seçili radio butonunun rengi
                  ),
                ),
                // Kayıt formu
                if (_auth == Auth.signup) signUpForm(),
                // Giriş yapma seçeneği
                ListTile(
                  tileColor: _auth == Auth.signin
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: const Text(
                    "Sign-In.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: Auth
                        .signin, // Radio butonunun değeri (giriş yapma durumu)
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                    activeColor: GlobalVariables.secondaryColor,
                  ),
                ),
                // Giriş formu
                if (_auth == Auth.signin) signInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Kayıt formu widget'ı
  Widget signUpForm() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Form(
        key: _signUpFormKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              hintText: "Name",
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _emailController,
              hintText: "Email",
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _passwordController,
              hintText: "Password",
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Sign Up",
              onPressed: () {
                if (_signUpFormKey.currentState!.validate()) {
                  signUpUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Giriş formu widget'ı
  Widget signInForm() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: GlobalVariables.backgroundColor,
      child: Form(
        key: _signInFormKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: "Email",
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _passwordController,
              hintText: "Password",
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Sign In",
              onPressed: () {
                if (_signInFormKey.currentState!.validate()) {
                  signInUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
