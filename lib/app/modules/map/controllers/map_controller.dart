import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps/app/data/providers/location_provider.dart';
import 'package:google_maps/core/controllers/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  Rx<List<LatLng>?> routePoints = Rx<List<LatLng>?>(null);
  Rx<double> distance = Rx<double>(0);
  late StreamSubscription<Position> locationUpdateStream;
  late LatLng businessCoords;
  late GeolocatorPlatform geolocator;
  Rx<LatLng?> userPosition = Rx<LatLng?>(null);
  Rx<bool> isLoading = true.obs;

  List<Map<String, dynamic>> allBusinesses = [
    {
      "logo": "https://logo.clearbit.com/linkedin.com",
      "latLng": LatLng(9.01746552327207, 38.811211375595235),
      "name": "LinkedIn",
    },
    {
      "logo": "https://logo.clearbit.com/facebook.com",
      "latLng": LatLng(9.016166998853304, 38.81183978110997),
      "name": "Facebook",
    },
    {
      "logo": "https://logo.clearbit.com/youtube.com",
      "latLng": LatLng(9.01574223225841, 38.80992096117679),
      "name": "YouTube",
    },
    {
      "logo": "https://logo.clearbit.com/telegram.me",
      "latLng": LatLng(9.005710026106850, 38.78904225395155),
      "name": "Telegram",
    },
  ];

  RxSet<Marker> nearbyMarkers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final locationController = Get.find<LocationController>();
    final locationProvider = Get.find<LocationProvider>();
    geolocator = locationController.geolocator;
    userPosition.value = locationController.userPosition.value;
    businessCoords = LatLng(9.005711026106844, 38.78901225395155);

    locationUpdateStream = geolocator
        .getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 3,
        accuracy: LocationAccuracy.best,
      ),
    )
        .listen((position) async {
      try {
        userPosition.value = LatLng(position.latitude, position.longitude);

        final res = await locationProvider.getRoutePoints(
          coordOne: userPosition.value!,
          coordTwo: businessCoords,
        );
        res.fold((l) {
          l.showError();
        }, (r) {
          routePoints.value = r['routePoints'];
          distance.value = r['distance'] / 1000;
        });

        filterNearbyBusinesses();
      } catch (e) {
      } finally {
        isLoading.value = false;
      }
    });
  }

  void filterNearbyBusinesses() async {
    nearbyMarkers.clear();
    for (var business in allBusinesses) {
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.value!.latitude,
        userPosition.value!.longitude,
        business['latLng'].latitude,
        business['latLng'].longitude,
      );
      log("distance in meters is $distanceInMeters");

      if (distanceInMeters <= 1000) {
        log("Business at $business is within 100 meters");
        nearbyMarkers.add(
          Marker(
            markerId: MarkerId(business.toString()),
            position: business['latLng'],
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: business['name'],
            ),
            // icon: ,
          ),
        );
      }
    }
    log("Total nearby markers: ${nearbyMarkers.length}");
  }

  @override
  void onClose() {
    super.onClose();
    locationUpdateStream.cancel().then(
      (_) {
        log("location updates stopped");
      },
    );
  }
}
