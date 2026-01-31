import 'package:flutter/material.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CustomSearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final Function iconPressed;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final Function? filterAction;
  final bool isFilter;
  final Color? borderColor;
  final Color? hitColor;
  final Color? prefixColor;
  final Function()? onSuffixIconTap;
  final IconData? suffixIcon;
  final Color? suffixIconColor;

  const CustomSearchFieldWidget({Key? key,
    required this.controller,
    required this.hint,
    required this.prefix,
    required this.iconPressed,
    this.onSubmit,
    this.onChanged,
    this.filterAction,
    this.isFilter = false,
    this.borderColor,
    this.hitColor,
    this.prefixColor,
    this.onSuffixIconTap,
    this.suffixIcon, this.suffixIconColor
  }) : super(key: key);

  @override
  State<CustomSearchFieldWidget> createState() => _CustomSearchFieldWidgetState();
}

class _CustomSearchFieldWidgetState extends State<CustomSearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: widget.hitColor ?? Theme.of(context).disabledColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            filled: true, fillColor: Theme.of(context).cardColor,
            isDense: true,
            focusedBorder:OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor, width: .70),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor, width: .70),
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: IconButton(
              onPressed: widget.iconPressed as void Function()?,
              icon: Icon(widget.prefix, color: widget.prefixColor ?? Theme.of(context).hintColor),
            ),
            suffixIcon: IconButton(
              onPressed: widget.onSuffixIconTap,
              icon: Icon(widget.suffixIcon, color: widget.suffixIconColor ?? Theme.of(context).hintColor),
            ),
          ),
          onSubmitted: widget.onSubmit as void Function(String)?,
          onChanged: widget.onChanged,
        ),
      ),

      
     widget.isFilter ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            widget.filterAction!(details.globalPosition);
          },
          child: Image.asset(Images.filterIcon, width: Dimensions.paddingSizeLarge),
        ),
      ) : const SizedBox(),
    ],);
  }
}
