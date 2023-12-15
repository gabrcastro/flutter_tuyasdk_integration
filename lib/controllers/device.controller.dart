import 'package:flutter/services.dart';
import 'package:testfluter/repositories/device.repository.dart';
import 'package:testfluter/models/device.model.dart';

class DeviceController {

  late DeviceRepository repository;
  late MethodChannel channel;

  DeviceController(this.channel) {
    repository = DeviceRepository(channel);
  }

  Future<List<DeviceModel>> getAllPairedDevices(String homeId) async {

    List<String> devices = await repository.getAllPairedDevices(homeId);

    if (devices.isNotEmpty) {
      return [
        DeviceModel(
          id: devices[1],
          name: devices[0],
          iconUrl: devices[2],
        )
      ];
    }

    return List<DeviceModel>.empty();
  }

  Future<String> getDpsDevice(String deviceId) async {
    String? dps = await repository.getDpsDevice(deviceId);

    if (dps != null) {
      return dps;
    }

    return "";
  }

}