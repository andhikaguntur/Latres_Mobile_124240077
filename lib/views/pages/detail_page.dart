import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';
import 'package:latres/models/film.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FilmController controller = Get.find<FilmController>();
  late Film film;

  @override
  void initState() {
    super.initState();
    film = Get.arguments as Film;
    // Mengambil detail show dari endpoint https://api.tvmaze.com/shows/{id}
    controller.retrieveDetail(film.id, initial: film);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Ambil data film (dari controller atau data awal)
        final currentFilm = controller.detailFilm.value ?? film;
        final isFav = controller.isFavorite(currentFilm.id);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Poster
              if (currentFilm.imageUrl != null)
                Image.network(
                  currentFilm.imageUrl!,
                  width: double.infinity,
                  height: 380,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 380,
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.movie, size: 60, color: Colors.grey),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Film
                    Text(
                      currentFilm.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          currentFilm.rating != null ? currentFilm.rating.toString() : '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Genre
                    if (currentFilm.genres.isNotEmpty)
                      Text(
                        currentFilm.genres.join(', '),
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      ),
                    const SizedBox(height: 18),

                    // Tombol Nonton & Tombol Favorit
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Memutar film: ${currentFilm.name}')),
                              );
                            },
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text(
                              'Nonton',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE50914),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade800),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? const Color(0xFFE50914) : Colors.white,
                            ),
                            onPressed: () {
                              controller.toggleFavorite(currentFilm);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFav ? 'Dihapus dari favorit' : 'Ditambahkan ke favorit'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview
                    const Text(
                      'Overview',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentFilm.cleanSummary,
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
