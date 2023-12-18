import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testfluter/User.dart';
import 'package:testfluter/di/dependency_injection.dart';
import 'package:testfluter/view_models/auth.viewmodel.dart';
import 'package:testfluter/view_models/home.viewmodel.dart';
import 'package:testfluter/res/strings.dart';
import 'package:testfluter/utils/enums.dart';
import 'package:testfluter/models/login.model.dart';
import 'package:testfluter/views/home/home.view.dart';
import 'package:testfluter/views/register/register_screen.dart';

import '../../res/colors.dart';

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {

  final AuthViewModel authViewModel = locator<AuthViewModel>();
  final HomeViewModel homeViewModel = locator<HomeViewModel>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwController = TextEditingController();

  User? currentUser;
  bool isLoading = false;

  void ifAlreadyIsLoggedIn() async {
    bool res = await authViewModel.checkIsLoggedIn();
    if (res) {
      _navigateToHomeScreen();
    }
  }

  @override
  void initState() {
    super.initState();

    ifAlreadyIsLoggedIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwController.dispose();
    super.dispose();
  }

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
                            onPressed: () async {
                              if (_emailController.text.isNotEmpty &&
                                  _passwController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });

                                await authViewModel.login(LoginModel(
                                    "55",
                                    _emailController.text,
                                    _passwController.text));

                                bool success =
                                    await homeViewModel.getHomeAndGroup();

                                setState(() {
                                  isLoading = false;
                                });

                                if (success) {
                                  _navigateToHomeScreen();
                                } else {
                                  // TODO: return error message
                                }
                              }
                            },
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
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
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

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }
}
