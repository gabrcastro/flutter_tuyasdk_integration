import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/models/user.model.dart';
import 'package:testfluter/repositories/auth.repository.dart';
import 'package:testfluter/res/erros.strings.dart';
import 'package:testfluter/view_models/login.viewmodel.dart';

class AuthController {

  late AuthRepository repository;
  late MethodChannel channel;

  AuthController(this.channel) {
    repository = AuthRepository(channel);
  }

  Future<String> login(LoginViewModel viewModel) async {
    UserModel user = await repository.login(viewModel);

    if (user.uid == null) {
      return ErrorStrings.loginError;
    }

    return user.uid.toString();
  }

  Future<String> logout() async {
    bool result = await repository.logout();

    if (!result) {
      return ErrorStrings.logoutError;
    }

    return "";
  }

  Future<bool> checkIsLoggedIn() async {
    bool result = await repository.checkIsLoggedIn();
    return result;
  }

}