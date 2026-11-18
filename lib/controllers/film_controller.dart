import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/models/film.dart';
import 'package:latres/services/film_api_service.dart';

class FilmController extends GetxController {
  final FilmApiService _filmService = FilmApiService();
  final Box _favBox = Hive.box('favorites');

  // Variabel reaktif
  final isLoading = false.obs;
  final films = <Film>[].obs;
  final favoriteFilms = <Film>[].obs;
  final detailFilm = Rx<Film?>(null);

  @override
  void onInit() {
    super.onInit();
    retrieveFilms();
    loadFavorites();
  }

  // Mengambil daftar film dari API TVMaze
  Future<void> retrieveFilms() async {
    try {
      isLoading.value = true;
      final data = await _filmService.fetchFilms();
      films.assignAll(data);
    } catch (e) {
      // Error handling
    } finally {
      isLoading.value = false;
    }
  }

  // Mengambil detail film dari API TVMaze berdasarkan ID
  Future<void> retrieveDetail(int id, {Film? initial}) async {
    if (initial != null) {
      detailFilm.value = initial;
    }
    try {
      final data = await _filmService.fetchFilmDetail(id);
      detailFilm.value = data;
    } catch (e) {
      // Error handling
    }
  }

  // Memuat data favorit dari Hive
  void loadFavorites() {
    final List<Film> items = [];
    for (var value in _favBox.values) {
      items.add(Film.fromMap(Map.from(value)));
    }
    favoriteFilms.assignAll(items);
  }

  // Cek apakah film sudah ada di favorit
  bool isFavorite(int id) {
    return favoriteFilms.any((film) => film.id == id);
  }

  // Tambah atau hapus favorit
  void toggleFavorite(Film film) {
    if (isFavorite(film.id)) {
      _favBox.delete(film.id);
    } else {
      _favBox.put(film.id, film.toMap());
    }
    loadFavorites();
  }

  // Hapus item dari favorit
  void removeFavorite(int id) {
    _favBox.delete(id);
    loadFavorites();
  }
}
