import 'package:flutter/material.dart';
import 'package:testfluter/views/add_device/pairing_device_screen.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/res/themes.dart';

class ConfigNetwork extends StatefulWidget {
  const ConfigNetwork({
    super.key,
    required this.typeDevice,
    required this.deviceIcon
  });

  final int typeDevice;
  final String deviceIcon;

  @override
  State<ConfigNetwork> createState() => _ConfigNetworkState();
}

class _ConfigNetworkState extends State<ConfigNetwork> {

  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwController = TextEditingController();

  int deviceType = 0;

  @override
  void initState() {
    deviceType = widget.typeDevice;
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

    ssidController.text = "GABRIEL";
    passwController.text = "n4JkVhAcUV";

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Strings.configureNetwork,
                    style: AppTheme.title,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  Strings.pairingInfo,
                  style: AppTheme.infoTexts,
                  textAlign: TextAlign.center,
                ),
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
                style: AppTheme.textFieldStyle,
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
                style: AppTheme.textFieldStyle,
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
          productImage: widget.deviceIcon,
          productName: "",
          typeDevice: deviceType,
        ),
      ),
      ModalRoute.withName('/add'),
    );
  }
}
