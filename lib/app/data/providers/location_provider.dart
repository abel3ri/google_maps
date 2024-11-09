import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps/app/data/models/app_error_model.dart';
import 'package:google_maps/core/controllers/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends GetConnect {
  late GeolocatorPlatform geolocator;
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = "http://router.project-osrm.org/route/v1/driving";
    geolocator = Get.find<LocationController>().geolocator;
  }

  Future<Either<AppErrorModel, Position>> getCurrentPosition() async {
    try {
      final res = await requestPermission();
      return res.fold(
        (l) {
          return left(l);
        },
        (r) async {
          try {
            final userPosition = await geolocator.getCurrentPosition(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.best),
            );
            return right(userPosition);
          } catch (e) {
            return left(AppErrorModel(body: e.toString()));
          }
        },
      );
    } catch (e) {
      return left(AppErrorModel(body: e.toString()));
    }
  }

  Future<Either<AppErrorModel, bool>> requestPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return left(
          const AppErrorModel(
            body: "Location services are disabled. Please enable Location.",
          ),
        );
      }

      permission = await geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return left(const AppErrorModel(body: "Location permission denied."));
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception("App is denied to use location.");
        }
      }
      return right(true);
    } catch (e) {
      return left(AppErrorModel(body: e.toString()));
    }
  }

  Future<Either<AppErrorModel, Map<String, dynamic>>> getRoutePoints({
    required LatLng coordOne,
    required LatLng coordTwo,
  }) async {
    try {
      final res = await get(
        "/${coordOne.longitude},${coordOne.latitude};${coordTwo.longitude},${coordTwo.latitude}?steps=false&annotations=false&geometries=geojson&overview=full",
      );

      if (res.hasError) throw "Unable to get direction";
      final coords = List.from(
        res.body['routes'][0]['geometry']['coordinates'],
      );

      final distance = res.body['routes'][0]['distance'];
      final routePoints = coords.map((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();
      return right({"routePoints": routePoints, "distance": distance});
    } catch (e) {
      return left(AppErrorModel(body: e.toString()));
    }
  }
}
