import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> checkLocationPermission() async {
    var locationStatus = await Permission.location.status;
    return locationStatus.isGranted;
  }

  static Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
    ].request();

    return statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothAdvertise]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted;
  }

  static Future<bool> checkAndRequestPermissions() async {
    bool locationPermissionGranted = await checkLocationPermission();

    if (!locationPermissionGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();

      locationPermissionGranted = statuses[Permission.location]!.isGranted;
    }

    if (locationPermissionGranted) {
      bool bluetoothPermissionsGranted = await requestBluetoothPermissions();
      return bluetoothPermissionsGranted;
    }

    return false;
  }
}
