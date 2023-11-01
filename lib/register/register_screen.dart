import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/utils/enums.dart';

import '../res/colors.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const channel = MethodChannel(Constants.CHANNEL);

  final TextEditingController _codeController = TextEditingController();

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: codeSent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: const Color(0xFFDEDEDE),
                          filled: true,
                          hintText: 'Code',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if ( !codeSent ) {
                          _validateTuya();
                        } else {
                          _registerTuya();
                        }

                        setState(() {
                          codeSent = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: codeSent == false ? const MaterialStatePropertyAll<Color>(
                            Colors.transparent) : const MaterialStatePropertyAll<Color>(AppColors.blueLight),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              width: 2,
                              color: AppColors.blueLight,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        codeSent == false ? 'Vincular minha conta a Tuya'.toUpperCase() : 'Validar'.toUpperCase(),
                        style: TextStyle(
                          color: codeSent == false ? AppColors.blueLight : const Color(0xFF000000),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateTuya() async {
    await channel.invokeMethod(
      Methods.SEND_CODE, <String, String>{
      "country_code": "55",
      "email": "gabriel.castro@houseasy.net"
    });
  }

  Future<void> _registerTuya() async {
    await channel.invokeMethod(Methods.REGISTER, <String, String>{
      "country_code": "55",
      "email": "gabriel.castro@houseasy.net",
      "password": "12345678",
      "code": _codeController.text
    });
  }
}
