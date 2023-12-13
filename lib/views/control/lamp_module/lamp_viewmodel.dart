import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LampViewModel {
  Future<void> handleStatusLightOn(
      MethodChannel channel, String deviceId) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"20\": true}",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleStatusLightOff(
      MethodChannel channel, String deviceId) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"20\": false}",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleColorWhiteLight(
      MethodChannel channel, String deviceId, int value) async {

    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"23\": $value }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleColorColourLight(
      MethodChannel channel, String deviceId, String color) async {
    
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"24\": \"${rgbToHsv(color)}\" }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleModeLight(
      MethodChannel channel, String deviceId, String mode) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"21\": \"$mode\" }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleBritghtnessLight(
      MethodChannel channel, String deviceId, int value) async {
    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"22\": $value }",
      "paired_device_id": deviceId
    });
  }

  Future<void> handleDeleteDevice(
      MethodChannel channel, String deviceId) async {
    bool result = await channel.invokeMethod("delete_device", <String, String>{
      "paired_device_id": deviceId
    });

    if (result) {
      print("device removed");
    } else {
      print("error - device removed");
    }
  }

  String rgbToHsv(String rgbColor) {
    List<String> rgbValues = rgbColor.split(',');

    int r = int.parse(rgbValues[0]);
    int g = int.parse(rgbValues[1]);
    int b = int.parse(rgbValues[2]);

    double min = [r, g, b].reduce((a, b) => a < b ? a : b).toDouble();
    double max = [r, g, b].reduce((a, b) => a > b ? a : b).toDouble();
    double delta = max - min;

    double h = 0;
    double s = (max == 0) ? 0 : (delta / max) * 1000;
    double v = (max / 255) * 1000;

    if (delta != 0) {
      if (max == r) {
        h = 60 * (((g - b) / delta) % 6);
      } else if (max == g) {
        h = 60 * (((b - r) / delta) + 2);
      } else if (max == b) {
        h = 60 * (((r - g) / delta) + 4);
      }
    }

    h = (h < 0) ? h + 360 : h;

    // Formatar os valores HSV conforme o exemplo dado
    String formattedH = h.round().toRadixString(16).padLeft(4, '0');
    String formattedS = s.round().toRadixString(16).padLeft(4, '0');
    String formattedV = v.round().toRadixString(16).padLeft(4, '0');

    return '$formattedH$formattedS$formattedV';
  }
}
