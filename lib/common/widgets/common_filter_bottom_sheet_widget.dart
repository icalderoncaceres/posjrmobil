import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_calendar_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/common/widgets/custom_date_range_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_select_card_widget.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CommonFilterBottomSheetWidget extends StatelessWidget {
  final bool canFilter;
  final VoidCallback onSubmitTap;
  final VoidCallback onClearTap;
  const CommonFilterBottomSheetWidget({
    super.key,
    required this.onSubmitTap,
    required this.onClearTap,
    required this.canFilter,
  });

  @override
  Widget build(BuildContext context) {
    final double longestSize = MediaQuery.sizeOf(context).longestSide;

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: GetBuilder<FilterController>(
        builder: (filterController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'filter'.tr,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),

                      Text(
                        'filter_to_quickly_find_what_you_need'.tr,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: context.customThemeColors.textOpacityColor,
                        ),
                      ),
                    ],
                  ),

                  CustomClearIconWidget(
                    transform: Matrix4.translationValues(10, -15, 0),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeLarge),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'date'.tr,
                        style: ubuntuMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: SizedBox(
                                height: longestSize * 0.45,
                                child: CustomCalendarWidget(
                                  initDateRange: PickerDateRange(
                                    filterController.startDate,
                                    filterController.endDate,
                                  ),
                                  onSubmit: (range) {
                                    filterController.setSelectedDate(
                                      startDate: range?.startDate,
                                      endDate: range?.endDate,
                                    );
                                  },
                                  onCancel: () => Navigator.of(context).pop(),
                                ),
                              ),
                            );
                          },
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeMediumBorder,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(
                                context,
                              ).hintColor.withValues(alpha: .3),
                            ),
                            borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeMediumBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomDateRangePickerWidget(
                                    text: filterController.startDate == null
                                        ? 'From Date'
                                        : DateConverterHelper.dateStringMonthYear(
                                            filterController.startDate,
                                          ),
                                  ),

                                  Icon(
                                    Icons.arrow_right_alt,
                                    size: Dimensions.paddingSizeLarge,
                                    color: Theme.of(context).hintColor,
                                  ),

                                  CustomDateRangePickerWidget(
                                    text: filterController.endDate == null
                                        ? 'To Date'
                                        : DateConverterHelper.dateStringMonthYear(
                                            filterController.endDate,
                                          ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                ),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: context
                                      .customThemeColors
                                      .textOpacityColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.paddingSizeDefault),

                      Text(
                        'sorting'.tr,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: AppConstants.sortingTypeList.length,
                        itemBuilder: (context, index) {
                          final String sortingType =
                              AppConstants.sortingTypeList[index];
                          final bool isSelected =
                              filterController.selectedSortingType ==
                              sortingType;

                          return CustomSelectCardWidget(
                            onTap: () => filterController.updateSelectedFavType(
                              sortingType,
                            ),
                            isSelected: isSelected,
                            label: sortingType,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: Dimensions.fontSizeSmall),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                ),
                child: SizedBox(
                  height: Dimensions.paddingSizeRevenueBottom,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          buttonText: 'clear_filter'.tr,
                          isButtonTextBold: true,
                          isClear: true,
                          textColor: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.color,
                          buttonColor: Theme.of(
                            context,
                          ).hintColor.withValues(alpha: 0.20),
                          onPressed: onClearTap,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(
                        child: CustomButtonWidget(
                          isLoading: false,
                          buttonText: 'apply'.tr,
                          isButtonTextBold: true,
                          onPressed: canFilter ? onSubmitTap : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
