import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';

void showCustomSnackBarHelper(String? message, {bool isError = true}) {
  Get.showSnackbar(GetSnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    message: message,
    maxWidth: Dimensions.webMaxWidth,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    borderRadius: Dimensions.radiusSmall,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}