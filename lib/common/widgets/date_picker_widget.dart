import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomCalendarWidget extends StatefulWidget {
  final PickerDateRange? initDateRange;
  final Function(PickerDateRange? dateRange) onSubmit;
  const CustomCalendarWidget({super.key, required this.onSubmit, this.initDateRange});

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Get.isDarkMode ? Theme.of(context).dividerColor : Theme.of(context).canvasColor,
      child: SfDateRangePicker(
        showActionButtons: true,
        headerStyle: DateRangePickerHeaderStyle(backgroundColor: Get.isDarkMode ? Theme.of(context).dividerColor : Theme.of(context).canvasColor,textAlign: TextAlign.center),
        backgroundColor: Get.isDarkMode ? Theme.of(context).dividerColor : Theme.of(context).canvasColor,
        cancelText: 'cancel'.tr,
        confirmText: 'apply'.tr,
        onCancel: () => Get.back(),
        onSubmit: (value){

          if(value is PickerDateRange) {

            widget.onSubmit(value);

            Get.back();
          }

        },
        todayHighlightColor: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
        selectionMode: DateRangePickerSelectionMode.range,
        rangeSelectionColor: Theme.of(context).primaryColor.withValues(alpha:.1),

        view: DateRangePickerView.month,
        enableMultiView: true,
        navigationDirection: ResponsiveHelper.isTab(context) ? DateRangePickerNavigationDirection.horizontal : DateRangePickerNavigationDirection.vertical,
        startRangeSelectionColor: Theme.of(context).primaryColor.withValues(alpha: 1),
        endRangeSelectionColor: Theme.of(context).primaryColor.withValues(alpha: 1),
        selectionTextStyle: const TextStyle(color: Colors.white),
        initialSelectedRange:
        widget.initDateRange != null ?
        PickerDateRange(
          widget.initDateRange?.startDate ,
          widget.initDateRange?.endDate ,
        ) :
        null,
        monthViewSettings: const DateRangePickerMonthViewSettings(showTrailingAndLeadingDates: true),

      ),
    );

  }
}