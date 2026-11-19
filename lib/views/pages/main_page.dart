import 'package:flutter/material.dart';
import 'package:latres/views/pages/favorite_page.dart';
import 'package:latres/views/pages/home_page.dart';
import 'package:latres/views/pages/profile_page.dart';

// =============================================================================
// [KETENTUAN b.i] MAIN PAGE DENGAN BOTTOM NAVIGATION BAR
// Menyediakan navigasi utama antar 3 halaman: Beranda (Home), Favorit, dan Profil.
// =============================================================================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index halaman yang saat ini aktif dipilih pada BottomNavigationBar
  int _currentIndex = 0;

  // Daftar ketiga halaman utama sesuai urutan tab
  final List<Widget> _pages = const [
    HomePage(), // Tab 0: Daftar Film TVMaze
    FavoritePage(), // Tab 1: Daftar Film Favorit (Hive)
    ProfilePage(), // Tab 2: Informasi Profil & Logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai index yang aktif
      body: _pages[_currentIndex],

      // [KETENTUAN b.i] BottomNavigationBar untuk navigasi antar halaman
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Mengubah index aktif saat salah satu tab ditekan
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(
          0xFFE50914,
        ), // Warna merah untuk tab aktif
        unselectedItemColor: Colors.grey, // Warna abu-abu untuk tab tidak aktif
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
