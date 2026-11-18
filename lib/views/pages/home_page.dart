import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FilmController controller = Get.find<FilmController>();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          'Skuy Nonton!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        if (controller.films.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada film yang ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFE50914),
          onRefresh: () => controller.retrieveFilms(),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.films.length,
            itemBuilder: (context, index) {
              final film = controller.films[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed('/detail', arguments: film);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster Film
                      Expanded(
                        child: film.imageUrl != null
                            ? Image.network(
                                film.imageUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade900,
                                  child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade900,
                                child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                              ),
                      ),

                      // Judul & Rating
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  film.rating != null ? film.rating.toString() : '-',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
