import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int? maxLines;
  final TextCapitalization capitalization;
  final String? prefixIcon;
  final String? suffixIcon;
  final bool suffix;
  final Color? fillColor;
  final int? maxLength;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;
  final double? fontSize;
  final double? contentPadding;
  final TextAlign? textAlign;


  const CustomTextFieldWidget(
      {super.key,
        this.hintText,
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onSubmit,
        this.onChanged,
        this.prefixIcon,
        this.suffixIcon,
        this.suffix = false,
        this.capitalization = TextCapitalization.none,
        this.isPassword = false,
        this.fillColor,
        this.inputFormatters,
        this.maxLength,
        this.borderColor,
        this.minLines = 1,
        this.fontSize,
        this.contentPadding,
        this.textAlign,
      });

  @override
  CustomTextFieldWidgetState createState() => CustomTextFieldWidgetState();
}

class CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: widget.textAlign ?? TextAlign.start,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: ubuntuRegular.copyWith(fontSize: widget.fontSize ?? Dimensions.fontSizeLarge),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      maxLength: widget.maxLength,
      autofillHints: widget.inputType == TextInputType.name ? [AutofillHints.name]
          : widget.inputType == TextInputType.emailAddress ? [AutofillHints.email]
          : widget.inputType == TextInputType.phone ? [AutofillHints.telephoneNumber]
          : widget.inputType == TextInputType.streetAddress ? [AutofillHints.fullStreetAddress]
          : widget.inputType == TextInputType.url ? [AutofillHints.url]
          : widget.inputType == TextInputType.visiblePassword ? [AutofillHints.password] : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters
          ?? (widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor.withValues(alpha:0.5), width: 1),
        ),

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor.withValues(alpha:0.3), width: 0.5)
        ),

        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor.withValues(alpha:0.3), width: 0.5)
        ),

        contentPadding: EdgeInsets.all(widget.contentPadding ?? Dimensions.fontSizeSmall),
        isDense: true,
        hintText: widget.hintText ?? 'write_something'.tr,
        fillColor: widget.fillColor ?? Theme.of(context).cardColor,
        hintStyle: ubuntuRegular.copyWith(fontSize: widget.fontSize ?? Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
        filled: true,
        prefixIcon: widget.prefixIcon != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Image.asset(widget.prefixIcon!, height: 20, width: 20),
        ) : null,

        suffixIcon: widget.suffix? Container(width:Dimensions.iconSizeVerySmall,height: Dimensions.iconSizeVerySmall,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(widget.suffixIcon!, scale: 4,color: Theme.of(context).primaryColor,)) :widget.isPassword ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withValues(alpha:0.3)),
          onPressed: _toggle,
        ) : null,
      ),
      onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null ? widget.onSubmit!(text) : null,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}