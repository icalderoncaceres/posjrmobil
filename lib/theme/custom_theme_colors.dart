import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color holdButtonColor;
  final Color textColor;
  final Color textOpacityColor;
  final Color titleColor;
  final Color checkOutTextColor;
  final Color categoryWithProductColor;
  final Color iconBgColor;
  final Color downloadFormatColor;
  final Color borderPrimaryColor;
  final Color backgroundShadowColor;
  final Color blackColor;
  final Color deleteButtonColor;
  final Color screenBackgroundColor;
  final Color infoColor;
  const CustomThemeColors({
    required this.holdButtonColor,
    required this.textColor,
    required this.titleColor,
    required this.checkOutTextColor,
    required this.categoryWithProductColor,
    required this.iconBgColor,
    required this.downloadFormatColor,
    required this.borderPrimaryColor,
    required this.backgroundShadowColor,
    required this.blackColor,
    required this.textOpacityColor,
    required this.deleteButtonColor,
    required this.screenBackgroundColor,
    required this.infoColor
  });

  // Predefined themes for light and dark modes
  factory CustomThemeColors.light() => const CustomThemeColors(
    holdButtonColor: Color(0xffDE8500),
    textColor: Color(0xFF25282B),
    titleColor: Color(0xFF003473),
    checkOutTextColor: Color(0xFF4C5D70),
    categoryWithProductColor: Color(0xFFBDC1C4),
    iconBgColor: Color(0xFFF9F9F9),
    downloadFormatColor: Color(0xFF009CD6),
    borderPrimaryColor: Color(0xFF003E47),
    backgroundShadowColor: Color(0xFFF7F9FA),
    blackColor: Color(0xFF000000),
    textOpacityColor: Color(0xFF5E6472),
    deleteButtonColor: Color(0xFFC33D3D),
    screenBackgroundColor: Color(0xFFf8fbff),
    infoColor: Color(0xFF3C76F1),
  );

  factory CustomThemeColors.dark() => const CustomThemeColors(
    holdButtonColor: Color(0xffDE8500),
    textColor: Color(0xFFE4E8EC),
    titleColor: Color(0xFFE4E8EC),
    checkOutTextColor: Color(0xFFE4E8EC),
    categoryWithProductColor: Color(0xFF989797),
    iconBgColor: Color(0xFF2e2e2e),
    downloadFormatColor: Color(0xFF009CD6),
    borderPrimaryColor: Color(0xFF003E47),
    backgroundShadowColor: Color(0xFFF7F9FA),
    blackColor: Color(0xFF000000),
    textOpacityColor: Color(0xFF5E6472),
    deleteButtonColor: Color(0xFFC33D3D),
    screenBackgroundColor: Color(0xFFf8fbff),
    infoColor: Color(0xFF3C76F1),
  );

  @override
  CustomThemeColors copyWith({
    Color? holdButtonColor,
    Color? textColor,
    Color? titleColor,
    Color? checkOutTextColor,
    Color? categoryWithProductColor,
    Color? iconBgColor,
    Color? downloadFormatColor,
    Color? borderPrimaryColor,
    Color? backgroundShadowColor,
    Color? blackColor,
    Color? textOpacityColor,
    Color? deleteButtonColor,
    Color? screenBackgroundColor,
    Color? infoColor,
  }) {
    return CustomThemeColors(
      holdButtonColor: holdButtonColor ?? this.holdButtonColor,
      textColor: textColor ?? this.textColor,
      titleColor: textColor ?? this.titleColor,
      checkOutTextColor: checkOutTextColor ?? this.checkOutTextColor,
      categoryWithProductColor: categoryWithProductColor ?? this.categoryWithProductColor,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      downloadFormatColor: downloadFormatColor ?? this.downloadFormatColor,
      borderPrimaryColor: borderPrimaryColor ?? this.borderPrimaryColor,
      backgroundShadowColor: backgroundShadowColor ?? this.backgroundShadowColor,
      blackColor: blackColor ?? this.blackColor,
      textOpacityColor: textOpacityColor ?? this.textOpacityColor,
      deleteButtonColor: deleteButtonColor ?? this.deleteButtonColor,
      screenBackgroundColor: screenBackgroundColor ?? this.screenBackgroundColor,
      infoColor: infoColor ?? this.infoColor
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;

    return CustomThemeColors(
      holdButtonColor: Color.lerp(holdButtonColor, other.holdButtonColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      checkOutTextColor: Color.lerp(checkOutTextColor, other.checkOutTextColor, t)!,
      categoryWithProductColor: Color.lerp(categoryWithProductColor, other.categoryWithProductColor, t)!,
      iconBgColor: Color.lerp(iconBgColor, other.iconBgColor, t)!,
      downloadFormatColor: Color.lerp(downloadFormatColor, other.downloadFormatColor, t)!,
      borderPrimaryColor: Color.lerp(borderPrimaryColor, other.borderPrimaryColor, t)!,
      backgroundShadowColor: Color.lerp(backgroundShadowColor, other.backgroundShadowColor, t)!,
      blackColor: Color.lerp(blackColor, other.blackColor, t)!,
      textOpacityColor: Color.lerp(textOpacityColor, other.textOpacityColor, t)!,
      deleteButtonColor: Color.lerp(deleteButtonColor, other.deleteButtonColor, t)!,
      screenBackgroundColor: Color.lerp(screenBackgroundColor, other.screenBackgroundColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
    );
  }
}