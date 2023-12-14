import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/utils/enums.dart';

class HomeRepository {
  MethodChannel channel;

  HomeRepository(
    this.channel,
  );


  Future<String?> getHomeAndGroup() async {
    String? homeId = await channel.invokeMethod(Methods.GET_HOME_AND_GROUP, <String, String>{});
    return homeId;
  }

  Future<void> saveHomeId(String homeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEYS_PREFS.HOME_ID, homeId);
  }

  Future<String?> getHomeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEYS_PREFS.HOME_ID);
  }
}
