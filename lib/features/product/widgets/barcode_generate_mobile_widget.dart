import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_details_widget.dart';
import 'package:six_pos/features/product/widgets/barcode_generate_reset_button_widget.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeGeneratorMobileWidget extends StatelessWidget {
  final product;
  final TextEditingController quantityController;
  final ConfigModel? configModel;
  final bool isShowProductDetails;
  const BarcodeGeneratorMobileWidget({super.key, this.product, required this.quantityController, required this.configModel, this.isShowProductDetails = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return CustomScrollView(slivers: [

        SliverToBoxAdapter(child: Container(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.02),
          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Column(children: [
            SizedBox(height: Dimensions.paddingSizeLarge),

            ///Generate barcode section
            BarcodeGenerateResetButtonWidget(quantityController: quantityController),
            const SizedBox(height: Dimensions.paddingSizeSmall),

          ]),
        )),

        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeDefault ,bottom: Dimensions.paddingSizeSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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

              Flexible(
                child: CustomButtonWidget(
                  buttonText: 'download'.tr,
                  onPressed: () async {
                    DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.barCodeDownload}?id=${product!.id}&quantity=${int.parse(quantityController.text)}'));
                  },
                  buttonColor: Theme.of(context).primaryColor,
                ),
              ),
            ]),
          ),
        ),

        // Barcode Grid Section
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          sliver: DecoratedSliver(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      blurRadius: 3
                  )
                ]
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _isLandscape(context) ? 3 : 2,
                  mainAxisSpacing: Dimensions.paddingSizeDefault,
                  crossAxisSpacing: Dimensions.paddingSizeDefault,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    color: Theme.of(context).cardColor,
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
                            color: context.customThemeColors.textColor.withValues(alpha: 0.8),
                          ),
                        ),

                        Column(children: [

                          Text(
                            product?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: context.customThemeColors.textColor.withValues(alpha: 0.9)
                            ),
                          ),

                          Text(
                            PriceConverterHelper.symbolWithPrice(
                              product?.sellingPrice ?? 0,
                            ),
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: context.customThemeColors.textColor.withValues(alpha: 0.9)
                            ),
                          ),

                        ]),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: BarcodeWidget(
                            data: '${'code'.tr} : ${product?.productCode ?? ''}',
                            style: ubuntuRegular,
                            barcode: Barcode.code128(),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                  childCount: productController.barCodeQuantity,
                ),
              ),
            ),
          ),
        ),
      ]);
    }
    );
  }
}

bool _isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}
