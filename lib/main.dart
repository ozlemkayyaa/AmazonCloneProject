import 'package:amazon/features/admin/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/auth/services/auth_service.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:amazon/router.dart';
import 'package:provider/provider.dart';
import 'package:amazon/common/widgets/bottom_bar.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context); // Kullanıcı verilerini al
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        colorScheme:
            const ColorScheme.light(primary: GlobalVariables.secondaryColor),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => (generateRoute(settings)),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return FutureBuilder(
            future: authService
                .getUserData(context), // Kullanıcı verilerini getirme işlemi
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Eğer veri getirme işlemi tamamlandıysa
                return Provider.of<UserProvider>(context).user.token.isNotEmpty
                    ? Provider.of<UserProvider>(context).user.type == 'user'
                        ? const BottomBar() // Kullanıcı oturum açmışsa BottomBar'ı göster
                        : const AdminScreen() // Kullanıcı user değilse admindir admin screen'i aç
                    : const AuthScreen(); // Kullanıcı oturum açmamışsa AuthScreen'i göster
              }
              // Veri getirme işlemi devam ediyorsa yüklenme göstergesi göster
              return const Center(child: CircularProgressIndicator());
            });
      }),
    );
  }
}
