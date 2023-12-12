import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:testfluter/control/card_control.dart';
import 'package:testfluter/control/lamp_module/lamp_viewmodel.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/themes.dart';

class ControlScreen extends StatefulWidget {
  final String deviceId;
  final String deviceName;
  final MethodChannel channel;
  final Map<String, dynamic> dps;

  const ControlScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.channel,
    required this.dps,
  });

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late int brightless;
  late bool lampStatus;

  LampViewModel lampViewModel = LampViewModel();

  int modeValue = 1;

  @override
  void initState() {
    lampStatus = widget.dps["20"];
    brightless = widget.dps["22"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HSVColor color = HSVColor.fromColor(Colors.blue);
    void onChanged(HSVColor value) => color = value;
    Color colorColors = Colors.blue;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          widget.deviceName,
          style: AppTheme.title,
        ),
        centerTitle: true,
        backgroundColor: AppColors.grayBlack,
        iconTheme: const IconThemeData(
          color: AppColors.white, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CardControl(
                  title: "Status",
                  children: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          !lampStatus
                              ? lampViewModel.handleStatusLightOn(
                                  widget.channel,
                                  widget.deviceId,
                                )
                              : lampViewModel.handleStatusLightOff(
                                  widget.channel,
                                  widget.deviceId,
                                );
          
                          setState(() {
                            lampStatus = !lampStatus;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grayBlack,
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: lampStatus
                                  ? AppColors.blueLight
                                  : AppColors.white,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              lampStatus ? "ON" : "OFF",
                              style: const TextStyle(
                                color: AppColors.gray,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          lampViewModel.handleColorWhiteLight(
                              widget.channel, widget.deviceId, 1000);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grayBlack,
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          lampViewModel.handleColorColourLight(
                            widget.channel,
                            widget.deviceId,
                            rgbToHsv(colorToRgb(colorColors).red.toDouble(), colorToRgb(colorColors).green.toDouble(), colorToRgb(colorColors).blue.toDouble()),
                            // "0010100a0100", // 4 -> color | 4 -> light\dark | 4 -> intensity
                            // "00FC005B005E",
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grayBlack,
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CardControl(
                  title: "Brightness",
                  children: Slider(
                    min: 10,
                    max: 1000,
                    value: brightless.toDouble(),
                    onChanged: (value) {
                      print(value.toInt());
                      setState(() {
                        brightless = value.toInt();
                      });
                      lampViewModel.handleBritghtnessLight(
                          widget.channel, widget.deviceId, value.toInt());
                    },
                    activeColor: AppColors.blueLight,
                    inactiveColor: AppColors.gray,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CardControl(
                  title: "Mode",
                  children: SegmentedButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                        (Set<MaterialState> states) =>
                            const TextStyle(color: AppColors.white),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return AppColors.blueLight;
                          }
                          return AppColors.grayBlack;
                        },
                      ),
                    ),
                    segments: const <ButtonSegment>[
                      ButtonSegment(
                        value: 1,
                        label: Text('White'),
                      ),
                      ButtonSegment(
                        value: 2,
                        label: Text('Colour'),
                      ),
                    ],
                    selected: {modeValue},
                    onSelectionChanged: (Set newSelection) {
                      setState(() {
                        modeValue = newSelection.first;
                      });
                      if (newSelection.first == 1) {
                        lampViewModel.handleModeLight(
                            widget.channel, widget.deviceId, "white");
                      } else if (newSelection.first == 2) {
                        lampViewModel.handleModeLight(
                            widget.channel, widget.deviceId, "colour");
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CardControl(
                  title: "HSVPicker",
                  children: Column(
                    children: [
                      ColorPicker(
                        color: colorColors,
                        onChanged: (value) {
                          setState(() {
                            colorColors = value;
                            print("colorPicker");
                            print(value);
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> rgbToHsv(double r, double g, double b) {
    r = r.clamp(0.0, 1.0);
    g = g.clamp(0.0, 1.0);
    b = b.clamp(0.0, 1.0);

    double max = [r, g, b].reduce((value, element) => value > element ? value : element);
    double min = [r, g, b].reduce((value, element) => value < element ? value : element);

    double h, s, v;

    v = max;

    if (max != 0.0) {
      s = (max - min) / max;
    } else {
      s = 0.0;
    }

    if (s == 0.0) {
      h = 0.0;
    } else {
      if (max == r) {
        h = (g - b) / (max - min) % 6.0;
      } else if (max == g) {
        h = 2.0 + (b - r) / (max - min);
      } else {
        h = 4.0 + (r - g) / (max - min);
      }

      h *= 60.0;
    }

    int hue = (h < 0 ? (h + 360.0) : h).round();

    return [
      hue.toRadixString(16).toUpperCase().padLeft(4, '0'),
      (s * 1000).round().toRadixString(16).toUpperCase().padLeft(4, '0'),
      (v * 1000).round().toRadixString(16).toUpperCase().padLeft(4, '0'),
    ];
  }

  ColorRGB colorToRgb(Color color) {
    return ColorRGB(color.red, color.green, color.blue);
  }
}

class ColorRGB {
  int red;
  int green;
  int blue;

  ColorRGB(this.red, this.green, this.blue);

  @override
  String toString() {
    return 'ColorRGB($red, $green, $blue)';
  }
}
