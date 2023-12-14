import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/controllers/home.controller.dart';
import 'package:testfluter/views/add_device/components/add_device.dart';
import 'package:testfluter/views/control/controle.dart';
import 'package:testfluter/views/control/lamp_module/lamp_viewmodel.dart';
import 'package:testfluter/views/home/Device.dart';
import 'package:testfluter/views/home/components/logout_widget.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, this.device, this.deviceConnected})
      : super(key: key);

  final String? device;
  final bool? deviceConnected;

  @override
  State<HomeView> createState() => _HomeViewState();
}

enum SampleItem { itemOne, itemTwo }

class _HomeViewState extends State<HomeView> {
  static const channel = MethodChannel(Constants.CHANNEL);
  final HomeController homeController = HomeController(channel);
  // final DeviceController deviceController = DeviceController(channel);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  dynamic devResp;
  SampleItem? selectedMenu;
  List devices = [];
  List<Device> listOfDevices = [];
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
    getSharedPreferences();

    _initUserInfo();

    super.initState();
  }

  LampViewModel lampViewModel = LampViewModel();
  bool lampStatus = false;
  String dpsDevice = "";

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                if (listOfDevices.isEmpty)
                  const Column(
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
                  )
                else
                  Expanded(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      // gridDelegate:
                      //     const SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 200,
                      //   mainAxisExtent: 200,
                      //   childAspectRatio: 3 / 2,
                      //   crossAxisSpacing: 20,
                      //   mainAxisSpacing: 20,
                      // ),

                      itemCount: listOfDevices.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ControlScreen(
                                  channel: channel,
                                  deviceId: listOfDevices[0].id,
                                  deviceName: listOfDevices[0].name,
                                  dps: getDps(dpsDevice),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColors.grayBlack,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  listOfDevices[0].iconUrl),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          listOfDevices[0].name,
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      width: 1,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          !lampStatus
                                              ? lampViewModel
                                                  .handleStatusLightOn(
                                                  channel,
                                                  listOfDevices[0].id,
                                                )
                                              : lampViewModel
                                                  .handleStatusLightOff(
                                                  channel,
                                                  listOfDevices[0].id,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    lampViewModel.handleDeleteDevice(
                                      channel,
                                      listOfDevices[0].id,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ],
            )),
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
    return homeIdValue.isNotEmpty;
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

  // getHomeDeviceList() async {
  //   SharedPreferences prefs = await _prefs;
  //   String? homeId = prefs.getString("home_id");
  //   if (homeId != null && homeId.isNotEmpty) {
  //     String? deviceList =
  //     await channel.invokeMethod("get_home_devices", <String, String>{
  //       "home_id": homeId.toString()
  //     });
  //     print("deviceList");
  //     print(deviceList);
  //   }
  // }

  // Future<List<Device>> getUserInfo() async {
  //   SharedPreferences prefs = await _prefs;
  //   String? info = await channel.invokeMethod("get_user_info",
  //       <String, String>{"home_id": prefs.getString("home_id")!});
  //
  //   print("getUserInfo");
  //   print(info);
  //
  //   if (info != null && info.isNotEmpty) {
  //     String infoElements = info.substring(1, info.length - 1);
  //     List<String> elements = infoElements.split(', ');
  //
  //     if (elements.isNotEmpty) {
  //       return [
  //         Device(
  //           id: elements[1],
  //           name: elements[0],
  //           iconUrl: elements[2],
  //         )
  //       ];
  //     } else {
  //       return [];
  //     }
  //   } else {
  //     return [];
  //   }
  // }

  Future<void> _initUserInfo() async {
    String homeId = await homeController.getHomeId();
    List<Device> userInfo = await getUserInfo();
    setState(() {
      listOfDevices = userInfo;
    });

    getDevicePairedData();
  }

  Future<void> getDevicePairedData() async {
    // SharedPreferences prefs = await _prefs;
    // String? pairedDeviceId = prefs.getString("device_id");
    if (listOfDevices.isNotEmpty) {
      String? dps = await channel.invokeMethod("get_device_data",
          <String, String>{"paired_device_id": listOfDevices[0].id});

      print("changeDeviceStatus");
      if (dps != null) {
        setState(() {
          dpsDevice = dps;
        });
        print(dps);
        changeDeviceStatus(dps);
      }
    }
  }

  dynamic _parseValue(String value) {
    if (value == 'true' || value == 'false') {
      return value == 'true';
    } else if (RegExp(r'^\d+$').hasMatch(value)) {
      return int.parse(value);
    } else if (RegExp(r'^\d*\.\d+$').hasMatch(value)) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  Map<String, dynamic> getDps(String dps) {
    List<String> keyValuePairs =
        dps.replaceAll('{', '').replaceAll('}', '').split(',');
    Map<String, dynamic> dataMap = {};
    for (String pair in keyValuePairs) {
      List<String> parts = pair.split('=');
      String key = parts[0].trim();
      String value = parts[1].trim();
      dataMap[key] = _parseValue(value);
    }

    return dataMap;
  }

  changeDeviceStatus(String dps) {
    print("changeDeviceStatus");
    print(dps);
    print(getDps(dps)["20"]);
    bool statusLamp = getDps(dps)["20"];
    setState(() {
      lampStatus = statusLamp;
    });
  }
}
