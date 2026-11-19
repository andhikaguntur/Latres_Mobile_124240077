// =============================================================================
// [MODEL DATA FILM]
// Merepresentasikan struktur data TV Show dari API TVMaze (https://api.tvmaze.com)
// Serta mendukung konversi Map untuk disimpan di database lokal Hive.
// =============================================================================

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

  // ---------------------------------------------------------------------------
  // [KETENTUAN b.ii & c.i] Mapping data JSON dari API TVMaze ke objek Film
  // ---------------------------------------------------------------------------
  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      name: json['name'] ?? '',
      // Parsing list genre menjadi List<String>
      genres: List<String>.from(json['genres'] ?? []),
      // Mengambil nilai rating (average), diubah menjadi tipe double jika ada
      rating: json['rating']?['average']?.toDouble(),
      // Mengambil URL gambar berukuran medium atau original
      imageUrl: json['image']?['medium'] ?? json['image']?['original'],
      summary: json['summary'] ?? '',
    );
  }

  // ---------------------------------------------------------------------------
  // [KETENTUAN d.ii] Mengubah objek Film menjadi Map untuk disimpan di Hive
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // [KETENTUAN d.ii] Mengubah Map dari Hive kembali menjadi objek Film
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // [KETENTUAN c.ii.5] Helper untuk membersihkan tag HTML pada Overview
  // API TVMaze menyertakan tag HTML seperti <p>, <b>, &amp;, dll pada summary.
  // Getter ini menghapusnya agar teks rapi saat ditampilkan di Detail Page.
  // ---------------------------------------------------------------------------
  String get cleanSummary {
    if (summary == null || summary!.isEmpty) return 'No description available.';
    return summary!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
