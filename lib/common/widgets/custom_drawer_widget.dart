import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/enums/menu_tab_enum.dart';
import 'package:six_pos/features/counter/screens/counter_list_screen.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/employe_role/screens/employee_management_screen.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/sign_out_dialog_widget.dart';
import 'package:six_pos/features/account_management/screens/account_mangement_screen.dart';
import 'package:six_pos/features/dashboard/screens/nav_bar_screen.dart';
import 'package:six_pos/features/langulage/screens/change_language_screen.dart';
import 'package:six_pos/features/product_setup/screens/product_setup_menu_screen.dart';
import 'package:six_pos/features/order/screens/order_screen.dart';
import 'package:six_pos/features/shop/screens/shop_setting_screen.dart';
import 'package:six_pos/features/user/screens/option_list_screen.dart';

import '../../helper/animated_custom_dialog_helper.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomManuController manuController = Get.find<BottomManuController>();
    final SplashController splashController = Get.find<SplashController>();

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Theme.of(context).cardColor,
      child: GetBuilder<ProfileController>(
        builder: (profileController) {

          bool isShowProduct = (profileController.modulePermission?.product ?? false)
              || (profileController.modulePermission?.coupon ?? false)
              || (profileController.modulePermission?.brand ?? false)
              || (profileController.modulePermission?.category ?? false)
              || (profileController.modulePermission?.unit ?? false);

          return Column(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              height: 200,
              child: Column(children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top),

                SizedBox(width: 80,height: 80, child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: FadeInImage.assetNetwork(
                      placeholder:  Images.placeholder,
                      height: 80, width: 80, fit: BoxFit.cover,
                      image: '${splashController.baseUrls?.adminImageUrl}/${profileController.profileModel?.image ?? ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                        height: 80, width: 80, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),),

                Text('${profileController.profileModel?.fName} ${profileController.profileModel?.lName}',
                  style: ubuntuRegular.copyWith(
                  color: Theme.of(context).cardColor,
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),),

                Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('${profileController.profileModel?.email}', style: ubuntuRegular.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.fontSizeSmall,
                  ),),
                ),
              ]),
            ),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
               CustomCategoryButtonWidget(
                 icon: Images.dashboard,
                 buttonText: 'dashboard'.tr,
                 isSelected: profileController.selectedMenuScreen == MenuTabType.dashboard.name,
                 onTap: (){
                   Get.back();
                   profileController.setSelectedMenuScreen(menuScreen: MenuTabType.dashboard.name, isUpdate: true);
                   Get.to(()=> const NavBarScreen());
                   manuController.onChangeMenu(type: NavbarType.dashboard);
                 },
               ),

                if(profileController.modulePermission?.pos ?? false) CustomCategoryButtonWidget(
                  icon: Images.pos,
                  buttonText: 'pos_section'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.pos_section.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.pos_section.name, isUpdate: true);
                    Get.to(()=> const NavBarScreen());
                    manuController.onChangeMenu(type: NavbarType.pos);
                  },
                ),


                if(isShowProduct)  CustomCategoryButtonWidget(
                  icon: Images.productSetup,
                  buttonText: 'product_setup'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.product_setup.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.product_setup.name, isUpdate: true);
                    Get.to(()=> const ProductSetupMenuScreen(isFromDrawer: true));
                  },
                  showDivider: true,
                ),

                if(profileController.modulePermission?.pos ?? false) CustomCategoryButtonWidget(
                  icon: Images.item,
                  buttonText: 'orders'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.orders.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.orders.name, isUpdate: true);
                    Get.to(()=> const OrderScreen(fromNavBar: false));
                  },
                  showDivider: true,
                ),

                if(profileController.modulePermission?.counter ?? false) CustomCategoryButtonWidget(
                  icon: Images.counterSvg,
                  buttonText: 'counter_setup'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.counter_setup.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.counter_setup.name, isUpdate: true);
                    Get.to(()=> const CounterListScreen());
                  },
                  showDivider: true,
                ),



                if(profileController.modulePermission?.account ?? false)CustomCategoryButtonWidget(
                  icon: Images.accountManagement,
                  buttonText: 'accounts_management'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.accounts_management.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.accounts_management.name, isUpdate: true);
                    Get.to(()=> const AccountManagementScreen());
                  },
                  showDivider: true,
                ),

                if((profileController.modulePermission?.customer ?? false) || (profileController.modulePermission?.supplier ?? false))
                  CustomCategoryButtonWidget(
                    icon: Images.profilePlaceHolder,
                    buttonText: 'users'.tr,
                    isSelected: profileController.selectedMenuScreen == MenuTabType.users.name,
                    onTap: (){
                      Get.back();
                      profileController.setSelectedMenuScreen(menuScreen: MenuTabType.users.name, isUpdate: true);
                      Get.to(()=> const OptionListScreen());
                    },
                    showDivider: true,
                  ),

                if(profileController.modulePermission?.setting ?? false) CustomCategoryButtonWidget(
                  icon: Images.shopIcon,
                  buttonText: 'shop_settings'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.shop_settings.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.shop_settings.name, isUpdate: true);
                    Get.to(()=> const ShopSettingScreen());
                  },
                  showDivider: true,
                ),

               if(profileController.modulePermission?.employee ?? false) CustomCategoryButtonWidget(
                  icon: Images.employeeRole,
                  buttonText: 'employee_section'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.employee_section.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.employee_section.name, isUpdate: true);
                    Get.to(()=> const EmployeeManagementScreen());
                  },
                 showDivider: true,
               ),

                CustomCategoryButtonWidget(
                  icon: Images.languageLogo,
                  buttonText: 'change_language'.tr,
                  isSelected: profileController.selectedMenuScreen == MenuTabType.change_language.name,
                  onTap: (){
                    Get.back();
                    profileController.setSelectedMenuScreen(menuScreen: MenuTabType.change_language.name, isUpdate: true);
                    Get.to(()=> const ChooseLanguageScreen());
                  },
                  showDivider: true,
                ),

                CustomCategoryButtonWidget(
                  icon: Images.logout,
                  buttonText: 'log_out'.tr,
                  isSelected: profileController.selectedMenuScreen == 'log_out',
                  onTap: (){
                    showAnimatedDialogHelper(context, const SignOutDialogWidget(), isFlip: true);
                  },
                  showDivider: true,
                ),

              ]),
            ),
          ]);
        }
      ),
    );
  }
}
