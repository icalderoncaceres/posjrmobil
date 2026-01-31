import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/barcode_generate_mobile_widget.dart';
import 'package:six_pos/features/product/widgets/product_info_widget.dart';
import 'package:six_pos/features/product/widgets/product_status_header_widget.dart';
import 'package:six_pos/features/product_setup/screens/add_product_screen.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Products? product;
  final int? index;
  final int tabInitialIndex;
  const ProductDetailsScreen({super.key, this.product, this.index, this.tabInitialIndex = 0});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController quantityController = TextEditingController();
  final ConfigModel? configModel = Get.find<SplashController>().configModel;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: widget.tabInitialIndex, vsync: this);

    quantityController.text = '10';
    Get.find<ProductController>().setBarCodeQuantity(10, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'product'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [

          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leadingWidth: 0,
            stretch: true,
            actions: [SizedBox()],
            actionsPadding: EdgeInsets.zero,
            titleSpacing: 0,
            title: ProductStatusHeaderWidget(
              product: widget.product, index: widget.index,
              onDeleteButtonTap: ()=> showDeleteProductDialog(context: context, product: widget.product, fromDetails: true),
              onEditButtonTap: ()=> Get.to(()=> AddProductScreen(product: widget.product, supplierId: widget.product?.supplier?.id, index: widget.index, fromDetailPage: true)),
            ),
            titleTextStyle: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                width: double.maxFinite,
                color: Colors.transparent,
                child: TabBar(
                  splashFactory: NoSplash.splashFactory,
                  padding: EdgeInsets.zero,
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  labelPadding: EdgeInsets.zero,
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
                    Tab(text: 'product_info'.tr),
                    Tab(text: 'generate_barcode'.tr),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
            controller: _tabController,
            children: [
              ProductInfoWidget(product: widget.product),


              BarcodeGeneratorMobileWidget(product: widget.product, quantityController: quantityController, configModel: configModel)
            ],
        ),
      ),
    );
  }
}

