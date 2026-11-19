import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/login_controller.dart';

// =============================================================================
// [KETENTUAN a. LOGIN PAGE]
// Halaman login sederhana dengan kredensial dari data.dart (124240077 & 123)
// Menyimpan informasi login menggunakan SharedPreferences.
// =============================================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk membaca input teks dari pengguna
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controller login untuk memvalidasi kredensial & menyimpan sesi
  final LoginController _loginController = LoginController();

  // ---------------------------------------------------------------------------
  // [KETENTUAN a.i & a.ii] Logika Penanganan Tombol Login
  // ---------------------------------------------------------------------------
  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Memanggil fungsi login pada LoginController
    final success = await _loginController.login(username, password);

    if (success) {
      // Jika berhasil login, navigasi ke halaman utama (/main) dan hapus halaman login dari stack
      Get.offAllNamed('/main');
    } else {
      // Jika gagal, tampilkan pesan peringatan menggunakan SnackBar merah
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414), // Background gelap
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Film dengan warna aksen merah
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.movie, size: 42, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Judul Aplikasi
              const Text(
                'NontonSkuy!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 36),

              // [KETENTUAN a.i] Field Input Username
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // [KETENTUAN a.i] Field Input Password
              TextField(
                controller: _passwordController,
                obscureText: true, // Menyembunyikan karakter password
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914), // Merah Netflix
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
