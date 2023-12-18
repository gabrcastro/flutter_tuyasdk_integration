import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/utils/enums.dart';
import 'package:testfluter/models/register.model.dart';
import 'package:testfluter/models/sendcode.model.dart';

class RegisterRepository {
  MethodChannel channel;

  RegisterRepository(this.channel);

  Future<void> sendRegisterCode(SendCodeModel viewModel) async {
    await channel.invokeMethod(
        Methods.SEND_CODE, <String, String>{
      "country_code": viewModel.countryCode,
      "email": viewModel.email
    });
  }

  Future<String?> register(RegisterModel viewModel) async {
    String? uuid = await channel.invokeMethod(Methods.REGISTER, <String, String>{
      "country_code": viewModel.countryCode,
      "email": viewModel.email,
      "password": viewModel.password,
      "code": viewModel.code
    });

    return uuid;
  }

  Future<void> saveUUID(String uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", uuid);
  }
}