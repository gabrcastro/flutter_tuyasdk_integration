import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/add_device/pairing_device_screen.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/themes.dart';
import 'package:testfluter/utils/enums.dart';

class ConfigNetworkScreen extends StatefulWidget {
  const ConfigNetworkScreen({super.key});

  @override
  State<ConfigNetworkScreen> createState() => _ConfigNetworkScreenState();
}

class _ConfigNetworkScreenState extends State<ConfigNetworkScreen> {

  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
        title: const Text(
          Strings.configureNetwork,
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.pairingInfo,
                  style: AppTheme.infoTexts,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: ssidController,
                  onChanged: (value) => ssidController.text = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: Strings.ssid,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwController,
                  onChanged: (value) => passwController.text = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: Strings.password,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: AppTheme.defaultButtons,
                onPressed: () {
                  _navigateToPairingDeviceScreen();
                },
                child: const Text(
                  Strings.next,
                  style: AppTheme.buttonsText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToPairingDeviceScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PairingDeviceScreen(
          ssid: ssidController.text,
          passwd: passwController.text,
          productId: "",
          productImage: "",
          productName: "",
        ),
      ),
      ModalRoute.withName('/add'),
    );
  }
}
