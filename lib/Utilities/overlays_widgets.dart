import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vmpa/Constant/color.dart';

Widget loadingWidget = SizedBox(
  width: 50,
  child: LoadingAnimationWidget.staggeredDotsWave(color: const Color.fromARGB(255, 103, 58, 183), size: 50),
);

Future<dynamic> loadingOverlay(String? text) {
  return Get.defaultDialog(
    backgroundColor: AppColors.white,
    content: loadingWidget,
    title: text ?? 'Loading',
    barrierDismissible: false,
  );
}

void errorOverlay(String text) {
  Get.defaultDialog(
    backgroundColor: AppColors.white,
    title: 'Failed',
    titleStyle: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
    content: Text(text),
  );
}
