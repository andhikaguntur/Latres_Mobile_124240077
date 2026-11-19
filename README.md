# NontonSkuy! - Aplikasi TV Shows & Series Streaming

Aplikasi mobile berbasis Flutter untuk katalog dan streaming TV shows/series yang mengonsumsi data dari REST API publik **TVMaze** (https://www.tvmaze.com/api). Aplikasi ini dibangun dengan prinsip **Clean Code** dan arsitektur yang mudah dipahami bagi pemula, menggunakan **GetX** untuk manajemen state dan navigasi, **Hive** untuk penyimpanan lokal data favorit, serta **SharedPreferences** untuk pengelolaan sesi login.

---

## Daftar Fitur & Kriteria Tugas

1. **Login Page (`LoginPage`)**
   - Kredensial default sesuai ketentuan:
     - **Username**: `124240077`
     - **Password**: `123`
   - Menyimpan status sesi pengguna secara persisten menggunakan `SharedPreferences`.
   - Menampilkan notifikasi SnackBar merah jika username atau password salah.

2. **Halaman Utama & Navigasi (`MainPage` & `HomePage`)**
   - Menggunakan `BottomNavigationBar` untuk navigasi cepat antar 3 halaman:
     - **Beranda** (Home)
     - **Favorit** (Favorites)
     - **Profil** (Profile)
   - Mengambil data daftar film dari endpoint API TVMaze: `https://api.tvmaze.com/shows`.
   - Menampilkan data dalam bentuk **Grid 2 Kolom** dengan elemen wajib:
     - Gambar poster
     - Judul film
     - Rating bintang
   - Indikator loading (`CircularProgressIndicator`) reaktif saat data sedang dimuat.
   - Mekanisme penarikan data (fetch) dan parsing JSON dipisahkan secara modular pada file service tersendiri.
   - Klik kartu film untuk membuka halaman detail.

3. **Detail Page (`DetailPage`)**
   - Mengambil data spesifik dari endpoint: `https://api.tvmaze.com/shows/{id}`.
   - Menampilkan rincian informasi lengkap:
     - Poster ukuran besar
     - Judul show
     - Rating bintang
     - Daftar genre
     - Overview / Sinopsis (tag HTML seperti `<p>`, `<b>` telah dibersihkan secara otomatis).
   - Tombol **Nonton** untuk simulasi pemutaran film.
   - Tombol **Favorit** dengan status ikon hati yang otomatis berubah warna secara reaktif.
   - Tombol kembali (Back) di AppBar untuk kembali ke halaman sebelumnya.

4. **Favorite Page (`FavoritePage`)**
   - Menampilkan seluruh serial/film yang telah ditandai sebagai favorit.
   - Data disimpan secara persisten di penyimpanan lokal perangkat menggunakan **Hive**.
   - Setiap item memiliki tombol tempat sampah merah untuk menghapus film dari daftar favorit.
   - Setiap item favorit dapat diklik untuk membuka halaman detail film tersebut.

5. **Profile Page (`ProfilePage`)**
   - Menampilkan username aktif yang dibaca langsung dari `SharedPreferences`.
   - Menampilkan catatan kesan dan pesan praktikum:
     - `Kesan: oke`
     - `Pesan: oke`
   - Tombol **Logout** yang fungsional: menghapus sesi di `SharedPreferences` dan mengarahkan kembali ke halaman login.

---

## Struktur Folder Proyek (Clean Architecture)

```text
lib/
├── controllers/
│   ├── film_controller.dart     # Mengelola state daftar film, detail, dan favorit (GetX & Hive)
│   └── login_controller.dart    # Mengelola autentikasi & sesi (SharedPreferences)
├── models/
│   ├── data.dart                # Data akun statis untuk login
│   └── film.dart                # Model data Film & konversi JSON/Map
├── services/
│   └── film_api_service.dart    # Pemanggilan HTTP ke TVMaze REST API
├── views/
│   ├── bindings/
│   │   └── film_binding.dart    # Dependency Injection FilmController
│   └── pages/
│       ├── detail_page.dart     # Halaman rincian detail film
│       ├── favorite_page.dart   # Halaman daftar film favorit
│       ├── home_page.dart       # Halaman beranda (Grid daftar film)
│       ├── login_page.dart      # Halaman autentikasi login
│       ├── main_page.dart       # Wrapper halaman dengan BottomNavigationBar
│       └── profile_page.dart    # Halaman profil pengguna & logout
└── main.dart                    # Entry point aplikasi, inisialisasi Hive & routing GetX
```

---

## Panduan Setup & Menjalankan Aplikasi

### 1. Prasyarat Sistem
- **Flutter SDK**: Versi `>= 3.13.2`
- **Dart SDK**: Versi `>= 3.13.2`
- Emulator Android / iOS atau perangkat fisik yang terhubung via USB Debugging.

### 2. Langkah Menjalankan Aplikasi

1. Buka terminal pada folder proyek:
   ```bash
   cd "path/to/latres"
   ```

2. Unduh seluruh dependensi paket:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi pada perangkat/emulator yang aktif:
   ```bash
   flutter run
   ```

---

## Panduan Kustomisasi & Modifikasi

### A. Mengubah Endpoint API
Jika ingin mengganti URL API TVMaze atau beralih ke REST API lain (misalnya API buatan sendiri atau DummyJSON):

1. **Buka file**: `lib/services/film_api_service.dart`
2. Ubah konstanta base URL dan path endpoint sesuai kebutuhan:
   ```dart
   class FilmApiService {
     // Ganti base URL di sini:
     static const String _baseUrl = 'https://api.tvmaze.com';

     // Ganti path endpoint daftar film:
     Future<List<Film>> fetchFilms() async {
       final response = await http.get(Uri.parse('$_baseUrl/shows'));
       // ...
     }

     // Ganti path endpoint detail film:
     Future<Film> fetchFilmDetail(int id) async {
       final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
       // ...
     }
   }
   ```
3. **Menyesuaikan Struktur Response (Model Data)**:
   Buka file `lib/models/film.dart`, lalu sesuaikan key JSON pada constructor `Film.fromJson`:
   ```dart
   factory Film.fromJson(Map<String, dynamic> json) {
     return Film(
       id: json['id'],
       name: json['name'] ?? '', // Sesuaikan nama key field jika berbeda (misal: json['title'])
       genres: List<String>.from(json['genres'] ?? []),
       rating: json['rating']?['average']?.toDouble(),
       imageUrl: json['image']?['medium'] ?? json['image']?['original'],
       summary: json['summary'] ?? '',
     );
   }
   ```

---

### B. Mengubah Tema Aplikasi (Colors & Styling)

Aplikasi secara default menggunakan tema gelap (**Dark Theme**) dengan aksen merah ala Netflix.

#### 1. Mengubah Warna Tema Global
Buka file `lib/main.dart` pada bagian `GetMaterialApp`:
```dart
theme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF141414), // Background layar (hitam pekat)
  primaryColor: const Color(0xFFE50914),            // Warna utama / aksen (merah)
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE50914),                     // Warna aksen tombol/elemen aktif
    surface: Color(0xFF1E1E1E),                     // Warna kartu/wadah konten
  ),
),
```

#### 2. Mengubah ke Mode Terang (Light Theme)
Jika ingin mengubah tampilan menjadi tema putih/terang, ubah di `lib/main.dart`:
```dart
theme: ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blueAccent,
  colorScheme: const ColorScheme.light(
    primary: Colors.blueAccent,
    surface: Colors.white,
  ),
),
```

#### 3. Mengubah Warna Tombol & Aksen Tertentu
Warna merah Netflix didefinisikan sebagai `const Color(0xFFE50914)`. Anda dapat menggantinya ke warna lain (misalnya `Colors.blueAccent`, `Colors.green`, dsb) di file:
- `lib/views/pages/login_page.dart`: Properti `backgroundColor` pada tombol Login.
- `lib/views/pages/home_page.dart`: Properti `color` pada `CircularProgressIndicator` dan `RefreshIndicator`.
- `lib/views/pages/detail_page.dart`: Tombol **Nonton** dan warna ikon hati favorit saat aktif.
- `lib/views/pages/main_page.dart`: Properti `selectedItemColor` pada `BottomNavigationBar`.
- `lib/views/pages/profile_page.dart`: Tombol **Logout**.

---

## Dependensi yang Digunakan

| Paket | Versi | Kegunaan |
| :--- | :--- | :--- |
| [`get`](https://pub.dev/packages/get) | `^4.7.3` | Manajemen state reaktif (Rx/Obx), navigasi rute, dan dependency injection. |
| [`http`](https://pub.dev/packages/http) | `^1.6.0` | Melakukan HTTP request (GET) ke TVMaze REST API. |
| [`hive`](https://pub.dev/packages/hive) | `^2.2.3` | Database NoSQL lokal yang cepat dan ringan. |
| [`hive_flutter`](https://pub.dev/packages/hive_flutter) | `^1.1.0` | Ekstensi kemudahan integrasi Hive dengan Flutter. |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.5.6` | Menyimpan preferensi sesi login dan username secara persisten. |
