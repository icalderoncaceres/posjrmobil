import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/features/counter/widgets/counter_setup_tab_widget.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';

class CounterSetupScreen extends StatefulWidget {
  final Counter? counter;
  const CounterSetupScreen({super.key, this.counter});

  @override
  State<CounterSetupScreen> createState() => _CounterSetupScreenState();
}

class _CounterSetupScreenState extends State<CounterSetupScreen> {

  final TextEditingController _counterNameController = TextEditingController();
  final TextEditingController _counterNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _counterNameFocus = FocusNode();
  final FocusNode _counterNumberFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(widget.counter != null){
      _counterNameController.text = widget.counter?.name ?? '';
      _counterNumberController.text = widget.counter?.number ?? '';
      _descriptionController.text = widget.counter?.description ?? '';
    }

  }


  @override
  void dispose() {
    _counterNameController.dispose();
    _counterNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: ResponsiveHelper.isTab(context)
          ? CounterSetupTabWidget(
        counter: widget.counter,
        counterNameController: _counterNameController,
        counterNumberController: _counterNumberController,
        descriptionController: _descriptionController,
        counterNameFocus: _counterNameFocus,
        counterNumberFocus: _counterNumberFocus,
        descriptionFocus: _descriptionFocus,
      ) : Column(children: [

        CustomHeaderWidget(title: 'counter_setup'.tr),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Expanded(
          child: SingleChildScrollView(child: Column(children: [

            CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(
                fillColor: Colors.transparent,
                hintText: 'counter_name_hint_text'.tr,
                controller: _counterNameController,
                focusNode: _counterNameFocus,
                nextFocus: _counterNumberFocus,
                inputType: TextInputType.emailAddress,
              ),
              title: 'counter_name'.tr,
            ),

            CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(
                fillColor: Colors.transparent,
                hintText: 'counter_number_hint_text'.tr,
                controller: _counterNumberController,
                focusNode: _counterNumberFocus,
                nextFocus: _descriptionFocus,
                inputType: TextInputType.text,
              ),
              title: 'counter_number'.tr,
            ),

            CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(
                fillColor: Colors.transparent,
                controller: _descriptionController,
                focusNode: _descriptionFocus,
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
                Expanded(
                  child: CustomButtonWidget(
                    isLoading: counterController.isLoading,
                    buttonText: "reset".tr,
                    buttonColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    isBorder: true,
                    isClear: true,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {

                      if(widget.counter != null){
                        _counterNameController.text = widget.counter?.name ?? '';
                        _counterNumberController.text = widget.counter?.number ?? '';
                        _descriptionController.text = widget.counter?.description ?? '';
                      }else {
                        _counterNameController.clear();
                        _counterNumberController.clear();
                        _descriptionController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
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

    if(_counterNameController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_counter_name'.tr, isError: true);
    }else if(_counterNumberController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_counter_name'.tr, isError: true);
    }else if(_descriptionController.text.trim().isEmpty){
      showCustomSnackBarHelper('enter_description'.tr, isError: true);
    }else{
      if(widget.counter != null){
        if( widget.counter?.name == _counterNameController.text.trim() &&
            widget.counter?.number == _counterNumberController.text.trim() &&
            widget.counter?.description == _descriptionController.text.trim()){
          showCustomSnackBarHelper('something_needs_to_change'.tr, isError: true);
        }else{
          counterController.updateCounter(
            id: widget.counter?.id ?? 0,
            name: _counterNameController.text.trim(),
            number: _counterNumberController.text.trim(),
            description: _descriptionController.text.trim(),
          ).then((value){
            Get.back();
            showCustomSnackBarHelper("counter_updated_successfully".tr, isError: false);
          });
        }


      }else{
        counterController.addCounter(
          name: _counterNameController.text.trim(),
          number: _counterNumberController.text.trim(),
          description: _descriptionController.text.trim(),
        );
      }


    }
  }
}
