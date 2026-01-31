
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/features/unit/widgets/unit_card_widget.dart';
import 'package:six_pos/util/dimensions.dart';

class UnitListWidget extends StatelessWidget {
  final ScrollController? scrollController;
  const UnitListWidget({Key? key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Get.find<UnitController>().unitList != null && Get.find<UnitController>().unitList!.isNotEmpty
          && !Get.find<UnitController>().isLoading) {
        int? pageSize;
        pageSize = Get.find<UnitController>().unitListLength;

        if(offset < pageSize!) {
          offset++;
          Get.find<UnitController>().showBottomLoader();
          Get.find<UnitController>().getUnitList(offset);
        }
      }

    });

    return GetBuilder<UnitController>(builder: (unitController) {

      return Column(children: [
        unitController.unitList == null ?
        CustomShimmerWidget(child: UnitCardWidget(unit: Units(id: 1, createdAt: 'fake_date', unitType: 'fake_type', updatedAt: 'fake_date'))) :
        unitController.unitList!.isEmpty ?
        Column(children: [
          SizedBox(height: Get.height * 0.2),

          const NoDataWidget(),
        ]) :
        ListView.separated(
            shrinkWrap: true,
            itemCount: unitController.unitList!.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return UnitCardWidget(unit: unitController.unitList![index], index: index);
              },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeSmall)),

        ]);
    });
  }
}
