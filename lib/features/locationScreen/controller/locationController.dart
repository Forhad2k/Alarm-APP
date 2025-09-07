import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator for cross-platform location
import 'package:geocoding/geocoding.dart'; // Geocoding for reverse geocoding

class LocationController extends GetxController {
  var locationMessage = "".obs;

  // Function to get the current location and convert it to a place name
  Future<void> getLocation() async {
    // Check for location permission
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage.value = "Location services are disabled.";
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        locationMessage.value = "Location permissions are denied.";
        return;
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convert the latitude and longitude into a place name (reverse geocoding)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      // Construct a readable address string
      String address = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
      locationMessage.value = "You are in $address";
    } catch (e) {
      locationMessage.value = "Could not get place name. Error: $e";
    }
  }
}
