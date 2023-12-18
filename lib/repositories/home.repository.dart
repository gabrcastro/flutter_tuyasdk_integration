import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/interfaces/home.interface.dart';
import 'package:testfluter/utils/enums.dart';

class HomeRepository implements HomeInterface {
  MethodChannel channel;

  HomeRepository(
    this.channel,
  );

  @override
  Future<String?> getHomeAndGroup() async {
    String? homeId = await channel.invokeMethod(Methods.GET_HOME_AND_GROUP, <String, String>{});
    return homeId;
  }

  @override
  Future<void> saveHomeId(String homeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEYS_PREFS.HOME_ID, homeId);
  }

  @override
  Future<String?> getHomeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEYS_PREFS.HOME_ID);
  }
}
