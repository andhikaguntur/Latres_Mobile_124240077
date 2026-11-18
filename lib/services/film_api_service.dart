import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';

class FilmApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  // Mengambil daftar seluruh film
  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Film.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat film');
    }
  }

  // Mengambil detail film berdasarkan ID
  Future<Film> fetchFilmDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Film.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail film');
    }
  }
}
