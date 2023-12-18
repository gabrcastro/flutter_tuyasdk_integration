import 'package:testfluter/models/login.model.dart';
import 'package:testfluter/services/auth.service.dart';

class AuthViewModel {
  late AuthService _authService;

  AuthViewModel() {
    _authService = AuthService();
  }

  Future<String> login(LoginModel model) async {
    return _authService.login(model);
  }

  Future<String> logout() async {
    return _authService.logout();
  }

  Future<bool> checkIsLoggedIn() async {
    return _authService.checkIsLoggedIn();
  }
}
