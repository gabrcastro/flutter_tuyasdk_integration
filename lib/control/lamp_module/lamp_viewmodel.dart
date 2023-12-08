import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LampViewModel {

  Future<void> handleStatusLightOn(MethodChannel channel, String deviceId) async {
      await channel.invokeMethod("control_light", <String, String>{
        "dps": "{\"20\": true}",
        "paired_device_id": deviceId
      });
  }

  Future<void> handleStatusLightOff(MethodChannel channel, String deviceId) async {
      await channel.invokeMethod("control_light", <String, String>{
        "dps": "{\"20\": false}",
        "paired_device_id": deviceId
      });
  }

  Future<void> handleColorLight(MethodChannel channel, String deviceId) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"28\": \"0168 03E8 03E8\" }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleModeLight(MethodChannel channel, String deviceId, String mode) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"21\": \"$mode\" }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleBritghtnessLight(MethodChannel channel, String deviceId, int value) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"22\": $value }",
      "paired_device_id": deviceId
    });
  }

}