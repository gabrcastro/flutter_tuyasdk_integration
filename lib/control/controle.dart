import 'package:flutter/material.dart';
import 'package:testfluter/res/colors.dart';

class ControlScreen extends StatefulWidget {
  final String deviceName;

  const ControlScreen({super.key, required this.deviceName});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deviceName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new_rounded),
              color: AppColors.blueLight,
            ),
          ],
        ),
      ),
    );
  }
}
