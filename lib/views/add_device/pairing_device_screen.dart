import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:testfluter/di/dependency_injection.dart';
import 'package:testfluter/view_models/home.viewmodel.dart';
import 'package:testfluter/models/config_connection.model.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/view_models/config_connection.viewmodel.dart';
import 'package:testfluter/views/home/home.view.dart';

class PairingDeviceScreen extends StatefulWidget {
  final String productId;
  final String productImage;
  final String productName;
  final String ssid;
  final String passwd;
  final int typeDevice;

  const PairingDeviceScreen({super.key,
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

  final ConfigConnectionViewModel configConnection = locator<ConfigConnectionViewModel>();
  final HomeViewModel homeViewModel = locator<HomeViewModel>();

  bool isSearching = true;
  bool deviceConnected = false;

  @override
  void initState() {
    configNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () async {
              await configConnection.stopPairing();
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
    String homeId = await homeViewModel.getHomeId();

    await configConnection.setupConnection(
        ConfigConnectionModel("ssid", "passwd", homeId)
    );

    navigateToHome();
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(deviceConnected: true),
      ),
      ModalRoute.withName('/home'),
    );
  }
}
