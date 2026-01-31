
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_card_widget.dart';
import 'package:six_pos/util/dimensions.dart';


class ProductListWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String searchName;
  final int? supplierId;
  const ProductListWidget({Key? key, required this.scrollController, required this.searchName, this.supplierId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return productController.productModel?.products == null ?
        CustomShimmerWidget(child: ProductCardViewWidget(product: Products(id: 0, image: 'fake_url', title: 'fake_title', sellingPrice: 0))) :
        (productController.productModel?.products?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async {
            if(searchName.isNotEmpty) {
              await productController.getSearchProductList(searchName, offset ?? 1);

            }else{
              if(supplierId != null) {
                await productController.getSupplierProductList(offset ?? 1, supplierId);

              }else{
                await productController.getProductList(offset ?? 1);

              }
            }
          },
          offset: productController.productModel?.offset,
          limit: productController.productModel?.limit,
          totalSize: productController.productModel?.totalSize,
          itemView: ListView.separated(
            itemCount: productController.productModel?.products?.length ?? 0,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index)=> ProductCardViewWidget(
              product: productController.productModel?.products?[index],
              index: index,
            ),
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeSmall),
          ),
        ) : const NoDataWidget();

      },
    );
  }
}
