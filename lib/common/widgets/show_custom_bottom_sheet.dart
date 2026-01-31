import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';

Future<void> showCustomBottomSheet({
  required Widget child,
  double? topLeftRadius,
  double? topRightRadius,
}) async {
  await showModalBottomSheet(
    context: Get.context!,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(minWidth: double.infinity, maxHeight: (MediaQuery.of(Get.context!).size.height * 0.95) - MediaQuery.of(Get.context!).viewInsets.bottom),
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: Theme.of(Get.context!).brightness == Brightness.dark ? 0.8 : 0.6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius ?? Dimensions.paddingSizeExtraExtraLarge),
        topRight: Radius.circular(topRightRadius ?? Dimensions.paddingSizeExtraExtraLarge),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: child,
      );
    },
  );
}