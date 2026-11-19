import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/models/film.dart';
import 'package:latres/services/film_api_service.dart';

// =============================================================================
// [CONTROLLER FILM & FAVORIT (GetX)]
// Mengelola state reaktif (Rx) untuk daftar film, detail film, dan penyimpanan Hive.
// =============================================================================

class FilmController extends GetxController {
  final FilmApiService _filmService = FilmApiService();

  // Mengakses Hive box yang telah diinisialisasi di main.dart
  final Box _favBox = Hive.box('favorites');

  // ---------------------------------------------------------------------------
  // [VARIABEL REAKTIF GETX]
  // Setiap perubahan nilai pada variabel .obs akan otomatis merender ulang widget Obx
  // ---------------------------------------------------------------------------
  final isLoading = false.obs;          // [KETENTUAN b.iv] State loading indicator
  final films = <Film>[].obs;            // [KETENTUAN b.ii] List film untuk Home Page
  final favoriteFilms = <Film>[].obs;    // [KETENTUAN d.i] List film favorit
  final detailFilm = Rx<Film?>(null);    // [KETENTUAN c.i] Objek detail film yang aktif

  @override
  void onInit() {
    super.onInit();
    // Saat controller pertama kali dibuat, muat film dari API dan daftar favorit dari Hive
    retrieveFilms();
    loadFavorites();
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN b.ii & b.iv] Mengambil Data Daftar Film dari API TVMaze
  // Mengaktifkan isLoading selama proses fetch berlangsung
  // ---------------------------------------------------------------------------
  Future<void> retrieveFilms() async {
    try {
      isLoading.value = true;
      final data = await _filmService.fetchFilms();
      films.assignAll(data); // Memperbarui data list film secara reaktif
    } catch (e) {
      // Error handling (misal koneksi internet terputus)
    } finally {
      isLoading.value = false; // Mematikan loading indicator
    }
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN c.i] Mengambil Data Detail Show Berdasarkan ID
  // Endpoint: https://api.tvmaze.com/shows/{id}
  // ---------------------------------------------------------------------------
  Future<void> retrieveDetail(int id, {Film? initial}) async {
    // Jika data awal sudah ada (dari klik item grid), tampilkan langsung agar tidak kosong
    if (initial != null) {
      detailFilm.value = initial;
    }
    try {
      final data = await _filmService.fetchFilmDetail(id);
      detailFilm.value = data; // Memperbarui dengan data detail lengkap dari API
    } catch (e) {
      // Error handling
    }
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN d.ii] Memuat Daftar TV Show Favorit dari Database Lokal Hive
  // Mengambil semua value di dalam Hive box 'favorites' lalu di-assign ke favoriteFilms
  // ---------------------------------------------------------------------------
  void loadFavorites() {
    final List<Film> items = [];
    for (var value in _favBox.values) {
      items.add(Film.fromMap(Map.from(value)));
    }
    favoriteFilms.assignAll(items);
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN c.iii] Cek Apakah Film Berada di Daftar Favorit
  // Menggunakan RxList favoriteFilms sehingga dapat dideteksi secara reaktif oleh Obx
  // ---------------------------------------------------------------------------
  bool isFavorite(int id) {
    return favoriteFilms.any((film) => film.id == id);
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN c.iii] Menambah / Menghapus Film dari Favorit (Toggle)
  // Menyimpan/menghapus data ke Hive dan otomatis memperbarui list reaktif
  // ---------------------------------------------------------------------------
  void toggleFavorite(Film film) {
    if (isFavorite(film.id)) {
      _favBox.delete(film.id); // Hapus dari Hive
    } else {
      _favBox.put(film.id, film.toMap()); // Simpan ke Hive sebagai Map
    }
    loadFavorites(); // Muat ulang list favorit agar UI terupdate
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN d.iii] Menghapus Film dari Daftar Favorit
  // Dipanggil saat tombol tempat sampah merah pada FavoritePage ditekan
  // ---------------------------------------------------------------------------
  void removeFavorite(int id) {
    _favBox.delete(id);
    loadFavorites();
  }
}
