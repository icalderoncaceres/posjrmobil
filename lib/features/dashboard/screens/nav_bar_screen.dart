import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/enums/menu_tab_enum.dart';
import 'package:six_pos/common/widgets/custom_floating_action_button_location.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/dashboard/widgets/bottom_item_widget.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/util/styles.dart';


class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();
  bool _isExit = false;

  void _loadData(){
    Get.find<CategoryController>().getCategoryList(1, isUpdate: false);
    Get.find<ProfileController>().getProfileData();
    Get.find<CustomerController>().getCustomerList(1, isUpdate: false);
    Get.find<TransactionController>().getTransactionAccountList(1);
    Get.find<ProductController>().getLimitedStockProductList(1, isUpdate: false);
    Get.find<AccountController>().getRevenueDataForChart();
    Get.find<ProfileController>().getDashboardRevenueData('overall');
    Get.find<AccountController>().getAccountList(1, isUpdate: false);
    Get.find<CounterController>().getCounterList(isUpdate: false);
    Get.find<CartController>().getCartData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return PopScope(
      canPop: _isExit,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) return;
        _onWillPop(context);
      },
      child: GetBuilder<BottomManuController>(builder: (menuController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return Scaffold(
            onEndDrawerChanged: (bool status) {
              setState(() {
                _isExit = status;
              });
            },

            resizeToAvoidBottomInset: false,
            appBar:  const CustomAppBarWidget(isBackButtonExist: false),
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            endDrawer: const CustomDrawerWidget(),
            body: PageStorage(bucket: bucket, child: menuController.screen[menuController.currentTabIndex]),

            floatingActionButton: (profileController.modulePermission?.pos ?? false) ?
            Column(mainAxisSize: MainAxisSize.min, children: [

              FloatingActionButton(
                isExtended: true,
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                onPressed: ()=> cartController.scanProductBarCode(),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Image.asset(Images.scanner, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('scan_product'.tr, style: ubuntuRegular.copyWith(
                fontSize: Dimensions.navbarFontSize, fontWeight: FontWeight.w400,
              )),

            ]) : null,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
            floatingActionButtonLocation: CustomFloatingActionButtonLocation(),

            bottomNavigationBar: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                Expanded(flex: 2,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    BottomItemWidget(
                      tap: (){
                        menuController.onChangeMenu(type: NavbarType.dashboard);
                        profileController.setSelectedMenuScreen(menuScreen: MenuTabType.dashboard.name, isUpdate: true);
                      },
                      icon: menuController.currentTabIndex == 0 ? Images.dashboard : Images.dashboard,
                      name: 'dashboard'.tr,
                      selectIndex: 0,
                    ),

                    BottomItemWidget(
                      tap: profileController.profileModel == null ? null : (){
                        if(profileController.modulePermission?.pos ?? false) {
                          menuController.onChangeMenu(type: NavbarType.pos);
                          profileController.setSelectedMenuScreen(menuScreen: MenuTabType.pos_section.name, isUpdate: true);
                        }else {
                          showCustomSnackBarHelper('you_do_not_have_permission'.tr);
                        }
                      },
                      icon: menuController.currentTabIndex == 1 ? Images.pos : Images.pos, name: 'pos'.tr,
                      selectIndex: 1,
                    ),

                  ]),
                ),

                Expanded(child: Container()),

                Expanded(flex: 2,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    BottomItemWidget(
                      tap: profileController.profileModel == null ? null : (){
                        if(profileController.modulePermission?.pos ?? false) {
                          profileController.setSelectedMenuScreen(menuScreen: MenuTabType.pos_section.name, isUpdate: true);
                          menuController.onChangeMenu(type: NavbarType.items);
                        }else {
                          showCustomSnackBarHelper('you_do_not_have_permission'.tr);
                        }
                      },
                      icon: menuController.currentTabIndex == 2 ? Images.item : Images.item, name: 'items'.tr,
                      selectIndex: 2,
                    ),

                    BottomItemWidget(
                      tap: profileController.profileModel == null ? null : (){
                        if(profileController.modulePermission?.limitedStock ?? false) {
                          menuController.onChangeMenu(type: NavbarType.limitedStock);
                          profileController.setSelectedMenuScreen(menuScreen: MenuTabType.dashboard.name, isUpdate: true);
                        }else {
                          showCustomSnackBarHelper('you_do_not_have_permission'.tr);
                        }
                      },
                      icon: menuController.currentTabIndex == 3 ? Images.stock : Images.stock, name: 'limited_stock'.tr,
                      selectIndex: 3,
                    ),


                  ]),
                ),


              ]),
            ),
          );
        });
      }),
    );
  }

  void _onWillPop(BuildContext context) async {
    if(!_isExit) {
      showAnimatedDialogHelper(context,
        CustomDialogWidget(
          icon: Icons.exit_to_app_rounded, title: 'exit'.tr,
          description: 'do_you_want_to_exit_the_app'.tr,
          onTapFalse:() => Navigator.of(context).pop(false),
          onTapTrue:() {
            SystemNavigator.pop();
          },
          onTapTrueText: 'yes'.tr, onTapFalseText: 'no'.tr,
        ),
        dismissible: false,
        isFlip: true,
      );
    }
  }

}





