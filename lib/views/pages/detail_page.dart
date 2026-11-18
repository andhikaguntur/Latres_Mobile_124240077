import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/product_controller.dart';
import 'package:latres/models/product.dart';

class DetailPage extends GetView<ProductController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [Image.network(product.images[0])]),
      ),
    );
  }
}
