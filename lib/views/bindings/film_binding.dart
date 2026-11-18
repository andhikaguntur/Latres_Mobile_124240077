import 'package:get/get.dart';
import 'package:latres/controllers/film_controller.dart';

class FilmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilmController>(() => FilmController());
  }
}
