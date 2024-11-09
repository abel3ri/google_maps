import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Google Maps",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}