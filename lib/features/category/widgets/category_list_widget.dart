
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/dimensions.dart';

import 'category_card_widget.dart';
class CategoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CategoryListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GetBuilder<CategoryController>(builder: (categoryController) {
      return categoryController.categoryModel == null ?
      CustomShimmerWidget(child: CategoryCardWidget(category: Categories(id: 0, name: 'fake_name', image: 'fake_image'))) :
      (categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false) ?
      PaginatedListWidget(
        scrollController: scrollController,
        onPaginate: (int? offset) async => await categoryController.getCategoryList(
            offset ?? 1,
            startDate: Get.find<FilterController>().startDate.toString(),
            endDate: Get.find<FilterController>().endDate.toString(),
            sortingType: Get.find<FilterController>().selectedSortingType,
            searchText: categoryController.categorySearchText
        ),
        totalSize: categoryController.categoryModel?.totalSize,
        offset: categoryController.categoryModel?.offset,
        itemView: ListView.separated(
          shrinkWrap: true,
          itemCount: categoryController.categoryModel?.categoriesList?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (ctx,index){
            return CategoryCardWidget(
              category: categoryController.categoryModel?.categoriesList?[index],
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index)=> SizedBox(height: Dimensions.fontSizeSmall),
        ),
      ) :
      Column(children: [
        SizedBox(height: Get.height * 0.2),

        const NoDataWidget(),
      ]);

    });
  }
}
