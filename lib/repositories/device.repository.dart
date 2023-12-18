import 'package:flutter/services.dart';
import 'package:testfluter/interfaces/device.interface.dart';
import 'package:testfluter/models/device.model.dart';
import 'package:testfluter/utils/enums.dart';

class DeviceRepository implements DeviceInterface {
  late final MethodChannel _channel;

  DeviceRepository(this._channel);

  @override
  Future<void> getDpsPairedDevice() async {

    //   if (listOfDevices.isNotEmpty) {
    //     String? dps = await _channel.invokeMethod("get_device_data",
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

  @override
  Future<List<String>> getAllPairedDevices(String homeId) async {
      String? devices = await _channel.invokeMethod("get_user_info",
          <String, String>{"home_id": homeId});

      if (devices != null && devices.isNotEmpty) {
        String infoElements = devices.substring(1, devices.length - 1);
        List<String> elements = infoElements.split(', ');
        return elements;
      }

      return List<String>.empty();
  }

  @override
  Future<String?> getDpsDevice(String deviceId) async {

    String? dps = await _channel.invokeMethod("get_device_data",
        <String, String>{"paired_device_id": deviceId});

    return dps;
  }

  @override
  Future<List<dynamic>?> scanDevices() async {
    List<dynamic> res = await _channel
        .invokeMethod(Methods.SEARCH_DEVICES, <String, String>{});

    return res;
  }



}