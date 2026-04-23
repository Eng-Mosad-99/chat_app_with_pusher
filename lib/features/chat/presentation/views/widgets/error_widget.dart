import 'package:chat_app_with_pusher/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ErrorAlertWidget extends StatelessWidget {
  const ErrorAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.getWidth(context),
      height: Sizes.getHeight(context),
      child: const Center(
          child: Icon(
        Icons.error,
        color: Colors.redAccent,
        size: 150,
      )),
    );
  }
}