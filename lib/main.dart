import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/controllers/login_controller.dart';
import 'package:latres/views/bindings/film_binding.dart';
import 'package:latres/views/pages/detail_page.dart';
import 'package:latres/views/pages/login_page.dart';
import 'package:latres/views/pages/main_page.dart';

void main() async {
  // Memastikan semua widget binding Flutter siap sebelum menjalankan fungsi async
  WidgetsFlutterBinding.ensureInitialized();

  // =========================================================================
  // [KETENTUAN d.ii] Inisialisasi Hive untuk Fitur Favorit
  // =========================================================================
  // Menginisialisasi Hive pada direktori aplikasi dan membuka box 'favorites'
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  // =========================================================================
  // [KETENTUAN a.ii] Cek Sesi Login dari SharedPreferences
  // =========================================================================
  // Jika user sebelumnya sudah login, langsung arahkan ke MainPage tanpa perlu login ulang
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

      // Konfigurasi Tema Gelap (Dark Theme) ala aplikasi streaming film
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        primaryColor: const Color(0xFFE50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF1E1E1E),
        ),
      ),

      // Menentukan rute pertama kali dibuka: jika sudah login -> /main, jika belum -> /login
      initialRoute: isLoggedIn ? '/main' : '/login',

      // Daftar rute halaman dalam aplikasi menggunakan GetX
      getPages: [
        // Rute Halaman Login
        GetPage(name: '/login', page: () => const LoginPage()),
        // Rute Halaman Utama (memiliki BottomNavigationBar untuk Home, Favorit, Profil)
        GetPage(
          name: '/main',
          page: () => const MainPage(),
          binding: FilmBinding(), // Menyuntikkan FilmController secara otomatis
        ),
        // Rute Halaman Detail Film
        GetPage(name: '/detail', page: () => const DetailPage()),
      ],
    );
  }
}
