import 'package:flutter/material.dart';
import 'package:testfluter/res/colors.dart';
import 'package:testfluter/res/strings.dart';

class DeviceCard extends StatefulWidget {
  const DeviceCard({
    super.key,
    required this.onPressedCallback,
    this.image,
  });

  final VoidCallback onPressedCallback;
  final String? image;

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF222222),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.image != null
                          ? Container(
                              width: 60.0,
                              height: 60.0,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                image: DecorationImage(
                                  image: NetworkImage(widget.image ?? ""),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: 60.0,
                              height: 60.0,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/smart_color.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: TextButton(
                      onPressed: widget.onPressedCallback,
                      child: const Text(
                        Strings.add,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.blueLight,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
