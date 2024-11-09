// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:google_maps/core/controllers/location_controller.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../controllers/search_location_controller.dart';

// class SearchLocationView extends GetView<SearchLocationController> {
//   SearchLocationView({super.key});
//   final locationController = Get.find<LocationController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Obx(
//             () => GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: locationController.userPosition.value!,
//                 zoom: 11,
//               ),
//               markers: {
//                 if (controller.searchLocation.value != null)
//                   Marker(
//                     markerId: MarkerId("search location"),
//                     position: controller.searchLocation.value!,
//                     infoWindow: InfoWindow(title: "Search Location"),
//                   ),
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               vertical: MediaQuery.of(context).padding.top,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: context.theme.scaffoldBackgroundColor.withOpacity(.8),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     offset: const Offset(4, 4),
//                     blurRadius: 10,
//                     spreadRadius: 4,
//                   ),
//                 ],
//               ),
//               width: Get.width * 0.9,
//               height: Get.height * 0.06,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 24,
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: controller.searchController,
//                       decoration: InputDecoration.collapsed(
//                         hintText: "Search...",
//                       ),
//                       onSubmitted: (value) async {
//                         await controller.onSearchSubmit(value);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps/core/controllers/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/search_location_controller.dart';

class SearchLocationView extends GetView<SearchLocationController> {
  SearchLocationView({super.key});
  final locationController = Get.find<LocationController>();
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Obx(
            () => GoogleMap(
              onMapCreated: (controller) => _mapController.complete(controller),
              initialCameraPosition: CameraPosition(
                target: locationController.userPosition.value!,
                zoom: 11,
              ),
              markers: {
                if (controller.searchLocation.value != null)
                  Marker(
                    markerId: MarkerId("search location"),
                    position: controller.searchLocation.value!,
                    infoWindow: InfoWindow(title: "Search Location"),
                  ),
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.top,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor.withOpacity(.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 4,
                  ),
                ],
              ),
              width: Get.width * 0.9,
              height: Get.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Search...",
                      ),
                      onSubmitted: (value) async {
                        await controller.onSearchSubmit(value);
                        final newLocation = controller.searchLocation.value;
                        if (newLocation != null) {
                          final mapController = await _mapController.future;
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(newLocation),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
