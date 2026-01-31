
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/features/unit/widgets/unit_status_header_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewUnitScreen extends StatefulWidget {
  final Units? unit;
  final int? index;
  const AddNewUnitScreen({Key? key, this.unit, this.index}) : super(key: key);

  @override
  State<AddNewUnitScreen> createState() => _AddNewUnitScreenState();
}

class _AddNewUnitScreenState extends State<AddNewUnitScreen> {
  late bool update;
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    update = widget.unit != null;
    if(update){
      _unitController.text = widget.unit!.unitType!;
      Get.find<UnitController>().unitActiveState = widget.unit?.status ?? 0;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: CustomAppBarWidget(title: update ? 'edit_unit'.tr : 'unit'.tr),
      body: GetBuilder<UnitController>(builder: (unitController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          if(!update)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: Text('add_unit'.tr, style: ubuntuMedium),
            )
          else
            UnitStatusHeaderWidget(unit: widget.unit, index: widget.index),

          Expanded(child: SingleChildScrollView(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

              Container(
                padding: EdgeInsets.all(Dimensions.fontSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [


                  CustomFieldWithTitleWidget(
                    title: 'unit_name'.tr,
                    padding: 0,
                    requiredField: true,
                    customTextField: CustomTextFieldWidget(
                      controller: _unitController,
                      focusNode: _unitFocusNode,
                      hintText: 'type_unit_name'.tr,
                      fontSize: Dimensions.fontSizeSmall,
                      contentPadding: Dimensions.paddingSizeDefault,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]),
          ))),

          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeLarge),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  offset: Offset(0, -10),
                  blurRadius: 10,
                  color: Colors.black.withValues(alpha: 0.05),
                )]
            ),
            child: Row(children: [

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'reset'.tr,
                  isClear: true,
                  isButtonTextBold: true,
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                  onPressed:() {
                    _unitController.text = widget.unit?.unitType ?? '';
                    unitController.onChangeUnitActiveStatus(widget.unit?.status ?? 0);

                  },
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomButtonWidget(
                  isLoading: unitController.isLoading,
                  buttonText: update? 'update'.tr :'submit'.tr,
                  isButtonTextBold: true,
                  onPressed: (){
                    int? categoryId  =  update? widget.unit!.id : null;
                    String categoryName  =  _unitController.text.trim();
                    unitController.addUnit(categoryName, categoryId, update);
                  },
                ),
              ),
            ]),
          ),
        ]);
      }),
    );
  }
}
