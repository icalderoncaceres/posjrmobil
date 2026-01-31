import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';


class CustomerSearchDialogWidget extends StatelessWidget {
  final OverlayPortalController? overlayPortalController;
  const CustomerSearchDialogWidget({Key? key, this.overlayPortalController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.25;
    return GetBuilder<CartController>(builder: (searchCustomer){
      return searchCustomer.searchedCustomerList != null && searchCustomer.searchedCustomerList!.isNotEmpty?
      Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraLarge),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha:0.1),
                spreadRadius: .5,
                blurRadius: 12,
                offset: const Offset(3,5),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: searchCustomer.searchedCustomerList!.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
                return GetBuilder<CartController>(
                  builder: (cart) {
                    return InkWell(
                      onTap: () {
                        if(searchCustomer.customerCartList.isNotEmpty &&  searchCustomer.searchedCustomerList![index].id != 0 && searchCustomer.isUserExists(searchCustomer.searchedCustomerList![index].id!)) {
                          showCustomSnackBarHelper('customer_already_exists'.tr, isError: true);
                        } else {
                          searchCustomer.setCustomerInfo(
                            id: searchCustomer.searchedCustomerList![index].id,
                            name: searchCustomer.searchedCustomerList![index].name,
                            phone: searchCustomer.searchedCustomerList![index].mobile,
                            customerBalance: searchCustomer.searchedCustomerList![index].balance,
                          );
                          searchCustomer.searchCustomerController.text = searchCustomer.searchedCustomerList![index].name!;
                          cart.customerWalletController.text = searchCustomer.searchedCustomerList![index].balance.toString();
                          // Get.find<TransactionController>().addCustomerBalanceIntoAccountList(Accounts(id: 0, account: 'customer balance'));
                          Get.find<TransactionController>().getAccountListWithWallet();
                          //cart.setSearchCustomerList(null);
                          overlayPortalController?.hide();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${searchCustomer.searchedCustomerList![index].name}', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              const SizedBox(height: Dimensions.paddingSizeMediumBorder,),
                              CustomDividerWidget(height: .5,color: Theme.of(context).hintColor),
                            ],
                          )),
                    );
                  }
                );

              },),
        ),
      ):const SizedBox.shrink();
    });
  }
}
