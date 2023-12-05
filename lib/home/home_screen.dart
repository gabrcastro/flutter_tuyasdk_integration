import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/add_device/components/add_device.dart';
import 'package:testfluter/home/components/logout_widget.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.device, this.deviceConnected}) : super(key: key);

  String? device;
  bool? deviceConnected;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum SampleItem { itemOne, itemTwo }

class _HomeScreenState extends State<HomeScreen> {
  static const channel = MethodChannel(Constants.CHANNEL);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  dynamic? devResp;
  SampleItem? selectedMenu;
  List devices = [];
  String? uid;
  String? homeBean;
  List sampleItemValue = [
    {
      "title": Strings.logout,
      "icon": Icons.logout_rounded,
    },
  ];

  bool permGranted = true;

  @override
  void initState() {
    _initializeUID();
    getPermissions();
    // _getHomeList();
    getSharedPreferences();

    _checkSharedPreferencesHomeId().then((bool hasHomeId) {
      if (!hasHomeId) {
        getHomeData();
      } else {
        getHomeDeviceList();
      }
    });

    getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showBottomSheet = false;

    // if (widget.deviceConnected == true) {
    //   _getHomeList();
    // }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: AppColors.grayBlack,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                displayScanDevicesModalBottomSheet(context);
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.blueLight,
              )),
          MenuAnchor(
            style: MenuStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF0E0E0E)),
            ),
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.blueLight,
                ),
                tooltip: 'Show menu',
              );
            },
            menuChildren: List<MenuItemButton>.generate(
              1,
              (int index) => MenuItemButton(
                onPressed: () {
                  switch (index) {
                    case 0:
                      {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              const LogoutDialog(),
                        );

                        break;
                      }
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        sampleItemValue[index]["icon"],
                        size: 20,
                        color: AppColors.blueLight,
                      ),
                    ),
                    Text(
                      sampleItemValue[index]["title"],
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.blueLight),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  Strings.anyDevice,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeUID() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      uid = prefs.getString("user_uid");
    });
  }

  void getDevicePaired() async {
    final SharedPreferences prefs = await _prefs;
    String? deviceId = prefs.getString("device_paired");

    if (deviceId != null) {
      dynamic device = channel.invokeMethod(Methods.GET_DEVICES_PAIRED,
          <String, String>{"get_device_id": deviceId});

      print("devices paired");
      print(device);
    }
  }

  Future<bool> _checkSharedPreferencesHomeId() async {
    final SharedPreferences prefs = await _prefs;
    String homeIdValue = prefs.getString("home_id") ?? "";
    return homeIdValue != null && homeIdValue.isNotEmpty;
  }

  Future<void> createHome() async {
    final SharedPreferences prefs = await _prefs;

    String homeId = await channel.invokeMethod(
        Methods.CREATE_HOME, <String, String>{"home_name": "Home"});

    prefs.setString("home_id", homeId);
  }

  Future<void> _getHomeList() async {
    final SharedPreferences prefs = await _prefs;

    homeBean =
        await channel.invokeMethod(Methods.GET_HOME_DEVICES, <String, String>{
      "home_id": prefs.getString("home_id").toString(),
    });

    print("homeBean");
    print(homeBean);
  }

  displayScanDevicesModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF111111),
        showDragHandle: true,
        builder: (BuildContext bc) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AddDevice(),
          );
        });
  }

  getPermissions() async {
    var locationStatus = await Permission.location.status;

    if (locationStatus.isDenied) {
      setState(() {
        permGranted = false;
      });
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
      ].request();
      if (statuses[Permission.location]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothAdvertise]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted) {
        setState(() {
          permGranted = true;
        });
      } //check each permission status after.
    }
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys();
    var last = prefs.getString(keys.last);
    print("sharedpreferences");
    print(keys);
    print(last);
  }

  getHomeData() async {
    String? homeIdResult =
        await channel.invokeMethod("get_home_data", <String, String>{});
    if (homeIdResult!.isNotEmpty) {
      SharedPreferences prefs = await _prefs;
      prefs.setString("home_id", homeIdResult);
    }
  }

  getHomeDeviceList() async {
    SharedPreferences prefs = await _prefs;
    String? homeId = prefs.getString("home_id");
    if (homeId != null && homeId.isNotEmpty) {
      String? deviceList =
      await channel.invokeMethod("get_home_devices", <String, String>{
        "home_id": homeId.toString()
      });
      print("deviceList");
      print(deviceList);
    }
  }

  getUserInfo() async {
    SharedPreferences prefs = await _prefs;
    String? homeId = prefs.getString("home_id");
    if (homeId != null && homeId.isNotEmpty) {
      await channel.invokeMethod("get_user_info", <String, String>{
        "home_id": homeId.toString()
      });
    }
  }
}
