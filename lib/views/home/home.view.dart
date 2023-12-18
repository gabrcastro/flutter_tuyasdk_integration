import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/di/dependency_injection.dart';
import 'package:testfluter/view_models/device.viewmodel.dart';
import 'package:testfluter/view_models/home.viewmodel.dart';
import 'package:testfluter/utils/convert_string_to_json.dart';
import 'package:testfluter/utils/permissions.utils.dart';
import 'package:testfluter/views/add_device/components/add_device.dart';
import 'package:testfluter/views/control/controle.dart';
import 'package:testfluter/views/control/lamp_module/lamp_viewmodel.dart';
import 'package:testfluter/models/device.model.dart';
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

  final HomeViewModel homeViewModel = locator<HomeViewModel>();
  final DeviceViewModel deviceViewModel = locator<DeviceViewModel>();

  final ConvertValues convertValues = ConvertValues();

  dynamic devResp;
  SampleItem? selectedMenu;
  List devices = [];
  List<DeviceModel> listOfDevices = [];
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
    getPermissions();

    getPairedDevices();

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
                                  dps: convertValues
                                      .convertStringToMap(dpsDevice),
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
    bool locationPermissionGranted = await PermissionUtils.checkAndRequestPermissions();
    setState(() {
      permGranted = locationPermissionGranted;
    });
  }

  Future<void> getPairedDevices() async {
    String homeId = await homeViewModel.getHomeId();
    List<DeviceModel> allPairedDevices =
        await deviceViewModel.getAllPairedDevices(homeId);

    if (allPairedDevices.isNotEmpty) {

      String dps = await deviceViewModel.getDpsDevice(allPairedDevices[0].id);
      bool statusLamp = convertValues.convertStringToMap(dps)["20"];

      setState(() {
        listOfDevices = allPairedDevices;
        dpsDevice = dps;
        lampStatus = statusLamp;
      });
    }
  }
}
