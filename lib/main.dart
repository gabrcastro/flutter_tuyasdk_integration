import 'package:flutter/material.dart';
import 'package:testfluter/add_device/config_network.dart';
import 'package:testfluter/add_device/pairing_device_screen.dart';
import 'package:testfluter/login/login_screen.dart';
import 'package:testfluter/res/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blueLight),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      //LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
