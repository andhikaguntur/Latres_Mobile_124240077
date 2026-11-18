import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/models/film.dart';
import 'package:latres/services/film_api_service.dart';

class FilmController extends GetxController {
  final FilmApiService _filmService = FilmApiService();

  // State variables for list
  final RxBool _isLoading = false.obs;
  final RxList<Film> _films = <Film>[].obs;

  // State variables for favorites
  final RxList<Film> _favoriteFilms = <Film>[].obs;

  // State variables for detail
  final RxBool _isDetailLoading = false.obs;
  final Rx<Film?> _detailFilm = Rx<Film?>(null);

  bool get isLoading => _isLoading.value;
  List<Film> get films => _films;
  List<Film> get favoriteFilms => _favoriteFilms;
  bool get isDetailLoading => _isDetailLoading.value;
  Film? get detailFilm => _detailFilm.value;

  Box get _favBox => Hive.box('favorites');

  @override
  void onInit() {
    super.onInit();
    retrieveFilms();
    loadFavorites();
  }

  Future<void> retrieveFilms() async {
    try {
      _isLoading.value = true;
      final data = await _filmService.fetchFilms();
      _films.assignAll(data);
    } catch (e) {
      debugPrint('Error fetchFilms: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> retrieveDetail(int id, {Film? initial}) async {
    try {
      if (initial != null) {
        _detailFilm.value = initial;
      } else {
        _detailFilm.value = null;
      }
      _isDetailLoading.value = true;
      final data = await _filmService.fetchFilmDetail(id);
      _detailFilm.value = data;
    } catch (e) {
      debugPrint('Error fetchDetail: $e');
    } finally {
      _isDetailLoading.value = false;
    }
  }

  void loadFavorites() {
    final List<Film> favs = [];
    for (var key in _favBox.keys) {
      final item = _favBox.get(key);
      if (item != null) {
        favs.add(Film.fromMap(Map<dynamic, dynamic>.from(item)));
      }
    }
    _favoriteFilms.assignAll(favs);
  }

  bool isFavorite(int id) {
    return _favoriteFilms.any((film) => film.id == id);
  }

  void toggleFavorite(Film film) {
    if (isFavorite(film.id)) {
      _favBox.delete(film.id);
    } else {
      _favBox.put(film.id, film.toMap());
    }
    loadFavorites();
  }

  void removeFavorite(int id) {
    _favBox.delete(id);
    loadFavorites();
  }
}
