import 'package:chat_app_with_pusher/core/constants/sizes.dart';
import 'package:flutter/material.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Sizes.getHeight(context),
        width: Sizes.getWidth(context),
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}