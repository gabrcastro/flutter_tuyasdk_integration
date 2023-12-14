import 'package:flutter/material.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/views/login/login.view.dart';

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
      home: const SigninView(),
      //LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
