library provider_app.globals;

import 'package:location/location.dart' as loc;
import 'package:geocoder/geocoder.dart' as geo;
Future<Map> initPlatformState() async {
  String error;
  loc.PermissionStatus _permission;
  loc.Location _locationService = new loc.Location();
  await _locationService.changeSettings(
      accuracy: loc.LocationAccuracy.high, interval: 1000);

  loc.LocationData location;
  try {
    bool serviceStatus = await _locationService.serviceEnabled();
    print("Service status: $serviceStatus");
    if (serviceStatus) {
      _permission = await _locationService.requestPermission();
      print("Permission: $_permission");
      if (_permission == loc.PermissionStatus.granted) {
        location = await _locationService.getLocation();

        final coordinates =
            new geo.Coordinates(location.latitude, location.longitude);

        var addresses =
            await geo.Geocoder.local.findAddressesFromCoordinates(coordinates);

        print("status ${_permission == loc.PermissionStatus.granted}");
        return {
          "lat": location.latitude,
          "lon": location.longitude,
          "address": addresses.first.addressLine
        };
      }
    } else {
      bool serviceStatusResult = await _locationService.requestService();
      print("Service status activated after request: $serviceStatusResult");
      if (serviceStatusResult) {
        return initPlatformState();
      } else {
        return null;
      }
    }
  } catch(e) {
    print(e.message);
  }
}