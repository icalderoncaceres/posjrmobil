import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/category/widgets/sub_category_card_widget.dart';
import 'package:six_pos/util/dimensions.dart';
class SubCategoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const SubCategoryListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(builder: (categoryController) {
        return categoryController.subCategoryModel == null ?
        CustomShimmerWidget(child: SubCategoryCardWidget(subCategory: SubCategories(id: 0, name: 'fake_name'))) :
        (categoryController.subCategoryModel?.subCategoriesList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) => categoryController.getSubCategoryList(
            offset ?? 1, categoryController.selectedCategoryId,
              startDate: Get.find<FilterController>().startDate.toString(),
              endDate: Get.find<FilterController>().endDate.toString(),
              sortingType: Get.find<FilterController>().selectedSortingType,
              searchText: categoryController.subCategorySearchText
          ),
          totalSize: categoryController.subCategoryModel?.subCategoriesList?.length,
          offset: categoryController.subCategoryModel?.offset,
          itemView: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: categoryController.subCategoryModel?.subCategoriesList?.length ?? 0,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return SubCategoryCardWidget(subCategory: categoryController.subCategoryModel?.subCategoriesList?[index], index: index);
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeSmall),
          ),
        ) :
        Column(children: [
          SizedBox(height: Get.height * 0.15),

          const NoDataWidget(),
        ]);
      },
    );
  }
  }

