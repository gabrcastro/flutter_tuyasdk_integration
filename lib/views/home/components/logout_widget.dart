import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfluter/views/login/login.view.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/utils/enums.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const channel = MethodChannel(Constants.CHANNEL);

    void _navigateToLoginScreen() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SigninView(),
        ),
        ModalRoute.withName('/auth'),
      );
    }

    Future<bool> _logout() async {
      bool result = await channel.invokeMethod(Methods.LOGOUT,
          <String, String>{});
      return result;
    }

    return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Deseja realmente sair da sua conta?',
                style: TextStyle(color: AppColors.white),
              ),
              TextButton(
                onPressed: () async {
                 bool result = await _logout();
                 if (result == true) {
                   _navigateToLoginScreen();
                 }
                },
                child: Text(
                  "sim".toUpperCase(),
                  style: const TextStyle(color: AppColors.blueLight),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
        );
  }
}
