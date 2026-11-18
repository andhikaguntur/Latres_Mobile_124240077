import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';

class FilmApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Film.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load shows from TVMaze');
    }
  }

  Future<Film> fetchFilmDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Film.fromJson(data);
    } else {
      throw Exception('Failed to load show detail');
    }
  }
}
