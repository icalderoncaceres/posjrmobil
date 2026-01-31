import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product_setup/widgets/product_availability_info_widget.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/currency/controllers/currency_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/features/product_setup/widgets/product_general_info_widget.dart';
import 'package:six_pos/features/product_setup/widgets/product_price_info_widget.dart';

class AddProductScreen extends StatefulWidget {
  final bool fromDetailPage;
  final Products? product;
  final int? supplierId;
  final int? index;
  const AddProductScreen({
    Key? key,
    this.product,
    this.supplierId,
    this.index,
    this.fromDetailPage = false,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;
  late bool update;

  Future<void> _loadData() async {
    Get.find<CategoryController>().getCategoryList(
      1,
      product: widget.product,
      isUpdate: false,
      limit: 100,
    );
    Get.find<BrandController>().getBrandList(
      1,
      product: widget.product,
      isUpdate: false,
      limit: 100,
    );
    Get.find<UnitController>().getUnitList(
      1,
      product: widget.product,
      limit: 100,
    );
    Get.find<SupplierController>().getSupplierList(
      1,
      product: widget.product,
      isUpdate: false,
      limit: 100,
    );
    // Cargar la lista de monedas
    Get.find<CurrencyController>().getCurrencyList();
  }

  void _initialData(ProductController productController, bool update) {
    if (update) {
      productController.productSellingPriceController.text = widget
          .product!
          .sellingPrice
          .toString();
      productController.productPurchasePriceController.text = widget
          .product!
          .purchasePrice
          .toString();
      productController.productTaxController.text = widget.product!.tax
          .toString();
      productController.productDiscountController.text = widget
          .product!
          .discount
          .toString();
      productController.productSkuController.text =
          widget.product!.productCode!;
      productController.productStockController.text = widget.product!.quantity
          .toString();
      productController.productNameController.text = widget.product!.title!;
      productController.unitValueController.text = widget.product!.unitValue
          .toString();
      productController.setSelectedDiscountType(
        widget.product!.discountType,
        notify: false,
      );
      productController.setDiscountTypeIndex(
        widget.product!.discountType == 'percent' ? 0 : 1,
        false,
      );
      productController.updateEndTime(
        widget.product?.availableEndTime,
        isUpdate: false,
      );
      productController.updateStartTime(
        widget.product?.availableStartTime,
        isUpdate: false,
      );
      productController.productReorderController.text =
          (widget.product?.reorderLevel ?? '').toString();
      productController.productDescriptionController.text =
          widget.product?.description ?? '';
      Get.find<CategoryController>().setCategoryIndex(
        widget.product?.category?.id,
        false,
      );
      Get.find<CategoryController>().setSubCategoryIndex(
        widget.product?.subCategory?.id,
        false,
      );
      Get.find<BrandController>().onChangeBrandId(
        widget.product?.brand?.id,
        false,
      );
    } else {
      productController.productSellingPriceController.clear();
      productController.productPurchasePriceController.clear();
      productController.productTaxController.clear();
      productController.productDiscountController.clear();
      productController.productSkuController.clear();
      productController.productStockController.clear();
      productController.productNameController.clear();
      productController.unitValueController.clear();
      productController.updateEndTime(null, isUpdate: false);
      productController.updateStartTime(null, isUpdate: false);
      productController.productReorderController.clear();
      productController.productDescriptionController.clear();

      productController.setSelectedDiscountType('percent', notify: false);
      productController.setDiscountTypeIndex(0, false);

      Get.find<BrandController>().onChangeBrandId(null, true);
      Get.find<CategoryController>().setCategoryAndSubCategoryEmpty();
      Get.find<UnitController>().setUnitEmpty();
    }

    if (widget.supplierId != null) {
      Get.find<SupplierController>().setSupplierIndex(widget.supplierId, false);
    }
  }

  @override
  void initState() {
    super.initState();

    final productController = Get.find<ProductController>();

    productController.pickImage(true, isUpdate: false);

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    _tabController?.addListener(() {
      if (_tabController != null && !_tabController!.indexIsChanging) {
        productController.setIndexForTabBar(_tabController!.index);
      }
    });

    update = widget.product != null;
    productController.setIndexForTabBar(0, isUpdate: false);
    _loadData();

    if (update) {
      productController.setOldProductImage(widget.product?.image);
    }
    _initialData(productController, update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      endDrawer: const CustomDrawerWidget(),
      appBar: CustomAppBarWidget(
        title: update ? 'edit_product'.tr : 'product'.tr,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
            ),
            width: double.maxFinite,
            color: context.customThemeColors.screenBackgroundColor,
            child: TabBar(
              padding: EdgeInsets.zero,
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
              dividerHeight: 2,
              unselectedLabelStyle: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: context.customThemeColors.textOpacityColor,
              ),
              labelStyle: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: 'general_info'.tr),
                Tab(text: 'price_info'.tr),
                Tab(text: 'availability'.tr),
              ],
            ),
          ),
          SizedBox(height: Dimensions.paddingSizeLarge),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProductGeneralInfoWidget(
                  product: widget.product,
                  index: widget.index,
                ),

