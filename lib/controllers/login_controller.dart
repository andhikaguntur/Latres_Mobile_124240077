import 'package:shared_preferences/shared_preferences.dart';
import '../models/data.dart';

// =============================================================================
// [CONTROLLER LOGIN]
// Mengelola proses autentikasi akun dan penyimpanan sesi dengan SharedPreferences.
// =============================================================================

class LoginController {
  // ---------------------------------------------------------------------------
  // [KETENTUAN a.i & a.ii] Proses Login & Simpan Sesi
  // 1. Memeriksa kecocokan username dan password dengan data di data.dart.
  // 2. Jika valid, menyimpan flag 'is_logged_in' dan 'username' ke SharedPreferences.
  // ---------------------------------------------------------------------------
  Future<bool> login(String username, String password) async {
    if (username.trim() == account.username && password.trim() == account.password) {
      final prefs = await SharedPreferences.getInstance();
      // Menyimpan status login dan username
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('username', username.trim());
      return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN a.ii] Mengecek Apakah Pengguna Masih Memiliki Sesi Login Aktif
  // Digunakan di main.dart saat aplikasi pertama kali dibuka.
  // ---------------------------------------------------------------------------
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN e.i] Mengambil Data Username dari SharedPreferences
  // Digunakan untuk menampilkan username pengguna pada ProfilePage.
  // ---------------------------------------------------------------------------
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? account.username;
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN a.iii & e.iii] Logout & Menghapus Sesi Login
  // Menghapus seluruh data sesi login dari SharedPreferences.
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
