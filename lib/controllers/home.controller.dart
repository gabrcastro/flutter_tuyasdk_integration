import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/repositories/home.repository.dart';
import 'package:testfluter/res/erros.strings.dart';
import 'package:testfluter/utils/enums.dart';
import 'package:testfluter/views/home/Device.dart';

class HomeController {

  late HomeRepository repository;
  late MethodChannel channel;

  HomeController(this.channel) {
    repository = HomeRepository(channel);
  }

  Future<bool> getHomeAndGroup() async {
    String? homeId = await repository.getHomeAndGroup();

    if (homeId == null) {
      return false;
    }

    await repository.saveHomeId(homeId);

    return true;
  }

  Future<String> getHomeId() async {
      String? homeId = await repository.getHomeId();

      if (homeId == null) {}

      return homeId.toString();
  }
}