// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps/app/data/models/app_error_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

// class SearchLocationController extends GetxController {
//   TextEditingController searchController = TextEditingController();
//   Rx<LatLng?> searchLocation = Rx<LatLng?>(null);
//   Rx<bool> isLoading = false.obs;

//   Future<void> onSearchSubmit(String addressName) async {
//     final List<Location> locations = await locationFromAddress(addressName);
//     log(locations.toString());
//     if (locations.isNotEmpty) {
//       final location = locations.first;
//       searchLocation.value = LatLng(location.latitude, location.longitude);
//     } else {
//       AppErrorModel(body: "Can't find location").showError();
//     }
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     searchController.dispose();
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps/app/data/models/app_error_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchLocationController extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rx<LatLng?> searchLocation = Rx<LatLng?>(null);
  Rx<bool> isLoading = false.obs;

  Future<void> onSearchSubmit(String addressName) async {
    isLoading.value = true;
    try {
      final List<Location> locations = await locationFromAddress(addressName);
      log(locations.toString());
      if (locations.isNotEmpty) {
        final location = locations.first;
        searchLocation.value = LatLng(location.latitude, location.longitude);
      } else {
        AppErrorModel(body: "Can't find location").showError();
      }
    } catch (e) {
      AppErrorModel(body: "Error fetching location: $e").showError();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}
