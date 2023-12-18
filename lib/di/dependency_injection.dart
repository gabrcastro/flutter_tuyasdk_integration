import 'package:get_it/get_it.dart';
import 'package:testfluter/repositories/auth.repository.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/repositories/device.repository.dart';
import 'package:testfluter/repositories/home.repository.dart';
import 'package:testfluter/repositories/pairing.repository.dart';
import 'package:testfluter/repositories/register.repository.dart';
import 'package:testfluter/services/auth.service.dart';
import 'package:testfluter/view_models/auth.viewmodel.dart';
import 'package:testfluter/view_models/config_connection.viewmodel.dart';
import 'package:testfluter/view_models/device.viewmodel.dart';
import 'package:testfluter/view_models/home.viewmodel.dart';
import 'package:testfluter/view_models/register.viewmodel.dart';

final GetIt locator = GetIt.instance;

void setupLocator(MethodChannel channel) {
  locator.registerLazySingleton(() => AuthRepository(channel));
  locator.registerLazySingleton(() => RegisterRepository(channel));
  locator.registerLazySingleton(() => HomeRepository(channel));
  locator.registerLazySingleton(() => DeviceRepository(channel));
  locator.registerLazySingleton(() => PairingRepository(channel));

  locator.registerLazySingleton(() => AuthViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => RegisterViewModel());
  locator.registerLazySingleton(() => DeviceViewModel());
  locator.registerLazySingleton(() => ConfigConnectionViewModel());
}
