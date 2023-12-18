import 'package:flutter/services.dart';
import 'package:testfluter/interfaces/auth.interface.dart';
import 'package:testfluter/models/user.model.dart';
import 'package:testfluter/utils/enums.dart';
import 'package:testfluter/models/login.model.dart';

class AuthRepository implements AuthInterface {
  final MethodChannel _channel;

  AuthRepository(
    this._channel,
  );

  @override
  Future<UserModel> login(LoginModel model) async {
    String uid =
        await _channel.invokeMethod(Methods.LOGIN, <String, String>{
      "country_code": model.countryCode,
      "email": model.email,
      "password": model.password,
    });

    UserModel user = UserModel(uid: uid);

    return user;
  }

  @override
  Future<bool> logout() async {
    bool result = await _channel.invokeMethod(
      Methods.LOGOUT,
      <String, String>{},
    );

    return result;
  }

  @override
  Future<bool> checkIsLoggedIn() async {
    bool result = await _channel.invokeMethod(Methods.ALREADY_LOGGED, <String, String>{});

    return result;
  }
}
