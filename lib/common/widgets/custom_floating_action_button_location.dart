import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {

  final Size size = MediaQuery.of(Get.context!).size;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;
    double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - size.height * 0.015; // Adjust the "30" value to position lower
    return Offset(fabX, fabY);
  }
}