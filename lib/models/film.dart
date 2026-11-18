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

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'No Title',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: json['rating'] != null && json['rating']['average'] != null
          ? (json['rating']['average'] as num).toDouble()
          : null,
      imageUrl: json['image'] != null
          ? (json['image']['original'] ?? json['image']['medium']) as String?
          : null,
      summary: json['summary'] as String? ?? '',
    );
  }

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

  factory Film.fromMap(Map<dynamic, dynamic> map) {
    return Film(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      genres: (map['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      imageUrl: map['imageUrl'] as String?,
      summary: map['summary'] as String? ?? '',
    );
  }

  String get cleanSummary {
    if (summary == null || summary!.isEmpty) return 'No description available.';
    return summary!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
