import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/add_device/components/add_device.dart';
import 'package:testfluter/home/components/logout_widget.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    this.device
  }) : super(key: key);

  String? device;

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
      "title": Strings.newDevice,
      "icon": Icons.add,
    },
    {
      "title": Strings.logout,
      "icon": Icons.logout_rounded,
    },
  ];

  Future<void> _initializeUID() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      uid = prefs.getString("user_uid");
    });
  }

  @override
  void initState() {
    _checkIsHomeCreated();
    _initializeUID();
    homeBean = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showBottomSheet = false;
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        automaticallyImplyLeading: false,
        actions: [
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
              2,
              (int index) => MenuItemButton(
                onPressed: () {
                  switch (index) {
                    case 0:
                      {
                        displayModalBottomSheet(context);
                        break;
                      }
                    case 1:
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

  Future<void> _checkIsHomeCreated() async {
    var homeId = await channel.invokeMethod(Methods.CHECK_HOME_ALREADY_EXIST,
        <String, String>{"home_name": "Home"});

    final SharedPreferences prefs = await _prefs;
    prefs.setString("home_id", homeId.toString());
  }

  Future<void> _turnOnOffBulb() async {
    await channel.invokeMethod(Methods.TURN_ON_OFF_BULB, <String, String>{});
  }

  Future<void> _getHomeList() async {
    final SharedPreferences prefs = await _prefs;

    homeBean =
        await channel.invokeMethod(Methods.GET_HOME_DEVICES, <String, String>{
      "home_id": prefs.getString("home_id").toString(),
    });
  }

  displayModalBottomSheet(context) {
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
}
