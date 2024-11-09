import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps/core/controllers/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  final LocationController locationController = Get.find<LocationController>();
  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> googleMapController =
        Completer<GoogleMapController>();
    return Scaffold(
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                padding: EdgeInsets.only(top: 32),
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: locationController.userPosition.value!,
                  zoom: 11,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId("direction to the business"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                    position: controller.businessCoords,
                  ),
                  ...controller.nearbyMarkers,
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId("direction to business location"),
                    points: controller.routePoints.value!,
                    color: Colors.deepOrange,
                    consumeTapEvents: true,
                    onTap: () {},
                    geodesic: true,
                    visible: true,
                    width: 6,
                    startCap: Cap.roundCap,
                  ),
                },
                onMapCreated: (GoogleMapController mapController) {
                  googleMapController.complete(mapController);
                },
              ),
      ),
    );
  }
}
