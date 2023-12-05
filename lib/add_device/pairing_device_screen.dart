import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/home/home_screen.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';

class PairingDeviceScreen extends StatefulWidget {
  final String productId;
  final String productImage;
  final String productName;
  final String ssid;
  final String passwd;
  final int typeDevice;

  const PairingDeviceScreen(
      {super.key,
      required this.productId,
      required this.productImage,
      required this.productName,
      required this.ssid,
      required this.passwd,
      required this.typeDevice});

  @override
  State<PairingDeviceScreen> createState() => _PairingDeviceScreenState();
}

class _PairingDeviceScreenState extends State<PairingDeviceScreen> {
  static const channel = MethodChannel(Constants.CHANNEL);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isSearching = true;
  bool deviceConnected = false;

  @override
  void initState() {
    configNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String emptyImage = "assets/images/empty.png";

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
        title: const Text(
          Strings.pairing,
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              stopPairDevice();
              navigateToHome();
            },
            child: const Text(
              Strings.cancel,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.blueLight,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Visibility(
          visible: isSearching,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                InkWell(
                  onTap: () {
                    navigateToHome();
                  },
                  child: Center(
                    child: Lottie.asset("assets/lotties/loading.json"),
                  ),
                ),
                Center(
                  child: Visibility(
                    visible: deviceConnected,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        image: DecorationImage(
                          image: NetworkImage(widget.productImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  configNetwork() async {
    SharedPreferences prefs = await _prefs;
    var homeID = prefs.getString("home_id");

    if (homeID != null || homeID != "") {
      String deviceID = await channel.invokeMethod(Methods.CONFIG_PAIR, <String, String>{
        "ssid": widget.ssid,
        "networkPasswd": widget.passwd,
        "home_id": homeID.toString()
      });

      print("###");
      print(deviceID);

      prefs.setString("device_id", deviceID);
    }
  }

  pairDevice(String homeId) async {
    SharedPreferences prefs = await _prefs;

      String? deviceID = await channel.invokeMethod(Methods.START_PAIR, <String, String>{
        "home_id": homeId,
      });

      print("res");
      print(deviceID);

      if (deviceID != null) {
        navigateToHome();
      }
  }

  Future<void> stopPairDevice() async {
    if (widget.typeDevice == Constants.TYPE_DEVICE_WIFI_1) {
      dynamic res = await channel.invokeMethod(
          Methods.STOP_PAIR, <String, String>{
        "ssid": widget.ssid,
        "networkPasswd": widget.passwd
      });
    } else {
      await channel.invokeMethod(Methods.STOP_PAIR, <String, String>{});
    }
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(deviceConnected: true),
      ),
      ModalRoute.withName('/home'),
    );
  }

  void _devicePaired(String deviceId) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("device_paired", deviceId);
  }
}
