import 'package:testfluter/models/login.model.dart';
import 'package:testfluter/models/user.model.dart';

abstract class AuthInterface {
  Future<UserModel> login(LoginModel model);
  Future<bool> logout();
  Future<bool> checkIsLoggedIn();
}