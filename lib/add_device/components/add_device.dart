import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:testfluter/add_device/components/device_card.dart';
import 'package:testfluter/add_device/config_network.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/themes.dart';

import '../../DeviceModel.dart';
import '../../utils/enums.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  static const channel = MethodChannel(Constants.CHANNEL);

  var deviceFound = DeviceModel(icon: "", name: "", type: 0);
  bool deviceFounded = false;
  bool pastLongTime = false;
  bool isSearching = false;
  bool blueIsOn = false;

  final List<Map> myProducts =
      List.generate(3, (index) => {"id": index, "name": "Product $index"})
          .toList();

  Timer? _timer;
  Timer? bluetoothCheckTimer;

  @override
  void initState() {
    changeStateSearch();
    searchDevices();
    bluetoothCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkDeviceBluetoothIsOn();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    bluetoothCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Strings.searchingDevices,
                style: TextStyle(color: AppColors.white, fontSize: 14.0),
              ),
              Visibility(
                visible: isSearching,
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !blueIsOn,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.grayBlack,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.blueOff,
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.bluetooth_disabled,
                  color: AppColors.red,
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: pastLongTime,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                Strings.notFoundDeviceScanning,
                style: AppTheme.infoTexts,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Visibility(
          visible: deviceFounded,
          child: DeviceCard(
            image: deviceFound.icon,
            onPressedCallback: () =>
                displayConfigNetworkModalBottomSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> checkDeviceBluetoothIsOn() async {
    bool status = await FlutterBlue.instance.isOn;
    setState(() {
      blueIsOn = status;
    });
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 10), () {
      setState(() {
        pastLongTime = true;
      });
    });
  }

  void changeStateSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  void changeStateDeviceFound() {
    setState(() {
      deviceFounded = !deviceFounded;
    });
  }

  Future<void> searchDevices() async {
    startTimer();
    try {
      List<dynamic> res = await channel
          .invokeMethod(Methods.SEARCH_DEVICES, <String, String>{});

      setState(() {
        deviceFound.name = res[0];
        deviceFound.icon = res[1];
        deviceFound.type = res[2];
      });

      changeStateDeviceFound();
      setState(() {
        pastLongTime = false;
      });
    } catch (e) {
      print("Err $e");
    }
  }

  Future<void> stopSearchDevices() async {
    bool res = await channel
        .invokeMethod(Methods.STOP_SEARCH_DEVICES, <String, String>{});
  }

  displayConfigNetworkModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF111111),
        showDragHandle: true,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConfigNetwork(
              deviceIcon: deviceFound.icon,
              typeDevice: deviceFound.type,
            ),
          );
        });
  }
}
