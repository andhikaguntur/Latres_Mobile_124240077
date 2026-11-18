import 'package:get/get.dart';
import 'package:latres/models/product.dart';
import 'package:latres/services/product_api_service.dart';

class FilmController extends GetxController {
  // Dependency
  final _filmService = FilmService();

  // State variables
  final RxBool _isLoading = false.obs;
  final RxList<Films> _films = <Films>[].obs;

  bool get isLoading => _isLoading.value;
  List<Films> get films => _films;

  @override
  void onInit() {
    _retrieveData();
    super.onInit();
  }

  Future<void> _retrieveData() async {
    try {
      _isLoading.value = true;

      final data = await _productService.fetchProducts();
      _products.assignAll(data);

      _isLoading.value = false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
