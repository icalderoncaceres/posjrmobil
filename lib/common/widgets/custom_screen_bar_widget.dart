import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/enums/menu_download_type_enum.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_icon_button.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CustomScreenBarWidget extends StatelessWidget {
  final String? elementCount;
  final String title;
  final Color? backgroundColor;
  final bool isFiltered;
  final bool isSearchApplied;
  final Function()? onFilterButtonTap;
  final Function(String)? searchOnChange;
  final Function(String)? onSubmit;
  final Widget? suggestionListWidget;
  final Function() onDownloadPress;
  final String? searchText;

  const CustomScreenBarWidget({
    super.key,
    this.isFiltered = false,
    this.isSearchApplied = false,
    this.onFilterButtonTap,
    this.backgroundColor,
    required this.title,
    this.elementCount,
    this.searchOnChange,
    this.suggestionListWidget,
    required this.onDownloadPress,
    this.onSubmit,
    this.searchText
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey _searchButtonKey = GlobalKey();
    final TextEditingController _searchTextController = TextEditingController();
    _searchTextController.text = searchText ?? '';

    return Container(
      width: double.maxFinite,
      height: Dimensions.productImageSizeItem,
      color: backgroundColor ?? context.customThemeColors.screenBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall).copyWith(right: Dimensions.paddingSizeSmall),
      child: Row(children: [

        Text(title, style: ubuntuMedium.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: Dimensions.fontSizeDefault,
          overflow: TextOverflow.ellipsis,
        )),

        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeBorder),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.fontSizeSmall),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(elementCount ?? '0', style: ubuntuRegular.copyWith(
            color: Theme.of(context).cardColor,
            fontSize: Dimensions.fontSizeExtraSmall,
          )),
        ),

        Spacer(),

        if(searchOnChange != null)
        CustomIconButton(
          key: _searchButtonKey,
          isFiltered: isSearchApplied,
          onTap: ()=> showSearchDialog(
            context: context,
            searchButtonKey: _searchButtonKey,
            searchController: _searchTextController,
            searchOnChange: searchOnChange,
            onSubmit: onSubmit,
            suggestionListWidget: suggestionListWidget,
          ),
          icon: Padding(
            padding: const EdgeInsets.only(left: Dimensions.barWidthFlowChart),
            child: Icon(Icons.search, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ),
        SizedBox(width: Dimensions.paddingSizeDefault),

        CustomIconButton(
          isFiltered: isFiltered,
          onTap: onFilterButtonTap,
          icon: Icon(Icons.filter_list, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        SizedBox(width: Dimensions.paddingSizeSmall),

        CustomIconButton(
          onTap: onDownloadPress,
          icon: Icon(Icons.file_download_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
        )

      ]),
    );
  }
}



void showSearchDialog({
  required BuildContext context,
  required GlobalKey searchButtonKey,
  required TextEditingController searchController,
  Function(String)? searchOnChange,
  final Function(String)? onSubmit,
  Widget? suggestionListWidget,
}) {
  final RenderBox button = searchButtonKey.currentContext!.findRenderObject() as RenderBox;
  final buttonPosition = button.localToGlobal(Offset.zero);
  final buttonSize = button.size;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      final double heightSize = MediaQuery.sizeOf(context).height;
      final double widthSize = MediaQuery.sizeOf(context).width;

      return Stack(children: [
        Positioned(
          left: 20,
          right: 20,
          top: buttonPosition.dy + buttonSize.height,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              constraints: BoxConstraints(
                  maxHeight: heightSize * 0.5,
                  maxWidth: widthSize
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                CustomSearchFieldWidget(
                  controller: searchController,
                  hint: 'search'.tr,
                  prefix: Icons.search,
                  prefixColor: Theme.of(context).textTheme.bodyLarge?.color,
                  onChanged: (value){
                    if (searchOnChange != null) searchOnChange(value);
                  },
                  iconPressed: (){},
                  isFilter: false,
                  borderColor: Theme.of(context).hintColor.withValues(alpha: 0.30),
                  suffixIcon: searchController.text.isNotEmpty ? Icons.clear : Icons.arrow_forward_rounded,
                  suffixIconColor: searchController.text.isNotEmpty ? context.customThemeColors.textOpacityColor : Theme.of(context).primaryColor,
                  onSuffixIconTap: ()=> searchController.clear(),
                  onSubmit: onSubmit,
                ),

                if(suggestionListWidget != null)
                  suggestionListWidget,

              ]),
            ),
          ),
        ),
      ]);
    },
  );
}



