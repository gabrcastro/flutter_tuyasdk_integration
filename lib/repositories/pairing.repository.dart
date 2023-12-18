import 'package:flutter/services.dart';
import 'package:testfluter/interfaces/pairing.interface.dart';
import 'package:testfluter/models/config_connection.model.dart';
import 'package:testfluter/utils/enums.dart';

class PairingRepository implements PairingInterface {
  final MethodChannel _channel;

  PairingRepository(this._channel);

  @override
  Future<String?> setupConnection(ConfigConnectionModel config) async {
    String? devId = await _channel.invokeMethod(Methods.CONFIG_PAIR, <String, String>{
      "ssid": config.ssid,
      "network_passwd": config.passwd,
      "home_id": config.homeId
    });

   return devId;
  }

  @override
  Future<bool> startPairing() {
    // TODO: implement startPairing
    throw UnimplementedError();
  }

  @override
  Future<bool> stopPairing() async {
    bool res = await _channel.invokeMethod(Methods.STOP_PAIR, <String, String>{});

    return res;
  }



}