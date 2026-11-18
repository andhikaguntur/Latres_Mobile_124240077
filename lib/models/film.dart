class Film {
  final int id;
  final String name;
  final List<String> genres;
  final double? rating;
  final String? imageUrl;
  final String? summary;

  Film({
    required this.id,
    required this.name,
    required this.genres,
    this.rating,
    this.imageUrl,
    this.summary,
  });

  // Konversi dari JSON API TVMaze ke objek Film
  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      name: json['name'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      rating: json['rating']?['average']?.toDouble(),
      imageUrl: json['image']?['medium'] ?? json['image']?['original'],
      summary: json['summary'] ?? '',
    );
  }

  // Konversi ke Map untuk disimpan di Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'genres': genres,
      'rating': rating,
      'imageUrl': imageUrl,
      'summary': summary,
    };
  }

  // Konversi dari Map di Hive ke objek Film
  factory Film.fromMap(Map map) {
    return Film(
      id: map['id'],
      name: map['name'] ?? '',
      genres: List<String>.from(map['genres'] ?? []),
      rating: map['rating']?.toDouble(),
      imageUrl: map['imageUrl'],
      summary: map['summary'] ?? '',
    );
  }

  // Menghapus tag HTML (seperti <p>, <b>) dari summary TVMaze
  String get cleanSummary {
    if (summary == null || summary!.isEmpty) return 'No description available.';
    return summary!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
