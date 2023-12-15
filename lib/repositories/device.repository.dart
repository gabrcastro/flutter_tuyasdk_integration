import 'package:flutter/services.dart';
import 'package:testfluter/models/device.model.dart';

class DeviceRepository {
  MethodChannel channel;

  DeviceRepository(this.channel);

  Future<void> getDpsPairedDevice() async {

    //   if (listOfDevices.isNotEmpty) {
    //     String? dps = await channel.invokeMethod("get_device_data",
    //         <String, String>{"paired_device_id": listOfDevices[0].id});
    //
    //     print("changeDeviceStatus");
    //     if (dps != null) {
    //       setState(() {
    //         dpsDevice = dps;
    //       });
    //       print(dps);
    //       changeDeviceStatus(dps);
    //     }
    //   }
    // }
  }

  Future<List<String>> getAllPairedDevices(String homeId) async {
      String? devices = await channel.invokeMethod("get_user_info",
          <String, String>{"home_id": homeId});

      if (devices != null && devices.isNotEmpty) {
        String infoElements = devices.substring(1, devices.length - 1);
        List<String> elements = infoElements.split(', ');
        return elements;
      }

      return List<String>.empty();
  }

  Future<String?> getDpsDevice(String deviceId) async {

    String? dps = await channel.invokeMethod("get_device_data",
        <String, String>{"paired_device_id": deviceId});

    return dps;
  }

}