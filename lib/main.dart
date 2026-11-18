import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latres/views/bindings/product_binding.dart';
import 'package:latres/views/pages/detail_page.dart';
import 'package:latres/views/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/home",
      getPages: [
        GetPage(
          name: "/home",
          page: () => HomePage(),
          binding: ProductBinding(),
        ),
        GetPage(name: "/detail", page: () => DetailPage()),
      ],
    );
  }
}
