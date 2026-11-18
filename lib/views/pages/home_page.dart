import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/controllers/product_controller.dart';

class HomePage extends GetView<ProductController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];

              return Card(
                elevation: 4,
                child: ListTile(
                  leading: Image.network(product.images[0]),
                  title: Text(product.title),
                  subtitle: Text(product.price.toString()),
                  onTap: () {
                    Get.toNamed("/detail", arguments: product);
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
