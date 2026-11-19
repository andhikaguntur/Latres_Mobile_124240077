import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';

// =============================================================================
// [KETENTUAN d. FAVORITE PAGE]
// Menampilkan daftar film/show yang disukai dan disimpan secara lokal via Hive.
// Mendukung penghapusan item dan navigasi ke halaman detail.
// =============================================================================

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FilmController controller = Get.find<FilmController>();

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      // Obx akan merender ulang jika list favoriteFilms berubah
      body: Obx(() {
        // ---------------------------------------------------------------------
        // [KETENTUAN d.i] Menampilkan Pesan jika Belum Ada Film Favorit
        // ---------------------------------------------------------------------
        if (controller.favoriteFilms.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada film favorit.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // ---------------------------------------------------------------------
        // [KETENTUAN d.i & d.ii] Menampilkan Daftar Film yang Disimpan di Hive
        // ---------------------------------------------------------------------
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favoriteFilms.length,
          itemBuilder: (context, index) {
            final film = controller.favoriteFilms[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                // Gambar poster mini / thumbnail
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: film.imageUrl != null
                      ? Image.network(
                          film.imageUrl!,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 50,
                            height: 70,
                            color: Colors.grey.shade900,
                            child: const Icon(Icons.movie, color: Colors.grey),
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 70,
                          color: Colors.grey.shade900,
                          child: const Icon(Icons.movie, color: Colors.grey),
                        ),
                ),
                // Judul film
                title: Text(
                  film.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // Rating film
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      film.rating != null ? film.rating.toString() : '-',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                // -------------------------------------------------------------
                // [KETENTUAN d.iii] Tombol Hapus Film dari Favorit
                // Menghapus data dari Hive melalui FilmController
                // -------------------------------------------------------------
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFE50914)),
                  onPressed: () {
                    controller.removeFavorite(film.id);
                  },
                ),
                // -------------------------------------------------------------
                // [KETENTUAN d.iv] Navigasi ke Detail Page saat Item Diklik
                // -------------------------------------------------------------
                onTap: () {
                  Get.toNamed('/detail', arguments: film);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
