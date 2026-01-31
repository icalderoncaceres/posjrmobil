
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/brand/widgets/brand_card_widget.dart';
import 'package:six_pos/util/dimensions.dart';

class BrandListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const BrandListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<BrandController>(builder: (brandController) {
      return brandController.brandModel == null ? CustomShimmerWidget(child: BrandCardWidget(brand: Brands(id: 0, name: 'fake_name'))) :
      (brandController.brandModel?.brandList?.isNotEmpty ?? false) ? PaginatedListWidget(
        scrollController: scrollController,
        onPaginate: (int? offset) async => await brandController.getBrandList(
            offset ?? 1,
            startDate: Get.find<FilterController>().startDate.toString(),
            endDate: Get.find<FilterController>().endDate.toString(),
            sortingType: Get.find<FilterController>().selectedSortingType,
            searchText: brandController.searchText
        ),
        totalSize: brandController.brandModel?.totalSize,
        offset: brandController.brandModel?.offset,
        itemView: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: brandController.brandModel?.brandList?.length ?? 0,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (ctx,index){
            return BrandCardWidget(brand: brandController.brandModel?.brandList?[index], index: index);
            },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeSmall),
        ),
      ) :
      Column(children: [
        SizedBox(height: Get.height * 0.2),

        const NoDataWidget(),
      ]);
    });
  }
}


