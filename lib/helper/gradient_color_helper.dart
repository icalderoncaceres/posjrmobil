import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientColorHelper{
  static final Color splashColor1 = Get.isDarkMode ? const Color(0xFFCC003F) : const Color(0xFFCC003F).withValues(alpha:.15);
  static final Color splashColor2 = Get.isDarkMode ? const Color(0xFF003473).withValues(alpha:.15) : const Color(0xFF003473).withValues(alpha:.15);
  static LinearGradient gradientColor({double? opacity}) {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.topLeft,
      colors: <Color>[
        opacity == null ? splashColor1 : splashColor1.withValues(alpha:opacity),
        opacity == null ? splashColor2 : splashColor2.withValues(alpha:opacity),
      ],
    );
  }

}