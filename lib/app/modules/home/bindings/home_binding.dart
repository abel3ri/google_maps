import 'package:get/get.dart';
import 'package:google_maps/core/controllers/location_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<LocationController>(
      () => LocationController(),
    );
  }
}
