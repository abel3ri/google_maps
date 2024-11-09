import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps/core/controllers/location_controller.dart';
import 'package:google_maps/core/widgets/r_card.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => locationController.isLoading.isTrue
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RCard(
                        child: TextButton(
                      onPressed: () async {
                        await locationController.getUserPosition(
                            onPositionSet: () {
                          Get.toNamed("/map");
                        });
                      },
                      child: const Text("Business Direction"),
                    )),
                    SizedBox(height: Get.height * 0.02),
                    RCard(
                      child: TextButton(
                        onPressed: () {
                          locationController.getUserPosition(onPositionSet: () {
                            Get.toNamed("/search-location");
                          });
                        },
                        child: Text("Search Location"),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
