import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/langulage/controllers/localization_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class ProductDiscountTextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;
  final bool isAmount;
  final bool isFullNumber;
  final bool amountIcon;
  final bool border;
  final bool isDescription;
  final bool idDate;
  final bool isPassword;
  final Function(String text)? onChanged;
  final Function(String text)? onFieldSubmit;
  final String? prefixIconImage;
  final bool isPos;
  final int? maxSize;
  final bool variant;
  final bool focusBorder;
  final bool showBorder;
  final Color borderColor;
  final bool required;
  final bool isLabel;
  final bool isDiscountAmount;
  final Function(String text)? onDiscountTypeChanged;

  const ProductDiscountTextFieldWidget(
      {Key? key, this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor,
        this.isAmount = false,
        this.isFullNumber = false,
        this.amountIcon = false,
        this.border = false,
        this.isDescription = false,
        this.onChanged,
        this.onFieldSubmit,
        this.idDate = false, this.prefixIconImage,
        this.isPassword = false,
        this.isPos = false,
        this.maxSize,
        this.variant = false,
        this.focusBorder = true,
        this.showBorder = false,
        this.borderColor = const Color(0x261455AC),
        this.required = false,
        this.isLabel = false,
        this.isDiscountAmount = false,
        this.onDiscountTypeChanged
      }) : super(key: key);

  @override
  State<ProductDiscountTextFieldWidget> createState() => _ProductDiscountTextFieldWidgetState();
}

class _ProductDiscountTextFieldWidgetState extends State<ProductDiscountTextFieldWidget> {
  final bool _obscureText = true;
  bool _isDiscountAmount = true;
  final splashController = Get.find<SplashController>();

  @override
  void initState() {
    _isDiscountAmount = widget.isDiscountAmount;
    super.initState();
  }

  void _toggleDiscountType() {
    setState(() {
      _isDiscountAmount = !_isDiscountAmount;
    });
  }

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLine ?? 1,
        textCapitalization: widget.capitalization,
        maxLength: widget. maxSize ?? (widget.isPhoneNumber ? 15 : null),
        focusNode: widget.focusNode,
        initialValue: null,
        obscureText: widget.isPassword?_obscureText: false,
        onChanged: widget.onChanged,
        enabled: widget.idDate ? false : true,
        inputFormatters: (widget.textInputType == TextInputType.phone || widget.isPhoneNumber) ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
            : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : widget.isFullNumber ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]  : null,
        keyboardType: widget.isAmount ? TextInputType.number : widget.textInputType ?? TextInputType.text,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: widget.onFieldSubmit ?? (v) {
          FocusScope.of(context).requestFocus(widget.nextNode);
        },
        validator: (input){
          if(input!.isEmpty){
            if(widget.isValidator){
              return widget.validatorMessage??"";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: widget.variant ? 5 : 20, minHeight: widget.variant ? 5 : 20),
          prefixIcon: widget.prefixIconImage != null ?
          Padding(padding: EdgeInsets.fromLTRB(Get.find<LocalizationController>().isLtr? 0 :
          Dimensions.paddingSizeSmall , 0, Get.find<LocalizationController>().isLtr?Dimensions.paddingSizeSmall:0,0),
              child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall+3),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:.135)),
                  child: Image.asset(widget.prefixIconImage!,width: 20, height: 20))) : const SizedBox(),
          suffixIconConstraints:  BoxConstraints(minWidth:widget.variant ? 5 : widget.isPos? 0 : 40,
              minHeight:widget.variant ? 5 : 20),


          suffixIcon: FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Container(
                      width: 1,
                      color: Theme.of(context).hintColor,
                    ),
                  ),

                  PopupMenuButton<int>(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeMediumBorder)),
                    ),
                    padding: EdgeInsets.zero,
                    menuPadding: EdgeInsets.zero,
                    offset: const Offset(10, 40),
                    onSelected: (value) {
                      if((value == 1 && !_isDiscountAmount) || (value == 2 && _isDiscountAmount)){
                        _toggleDiscountType();
                      }
                      widget.onDiscountTypeChanged!(_isDiscountAmount ? 'amount' : 'percent');
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        value: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeMediumBorder), topRight: Radius.circular(Dimensions.paddingSizeMediumBorder)),
                            color: _isDiscountAmount ? Theme.of(context).primaryColor.withValues(alpha: .2) : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${"amount".tr} (${splashController.configModel!.currencySymbol ?? ''})',
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        value: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeMediumBorder), bottomRight: Radius.circular(Dimensions.paddingSizeMediumBorder)),
                            color: !_isDiscountAmount ? Theme.of(context).primaryColor.withValues(alpha: .2) : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${"percentage".tr} (%)',
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isDiscountAmount ? '${ "amount".tr} (${splashController.configModel!.currencySymbol ?? ''})' : '${"percentage".tr} (%)',
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                        ),

                        const Icon(Icons.keyboard_arrow_down_sharp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          hintText: widget.hintText ?? '',
          focusedBorder: widget.focusBorder ? OutlineInputBorder(borderSide: BorderSide(color: widget.borderColor.withValues(alpha: 1))) : null,



          filled: widget.fillColor != null,
          fillColor: widget.fillColor,
          isDense: true,
          contentPadding:  EdgeInsets.symmetric(vertical: 10.0, horizontal:widget.variant? 0: 10),
          alignLabelWithHint: true,
          counterText: '',
          hintStyle: ubuntuRegular.copyWith(color: Theme.of(context).hintColor),
          errorStyle: const TextStyle(height: 1.5),
          border: widget.isLabel ? InputBorder.none : widget.border ?
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: widget.borderColor,
                width: widget.showBorder ? 0 : .75,)) : InputBorder.none,

          enabledBorder: widget.border ? OutlineInputBorder(borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: widget.borderColor,
                width: widget.showBorder ? 0 : .75,)) : null,



          label: widget.isLabel ? Text.rich(TextSpan(children: [
            TextSpan(text: widget.hintText??'', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withValues(alpha:.75))),
            if(widget.required && widget.hintText != null)
              TextSpan(text : ' *', style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge))
          ])) : null,
        ),
      ),
    );
  }
}
