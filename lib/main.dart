import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/controllers/login_controller.dart';
import 'package:latres/views/bindings/film_binding.dart';
import 'package:latres/views/pages/detail_page.dart';
import 'package:latres/views/pages/login_page.dart';
import 'package:latres/views/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  // Cek sesi login
  final loginController = LoginController();
  final bool isLoggedIn = await loginController.isLoggedIn();

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NontonSkuy!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        primaryColor: const Color(0xFFE50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      initialRoute: isLoggedIn ? '/main' : '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
        GetPage(
          name: '/main',
          page: () => const MainPage(),
          binding: FilmBinding(),
        ),
        GetPage(
          name: '/detail',
          page: () => const DetailPage(),
        ),
      ],
    );
  }
}
