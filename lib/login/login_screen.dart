import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/User.dart';
import 'package:testfluter/home/home_screen.dart';
import 'package:testfluter/register/register_screen.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';

import '../res/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const channel = MethodChannel(Constants.CHANNEL);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLoggedIn = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _verifyIsAlreadyExistUser();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return HomeScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            Strings.loginTuyaAccount,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: const Color(0xFFDEDEDE),
                              filled: true,
                              hintText: Strings.email,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: TextFormField(
                            controller: _passwController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: const Color(0xFFDEDEDE),
                              filled: true,
                              hintText: Strings.password,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _loginTuya(),
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      AppColors.blueLight),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: Text(
                              Strings.enter.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const RegisterScreen();
                                }),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      Colors.transparent),
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
                              Strings.linkTuyaAccount.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.blueLight,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  _loginTuya() async {
    dynamic uid =
        await channel.invokeMethod(Methods.AUTHENTICATE, <String, String>{
      "country_code": "55",
      "email": "gabriel.castro@houseasy.net", //_emailController.text,
      "password": "12345678" //_passwController.text
    });
    if (uid == null) {
    } else {
      final SharedPreferences prefs = await _prefs;
      prefs.setString("user_uid", uid);
      _navigateToHomeScreen();
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      ModalRoute.withName('/home'),
    );
  }

  _verifyIsAlreadyExistUser() async {
    var isLoggedIn =
        await channel.invokeMethod(Methods.ALREADY_LOGGED, <String, String>{});

    if (isLoggedIn) {
      _navigateToHomeScreen();
    }
  }
}
