import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:testfluter/repositories/register.repository.dart';
import 'package:testfluter/models/register.model.dart';
import 'package:testfluter/models/sendcode.model.dart';

class RegisterViewModel {
  
  late RegisterRepository repository;

  RegisterViewModel() {
    repository = GetIt.instance<RegisterRepository>();
  }
  
  Future<void> sendCode(SendCodeModel viewModel) async {
    await repository.sendRegisterCode(viewModel);
  }

  Future<String> register(RegisterModel viewModel) async {
    String? uuid = await repository.register(viewModel);

    if (uuid == null) {
      throw Error();
    } else {
      return uuid;
    }
  }

  Future<void> saveUUID(String uuid) async {
    await repository.saveUUID(uuid);
  }

}