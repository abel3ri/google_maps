import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps/app/data/providers/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  Rx<LatLng?> userPosition = Rx<LatLng?>(null);
  Rx<bool> isLoading = false.obs;
  late GeolocatorPlatform geolocator;

  @override
  void onInit() {
    super.onInit();
    geolocator = GeolocatorPlatform.instance;
    Get.lazyPut(() => LocationProvider());
  }

  Future<void> getUserPosition({Function? onPositionSet}) async {
    final locationProvider = Get.find<LocationProvider>();
    isLoading(true);
    final res = await locationProvider.getCurrentPosition();
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      userPosition(LatLng(r.latitude, r.longitude));
      if (onPositionSet != null) {
        onPositionSet();
      } else {
        Get.toNamed("/map");
      }
    });
  }
}
