import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_details_widget.dart';
import 'package:six_pos/features/product/widgets/barcode_generate_reset_button_widget.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeGeneratorTabWidget extends StatelessWidget {
  final Products? product;
  final TextEditingController quantityController;
  final ConfigModel? configModel;
  final bool isShowProductDetails;
  const BarcodeGeneratorTabWidget({super.key, this.product, required this.quantityController, required this.configModel, this.isShowProductDetails = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (productController) {
          return CustomScrollView(slivers: [

            SliverToBoxAdapter(child: IntrinsicHeight(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ///Product details card
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeMediumBorder),
                  child: ProductDetailsWidget(product: product, isShowDescription: false),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                ///Generate barcode section
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeMediumBorder),
                  child: BarcodeGenerateResetButtonWidget(quantityController: quantityController),
                )),
              
              ]),
            )),

            const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeSmall)),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).primaryColor.withValues(alpha: .05))]
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(
                    child: Text(
                      'a4_size_paper'.tr,
                      style: ubuntuMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),

                  Flexible(child: CustomButtonWidget(
                    buttonText: 'download'.tr,
                    onPressed: () async {
                      _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.barCodeDownload}?id=${product!.id}&quantity=${int.parse(quantityController.text)}'));
                      },
                    buttonColor: Theme.of(context).primaryColor,
                  )),
                ]),
              ),
            ),

            // Barcode Grid Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeSmall,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).primaryColor.withValues(alpha: .05),
                          ),
                        ],
                      ),
                      child: DottedBorder(
                        color: Theme.of(context).hintColor.withValues(alpha: .8),
                        strokeWidth: 1,
                        dashPattern: const [3, 3],
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text(
                            configModel?.businessInfo?.shopName ?? '',
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).hintColor,
                            ),
                          ),

                          Column(children: [
                            Text(
                              product?.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                            Text(
                              PriceConverterHelper.symbolWithPrice(
                                product?.sellingPrice ?? 0,
                              ),
                              style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                          ]),

                          BarcodeWidget(
                            data: 'code : ${product?.productCode ?? ''}',
                            style: ubuntuRegular.copyWith(),
                            barcode: Barcode.code128(),
                          ),
                        ]),
                      ),
                    );
                  },
                  childCount: productController.barCodeQuantity,
                ),
              ),
            ),
          ]);
        }
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
