import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:testfluter/views/control/card_control.dart';
import 'package:testfluter/views/control/custom_slider_thumb_rect.dart';
import 'package:testfluter/views/control/lamp_module/lamp_viewmodel.dart';
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
  late int whiteSliderValue;

  LampViewModel lampViewModel = LampViewModel();

  int modeValue = 1;

  @override
  void initState() {
    lampStatus = widget.dps["20"];
    brightless = widget.dps["22"];
    whiteSliderValue = widget.dps["23"];

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
                  title: "White",
                  children: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orangeAccent,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        overlayShape: SliderComponentShape.noThumb,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 20, elevation: 30),
                      ),
                      child: Slider(
                        min: 1,
                        max: 1000,
                        thumbColor: Colors.white,
                        inactiveColor: Colors.transparent,
                        activeColor: Colors.transparent,
                        value: whiteSliderValue.toDouble(),
                        onChanged: (double newValue) async {
                          setState(() {
                            whiteSliderValue = newValue.toInt();
                          });
                          await lampViewModel.handleColorWhiteLight(
                              widget.channel,
                              widget.deviceId,
                              newValue.toInt()
                          );

                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CardControl(
                  title: "Color",
                  children: Column(
                    children: [
                      BlockPicker(
                        pickerColor: colorColors,
                        onColorChanged: (value) => changeColor(value),
                      ),
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

  void changeColor(Color color) {
    lampViewModel.handleColorColourLight(
      widget.channel,
      widget.deviceId,
      "${color.red},${color.green},${color.blue}",
    );
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
