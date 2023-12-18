
import 'package:get_it/get_it.dart';
import 'package:testfluter/models/login.model.dart';
import 'package:testfluter/models/user.model.dart';
import 'package:testfluter/repositories/auth.repository.dart';
import 'package:testfluter/res/erros.strings.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService() : _repository = GetIt.instance<AuthRepository>();

  Future<String> login(LoginModel model) async {
    UserModel user = await _repository.login(model);

    if (user.uid == null) {
      return ErrorStrings.loginError;
    }

    return user.uid.toString();
  }

  Future<String> logout() async {
    bool result = await _repository.logout();

    if (!result) {
      return ErrorStrings.logoutError;
    }

    return "";
  }

  Future<bool> checkIsLoggedIn() async {
    bool result = await _repository.checkIsLoggedIn();
    return result;
  }
}
