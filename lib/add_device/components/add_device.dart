import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/add_device/components/device_card.dart';
import 'package:testfluter/add_device/config_network_screen.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/res/colors.dart';

import '../../DeviceModel.dart';
import '../../utils/enums.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  static const channel = MethodChannel(Constants.CHANNEL);

  var deviceFound = DeviceModel(icon: "", name: "");
  bool deviceFounded = false;
  bool isSearching = false;

  final List<Map> myProducts =
      List.generate(3, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  void initState() {
    _searchDevices();
    changeStateSearch();
    super.initState();
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
                child: Container(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: deviceFounded,
          child: DeviceCard(
            image: deviceFound.icon,
            onPressedCallback: () => _navigateToConfigNetworkScreen(),
          ),
        ),
      ],
    );
  }

  void changeStateSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  _searchDevices() async {
    try {
      List<dynamic> res = await channel
          .invokeMethod(Methods.SEARCH_DEVICES, <String, String>{});
      setState(() {
        deviceFounded = true;
        deviceFound.name = res[0];
        deviceFound.icon = res[1];
      });
    } catch (e) {
      print("Err $e");
    }
  }

  Future<void> _stopSearchDevices() async {
    bool res = await channel
        .invokeMethod(Methods.STOP_SEARCH_DEVICES, <String, String>{});
  }

  void _navigateToConfigNetworkScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigNetworkScreen(),
      ),
      ModalRoute.withName('/add'),
    );
  }
}
