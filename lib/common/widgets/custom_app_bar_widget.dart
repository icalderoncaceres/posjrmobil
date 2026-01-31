import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/enums/menu_tab_enum.dart';
import 'package:six_pos/common/enums/routes_name_enum.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/hold_orders/widget/hold_orders_bottom_sheet_widget.dart';
import 'package:six_pos/features/langulage/controllers/localization_controller.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_on_tap_widget.dart';
import 'package:six_pos/features/dashboard/screens/nav_bar_screen.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  const CustomAppBarWidget({
    Key? key,
    this.isBackButtonExist = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomManuController menuController =
        Get.find<BottomManuController>();
    final ProfileController profileController = Get.find<ProfileController>();

    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return AppBar(
          backgroundColor: Theme.of(context).cardColor,
          titleSpacing: 0,
          elevation: 3,
          leadingWidth: isBackButtonExist ? 50 : 120,
          leading: isBackButtonExist
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: CustomOnTapWidget(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      size: Dimensions.paddingSizeLarge,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: localizationController.isLtr
                        ? Dimensions.paddingSizeExtraSmall
                        : 0.0,
                    right: !localizationController.isLtr
                        ? Dimensions.paddingSizeDefault
                        : 0.0,
                  ),
                  child: InkWell(
                    onTap: () =>
                        menuController.onChangeMenu(type: NavbarType.dashboard),
                    child: Text(
                      'Abasto Melani',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
          title: Text(
            title ?? '',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          actions: [
            GetBuilder<ProfileController>(
              builder: (profileController) {
                return (profileController.modulePermission?.pos ?? false)
                    ? GetBuilder<CartController>(
                        builder: (cartController) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: IconButton(
                              onPressed: () {
                                if (cartController.customerCartList.length >
                                    0) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    constraints: BoxConstraints(
                                      maxHeight: Get.height * 0.9,
                                      maxWidth: double.infinity,
                                    ),
                                    builder: (ctx) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(
                                            ctx,
                                          ).viewInsets.bottom,
                                        ), // Adjusts for keyboard
                                        child:
                                            const HoldOrdersBottomSheetWidget(),
                                      );
                                    },
                                  );
                                } else {
                                  showCustomSnackBarHelper(
                                    'you_have_no_hold_order'.tr,
                                  );
                                }
                              },
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const CustomAssetImageWidget(
                                    Images.holdIcon,
                                    height: Dimensions.fontSizeOverOverLarge,
                                    width: Dimensions.fontSizeOverOverLarge,
                                  ),
                                  Positioned(
                                    top: -8,
                                    right: -15,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).secondaryHeaderColor,
                                      child: Text(
                                        '${cartController.customerCartList.length}',
                                        style: ubuntuRegular.copyWith(
                                          color: Theme.of(context).cardColor,
                                          fontSize: Dimensions.fontSizeLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
            ),

            GetBuilder<ProfileController>(
              builder: (profileController) {
                return (profileController.modulePermission?.pos ?? false)
                    ? GetBuilder<CartController>(
                        builder: (cartController) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: IconButton(
                              onPressed: () {
                                menuController.onChangeMenu(
                                  type: NavbarType.pos,
                                  isUpdate: true,
                                );

                                Get.to(const NavBarScreen());
                              },
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CustomAssetImageWidget(
                                    Images.cart,
                                    height: Dimensions.iconSizeDefault,
                                    width: Dimensions.iconSizeDefault,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Positioned(
                                    top: -8,
                                    right: -15,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).secondaryHeaderColor,
                                      child: Text(
                                        '${cartController.currentCartModel?.cart?.length ?? 0}',
                                        style: ubuntuRegular.copyWith(
                                          color: Theme.of(context).cardColor,
                                          fontSize: Dimensions.fontSizeLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox();
              },
            ),

            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    if (_isOnNavBarScreen()) {
                      if (menuController.currentTabIndex == 0) {
                        profileController.setSelectedMenuScreen(
                          menuScreen: MenuTabType.dashboard.name,
                          isUpdate: true,
                        );
                      } else if ((menuController.currentTabIndex == 1 ||
                          menuController.currentTabIndex == 2)) {
                        profileController.setSelectedMenuScreen(
                          menuScreen: MenuTabType.pos_section.name,
                          isUpdate: true,
                        );
                      }
                    } else {
                      _onUpdateMenu(profileController);
                    }

                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool _isOnNavBarScreen() => Get.currentRoute == '/NavBarScreen';

  _onUpdateMenu(ProfileController profileController) {
    if (Get.currentRoute == RoutesName.ProductSetupMenuScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.product_setup.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute == RoutesName.OrderScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.orders.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute == RoutesName.CounterListScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.counter_setup.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute ==
        RoutesName.AccountManagementScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.accounts_management.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute == RoutesName.OptionListScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.users.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute == RoutesName.ShopSettingScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.shop_settings.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute ==
        RoutesName.EmployeeManagementScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.employee_section.name,
        isUpdate: true,
      );
    } else if (Get.currentRoute == RoutesName.ChooseLanguageScreen.screenName) {
      profileController.setSelectedMenuScreen(
        menuScreen: MenuTabType.change_language.name,
        isUpdate: true,
      );
    }
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 50);
}
