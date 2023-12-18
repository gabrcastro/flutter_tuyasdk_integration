import 'package:testfluter/models/config_connection.model.dart';

abstract class PairingInterface {

  Future<String?> setupConnection(ConfigConnectionModel config);
  Future<bool> startPairing();
  Future<bool> stopPairing();
}