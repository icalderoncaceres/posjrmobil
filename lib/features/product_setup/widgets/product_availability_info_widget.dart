import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class ProductAvailabilityInfoWidget extends StatelessWidget {
  const ProductAvailabilityInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (productController) {
        return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: 0),
            child: Text('availability'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ),
          
          Container(
            padding: const EdgeInsets.all(Dimensions.fontSizeSmall),
            color: Theme.of(context).cardColor,
            child: Container(
              padding: EdgeInsets.all(Dimensions.fontSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: ResponsiveHelper.isTab(context) ?
              Row(children: [
                Expanded(
                  child: _customTimeWidget(
                    title: 'available_time_starts'.tr,
                    onTap: () async{
                      TimeOfDay? time  = await _showCustomTimePicker();
                      productController.updateStartTime(DateConverterHelper.convertTimeOfDayToString(time!));
                    },
                    time: productController.startTime ?? '-- : -- --',
                  ),
                ),

                Expanded(
                  child: _customTimeWidget(
                    title: 'available_time_ends'.tr,
                    onTap: () async{
                      TimeOfDay? time  = await _showCustomTimePicker();
                      productController.updateEndTime(DateConverterHelper.convertTimeOfDayToString(time!));
                    },
                    time: productController.endTime ?? '-- : -- --',
                  ),
                ),
              ]) :
              Column(children: [
                _customTimeWidget(
                  title: 'available_time_starts'.tr,
                    onTap: () async{
                      TimeOfDay? time  = await _showCustomTimePicker();
                      productController.updateStartTime(DateConverterHelper.convertTimeOfDayToString(time!));
                    },
                    time: productController.startTime ?? '-- : -- --',
                ),

                _customTimeWidget(
                  title: 'available_time_ends'.tr,
                  onTap: () async{
                    TimeOfDay? time  = await _showCustomTimePicker();
                    productController.updateEndTime(DateConverterHelper.convertTimeOfDayToString(time!));
                  },
                  time: productController.endTime ?? '-- : -- --',
                ),
                
              ]),
            ),
          )
        
        ]));
      }
    );
  }
}

class _customTimeWidget extends StatelessWidget {
  final Function() onTap;
  final String time;
  final String title;

  const _customTimeWidget({
    required this.onTap, required this.time, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomFieldWithTitleWidget(
        title: title,
        customTextField: Container(
          height: Dimensions.heightWidth50,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
            border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.3))
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text(time, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

              Icon(Icons.watch_later_outlined, color: Theme.of(context).hintColor.withValues(alpha: 0.9),)
            ]),
        ),
      ),
    );
  }
}

Future<TimeOfDay?> _showCustomTimePicker() async {
  return await showTimePicker(
      context: Get.context!, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      builder: (BuildContext ctx, Widget? child){
        return Theme(
            data: ThemeData.light().copyWith(
                timePickerTheme: TimePickerThemeData(
                  hourMinuteColor: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.1),
                  dayPeriodColor: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.4),
                  hourMinuteTextColor: Get.context!.customThemeColors.textColor, // Text color for hours and minutes
                  dayPeriodTextColor: Colors.black, // Text color for AM/PM
                  dialHandColor: Theme.of(Get.context!).primaryColor,
                  hourMinuteTextStyle: TextStyle(fontSize: 30),
                  cancelButtonStyle: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Theme.of(Get.context!).hintColor.withValues(alpha: 0.3)), foregroundColor:WidgetStateProperty.all<Color>(Theme.of(Get.context!).primaryColor)),
                  confirmButtonStyle: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Theme.of(Get.context!).primaryColor), foregroundColor:WidgetStateProperty.all<Color>(Theme.of(Get.context!).cardColor)),// Text style for hours and minutes
                )
            ),
            child: MediaQuery(
                data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
                child: child!
            )
        );
      }
  );
}

// String _formatTimeOfDay24Hour(TimeOfDay time) {
//   final hour = time.hour.toString().padLeft(2, '0');
//   final minute = time.minute.toString().padLeft(2, '0');
//   return '$hour:$minute';
// }