                const ProductPriceInfoWidget(),

                ProductAvailabilityInfoWidget(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: GetBuilder<ProductController>(
        builder: (productController) {
          return Container(
            height: 70,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: context.customThemeColors.screenBackgroundColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    buttonColor: Theme.of(
                      context,
                    ).hintColor.withValues(alpha: 0.3),
                    isClear: true,
                    isButtonTextBold: true,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    buttonText: 'reset'.tr,
                    onPressed: () {
                      _initialData(productController, update);
                      if (update) {
                        productController.pickOldImage(false, widget.index!);
                      } else {
                        productController.pickImage(true);
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                GetBuilder<CategoryController>(
                  builder: (categoryController) {
                    return Expanded(
                      child: CustomButtonWidget(
                        isLoading: productController.isLoading,
                        isButtonTextBold: true,
                        buttonText: productController.selectionTabIndex != 2
                            ? 'next'.tr
                            : update
                            ? 'update'.tr
                            : 'submit'.tr,
                        onPressed: () {
                          if (productController.selectionTabIndex != 2) {
                            _tabController!.animateTo(
                              (_tabController!.index + 1),
                            );
                          } else {
                            String productName = productController
                                .productNameController
                                .text
                                .trim();
                            String description = productController
                                .productDescriptionController
                                .text
                                .trim();
                            String productCode = productController
                                .productSkuController
                                .text
                                .trim();
                            int? brandId =
                                Get.find<BrandController>().selectedBrandId;
                            int productQuantity = 0;

                            if (productController.productStockController.text
                                .trim()
                                .isNotEmpty) {
                              productQuantity = int.parse(
                                productController.productStockController.text
                                    .trim(),
                              );
                            }
                            String reorderLevel = productController
                                .productReorderController
                                .text
                                .trim();
                            String unitId = Get.find<UnitController>().unitIndex
                                .toString();
                            String unitValue = productController
                                .unitValueController
                                .text
                                .trim();
                            int? categoryId =
                                categoryController.selectedCategoryId;
                            String subCategoryId = categoryController
                                .selectedSubCategoryId
                                .toString();
                            String sellingPrice = productController
                                .productSellingPriceController
                                .text
                                .trim();
                            String purchasePrice = productController
                                .productPurchasePriceController
                                .text
                                .trim();
                            String discount = productController
                                .productDiscountController
                                .text
                                .trim();
                            String? selectedDiscountType =
                                productController.selectedDiscountType;
                            String tax = productController
                                .productTaxController
                                .text
                                .trim();
                            int? supplierId = Get.find<SupplierController>()
                                .selectedSupplierId;
                            String? availableTimeStart =
                                productController.startTime;
                            String? availableTimeEnd =
                                productController.endTime;
                            if (productName.isEmpty) {
                              showCustomSnackBarHelper(
                                'product_name_required'.tr,
                              );
                            } else if (productCode.isEmpty) {
                              showCustomSnackBarHelper('sku_required'.tr);
                            } else if (productQuantity < 1) {
                              showCustomSnackBarHelper(
                                'stock_quantity_required'.tr,
                              );
                            } else if (unitValue.isEmpty) {
                              showCustomSnackBarHelper(
                                'unit_value_required'.tr,
                              );
                            } else if (categoryId == null) {
                              showCustomSnackBarHelper(
                                'please_select_a_category'.tr,
                              );
                            } else if (sellingPrice.isEmpty) {
                              showCustomSnackBarHelper(
                                'selling_price_required'.tr,
                              );
                            } else if (purchasePrice.isEmpty) {
                              showCustomSnackBarHelper(
                                'purchase_price_required'.tr,
                              );
                            } else if (Get.find<UnitController>().unitIndex ==
                                0) {
                              showCustomSnackBarHelper('please_select_unit'.tr);
                            } else if ((availableTimeEnd != null &&
                                    availableTimeStart == null) ||
                                (availableTimeEnd == null &&
                                    availableTimeStart != null)) {
                              showCustomSnackBarHelper(
                                'if_add_start_or_end_time'.tr,
                              );
                            } else {
                              Products product = Products(
                                id: update ? widget.product!.id : null,
                                title: productName,
                                sellingPrice: double.parse(sellingPrice),
                                purchasePrice: double.parse(purchasePrice),
                                tax: double.parse(tax),
                                discount: double.parse(discount),
                                discountType: selectedDiscountType,
                                unitType: Units(id: int.tryParse(unitId)),
                                productCode: productCode,
                                quantity: productQuantity,
                                unitValue: unitValue,
                                description: description,
                                reorderLevel: int.parse(reorderLevel),
                                availableEndTime:
                                    DateConverterHelper.convertAmPmTo24Hour(
                                      availableTimeEnd,
                                    ),
                                availableStartTime:
                                    DateConverterHelper.convertAmPmTo24Hour(
                                      availableTimeStart,
                                    ),
                              );
                              productController.addProduct(
                                product,
                                '${categoryId}',
                                subCategoryId,
                                brandId,
                                supplierId,
                                update,
                                widget.index,
                                fromDetailPage: widget.fromDetailPage,
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
