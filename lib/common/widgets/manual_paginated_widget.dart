import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class ManualPaginatedWidget extends StatelessWidget {
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final int? itemListSize;
  final Widget itemView;
  const ManualPaginatedWidget({
    super.key, required this.totalSize, required this.offset,
    required this.itemView, required this.onPaginate, this.limit = 10,
    required this.itemListSize
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      itemView,
      const SizedBox(height: Dimensions.paddingSizeSmall),

      if(_calculateSeeMoreItem() > 0)
      Center(child: InkWell(
        onTap: (){
          onPaginate((offset ?? 0) + 1);
        },
        child: Text('${'see_more'.tr} (${_calculateSeeMoreItem()})', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault, decoration: TextDecoration.underline)),
      )),
    ]);
  }

  int _calculateSeeMoreItem(){
    if((offset ?? 0) == 1 && (totalSize ?? 0) > 6){
      return (totalSize ?? 0) - 6;
    }else if((offset ?? 0) == 1 && (totalSize ?? 0) <= 6){
      return 0;
    }else{
      return (totalSize ?? 0) - (itemListSize ?? 0);
    }
  }
}
