import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';

// =============================================================================
// [BINDING GETX]
// Mengatur Dependency Injection agar FilmController dapat diakses di berbagai halaman
// menggunakan Get.find<FilmController>() tanpa perlu membuat instance baru secara manual.
// =============================================================================

class FilmBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut membuat instance FilmController hanya saat pertama kali dibutuhkan
    Get.lazyPut<FilmController>(() => FilmController());
  }
}
