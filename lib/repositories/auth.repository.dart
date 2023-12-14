import 'package:flutter/services.dart';
import 'package:testfluter/models/user.model.dart';
import 'package:testfluter/utils/enums.dart';
import 'package:testfluter/view_models/login.viewmodel.dart';

class AuthRepository {
  MethodChannel channel;

  AuthRepository(
    this.channel,
  );

  Future<UserModel> login(LoginViewModel viewModel) async {
    String uid =
        await channel.invokeMethod(Methods.LOGIN, <String, String>{
      "country_code": viewModel.countryCode,
      "email": viewModel.email,
      "password": viewModel.password,
    });

    UserModel user = UserModel(uid: uid);

    return user;
  }

  Future<bool> logout() async {
    bool result = await channel.invokeMethod(
      Methods.LOGOUT,
      <String, String>{},
    );

    return result;
  }

  Future<bool> checkIsLoggedIn() async {
    bool result = await channel.invokeMethod(Methods.ALREADY_LOGGED, <String, String>{});

    return result;
  }
}
