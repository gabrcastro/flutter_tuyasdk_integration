abstract class DeviceInterface {
  Future<void> getDpsPairedDevice();
  Future<List<String>> getAllPairedDevices(String homeId);
  Future<String?> getDpsDevice(String deviceId);
  Future<List<dynamic>?> scanDevices();
}