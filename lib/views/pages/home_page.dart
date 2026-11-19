import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';

// =============================================================================
// [KETENTUAN b. HOME PAGE - DAFTAR SHOWS]
// Menampilkan daftar serial/film dari API TVMaze dalam bentuk Grid 2 Kolom.
// =============================================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil instance FilmController yang sudah disediakan oleh binding
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
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
      ),
      // Obx akan merender ulang tampilan secara otomatis ketika nilai reaktif (Rx) berubah
      body: Obx(() {
        // ---------------------------------------------------------------------
        // [KETENTUAN b.iv] Loading Indicator saat data sedang diambil dari API
        // ---------------------------------------------------------------------
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        // Tampilan jika data film kosong atau gagal termuat
        if (controller.films.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada film yang ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // ---------------------------------------------------------------------
        // [KETENTUAN b.iii] Menampilkan Daftar Film dalam Bentuk Grid (2 Kolom)
        // ---------------------------------------------------------------------
        return RefreshIndicator(
          color: const Color(0xFFE50914),
          onRefresh: () => controller.retrieveFilms(), // Tarik ke bawah untuk refresh
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,         // Menampilkan 2 kolom grid
              childAspectRatio: 0.65,    // Rasio lebar terhadap tinggi kartu
              crossAxisSpacing: 12,      // Jarak horizontal antar kartu
              mainAxisSpacing: 12,       // Jarak vertikal antar kartu
            ),
            itemCount: controller.films.length,
            itemBuilder: (context, index) {
              final film = controller.films[index];

              return GestureDetector(
                // -------------------------------------------------------------
                // [KETENTUAN b.vii] Navigasi ke Detail Page saat Item Diklik
                // Mengirimkan objek film sebagai argument
                // -------------------------------------------------------------
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
                      // -------------------------------------------------------
                      // [KETENTUAN b.iii.1] Menampilkan Gambar Poster Film
                      // -------------------------------------------------------
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

                      // Informasi teks pada bagian bawah kartu
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------------------------------------------------
                            // [KETENTUAN b.iii.2] Menampilkan Judul Film
                            // -------------------------------------------------
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

                            // -------------------------------------------------
                            // [KETENTUAN b.iii.3] Menampilkan Rating Bintang
                            // -------------------------------------------------
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
