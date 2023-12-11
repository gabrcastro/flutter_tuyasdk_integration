import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        lampViewModel.handleColorLight(
                            widget.channel, widget.deviceId, [255, 255, 255]);
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
                          const Text(
                            "White",
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: 12.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
