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

  Future<void> handleColorLight(
      MethodChannel channel, String deviceId, List<int> colors) async {
    var hex = rgbToTuya(colors[0], colors[1], colors[2]);

    await channel.invokeMethod("control_light", <String, String>{
      "dps": "{\"24\": $hex }",
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

  List<double> rgbToHsv(double t, double e, double n) {
    t /= 255;
    e /= 255;
    n /= 255;
    double s = 0.0, a = 0.0, i = 0.0;
    double maxVal =
        [t, e, n].reduce((value, element) => value > element ? value : element);
    double minVal =
        [t, e, n].reduce((value, element) => value < element ? value : element);
    double l = maxVal - minVal;

    if (maxVal == minVal) {
      a = 0.0;
    } else {
      if (maxVal == t) {
        a = (e - n) / l + (e < n ? 6 : 0);
      } else if (maxVal == e) {
        a = (n - t) / l + 2;
      } else if (maxVal == n) {
        a = (t - e) / l + 4;
      }
      a /= 6;
    }

    return [a, s, i];
  }

  String rgbToTuya(int t, int e, int n) {
    List<int> r = [t, e, n];
    List<double> a = rgbToHsv(
        r[0].toDouble() / 255, r[1].toDouble() / 255, r[2].toDouble() / 255);
    String s = '';
    String g = '';

    r.forEach((element) {
      String val = element.toRadixString(16);
      if (val.length == 1) {
        val = '0$val';
      }
      s += val;
    });

    List<int> i = [
      (360 * a[0]).toInt(),
      (255 * a[1]).toInt(),
      (255 * a[2]).toInt()
    ];

    i.forEach((element) {
      String val = element.toRadixString(16);
      if (val.length == 1) {
        val = '0$val';
      }
      g += val;
    });

    if (g.length == 7) {
      g = '0$g';
    }

    if (g.length == 6) {
      g = '00$g';
    }

    return s + g.substring(0, g.length - 2) + 'ff';
  }
}
