
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:testfluter/models/config_connection.model.dart';
import 'package:testfluter/repositories/pairing.repository.dart';

class ConfigConnectionViewModel {

  late PairingRepository _repository;

  ConfigConnectionViewModel() {
    _repository = GetIt.instance<PairingRepository>();
  }

  Future<String> setupConnection(ConfigConnectionModel config) async {
    String? devId = await _repository.setupConnection(config);

    if (devId == null) {
      throw Error();
    } else {
      return devId;
    }
  }

  Future<bool> stopPairing() async {
    bool res = await _repository.stopPairing();
    return res;
  }
}