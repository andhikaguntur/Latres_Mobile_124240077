import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';

// =============================================================================
// [KETENTUAN b.v] Pemisahan Logika Fetch & Parse Data API dari UI
// Kelas ini bertugas menangani seluruh komunikasi HTTP dengan TVMaze API.
// =============================================================================

class FilmApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  // ---------------------------------------------------------------------------
  // [KETENTUAN b.ii] Mengambil Daftar TV Shows
  // Endpoint: https://api.tvmaze.com/shows
  // Mengembalikan List<Film> yang telah diparse dari JSON
  // ---------------------------------------------------------------------------
  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));

    if (response.statusCode == 200) {
      // Mengubah string JSON body menjadi List dinamis
      final List data = jsonDecode(response.body);
      // Melakukan mapping setiap elemen JSON ke model Film
      return data.map((item) => Film.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat film dari TVMaze API');
    }
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN c.i] Mengambil Data Detail TV Show Berdasarkan ID
  // Endpoint: https://api.tvmaze.com/shows/{id}
  // Mengembalikan objek Film tunggal yang lengkap
  // ---------------------------------------------------------------------------
  Future<Film> fetchFilmDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));

    if (response.statusCode == 200) {
      // Mengubah string JSON body menjadi Map
      final data = jsonDecode(response.body);
      // Mengembalikan objek Film
      return Film.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail film dengan ID $id');
    }
  }
}
