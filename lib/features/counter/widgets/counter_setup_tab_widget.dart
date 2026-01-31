import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';

class CounterSetupTabWidget extends StatelessWidget {
  final Counter? counter;
  final TextEditingController counterNameController;
  final TextEditingController counterNumberController;
  final TextEditingController descriptionController;

  final FocusNode counterNameFocus;
  final FocusNode counterNumberFocus;
  final FocusNode descriptionFocus;

  const CounterSetupTabWidget({super.key,
    required this.counterNameController,
    required this.counterNumberController,
    required this.descriptionController,
    this.counter,
    required this.counterNameFocus,
    required this.counterNumberFocus,
    required this.descriptionFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [
      
        CustomHeaderWidget(title: 'counter_setup'.tr),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      
        Expanded(
          child: SingleChildScrollView(child: Column(children: [
      
            Row(children: [
              Expanded(
                child: CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(
                    fillColor: Colors.transparent,
                    hintText: 'counter_name_hint_text'.tr,
                    controller: counterNameController,
                    focusNode: counterNameFocus,
                    nextFocus: counterNumberFocus,
                    inputType: TextInputType.emailAddress,
                  ),
                  title: 'counter_name'.tr,
                ),
              ),
      
              Expanded(
                child: CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(
                    fillColor: Colors.transparent,
                    hintText: 'counter_number_hint_text'.tr,
                    controller: counterNumberController,
                    focusNode: counterNumberFocus,
                    nextFocus: descriptionFocus,
                    inputType: TextInputType.text,
                  ),
                  title: 'counter_number'.tr,
                ),
              ),
            ]),
      
      
      
            CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(
                fillColor: Colors.transparent,
                controller: descriptionController,
                focusNode: descriptionFocus,
                inputType: TextInputType.text,
                maxLines: 5,
              ),
              title: 'short_description'.tr,
            ),
      
          ])),
        ),
      
      
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical : Dimensions.paddingSizeDefault,
            ),
            decoration:  BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0,-4),
                    spreadRadius: 0,
                    blurRadius: 4,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.05)
                ),
              ],
            ),
            child: GetBuilder<CounterController>(builder: (counterController) {
              return Row(children: [
                Expanded(flex: 2, child: const SizedBox()),
      
                Expanded(flex: 1,
                  child: CustomButtonWidget(
                    isLoading: counterController.isLoading,
                    buttonText: "reset".tr,
                    buttonColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    isBorder: true,
                    isClear: true,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      counterNameController.clear();
                      counterNumberController.clear();
                      descriptionController.clear();
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
      
                Expanded(flex: 1,
                  child: CustomButtonWidget(
                    isLoading: counterController.isLoading,
                    buttonText: "submit".tr,
                    onPressed: ()=> _onSubmit(counterController),
                  ),
                ),
              ]);
            }),
          ),
        )
      
      
      ]),
    );
  }

  void _onSubmit (CounterController counterController){

    if(counterNameController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_counter_name'.tr, isError: true);
    }else if(counterNumberController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_counter_name'.tr, isError: true);
    }else if(descriptionController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_description'.tr, isError: true);
    }else{
      if(counter != null){
        if( counter?.name == counterNameController.text.trim() &&
            counter?.number == counterNumberController.text.trim() &&
            counter?.description == descriptionController.text.trim()){
          showCustomSnackBarHelper('something_needs_to_change'.tr, isError: true);
        }else{
          counterController.updateCounter(
            id: counter?.id ?? 0,
            name: counterNameController.text.trim(),
            number: counterNumberController.text.trim(),
            description: descriptionController.text.trim(),
          ).then((value){
            Get.back();
            showCustomSnackBarHelper("counter_updated_successfully".tr, isError: false);
          });
        }


      }else{
        counterController.addCounter(
          name: counterNameController.text.trim(),
          number: counterNumberController.text.trim(),
          description: descriptionController.text.trim(),
        ).then((value) async{
          Get.back();
        });
      }
    }
  }
}


