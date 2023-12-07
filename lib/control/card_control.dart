import 'package:flutter/material.dart';
import 'package:testfluter/res/colors.dart';

class CardControl extends StatelessWidget {

  final String title;
  final Widget children;

  const CardControl({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.grayBlack,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              title,
              style:
              const TextStyle(color: AppColors.white, fontSize: 16.0),
            ),
          ),
          const Divider(
            color: Color(0xFF646464),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: children
          ),
        ],
      ),
    );
  }
}
