import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/hold_orders/widget/hold_order_item_card_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';


class HoldOrderSearchBarWidget extends StatefulWidget {
  const HoldOrderSearchBarWidget({super.key});

  @override
  State<HoldOrderSearchBarWidget> createState() => _HoldOrderSearchBarWidgetState();
}

class _HoldOrderSearchBarWidgetState extends State<HoldOrderSearchBarWidget> {

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed((const Duration(milliseconds: 500))).then((_) {
    //  FocusScope.of(Get.context!).requestFocus(searchFocusNode);
    });
  }


  @override
  Widget build(BuildContext context) {
    return  GetBuilder<CartController>(
      builder: (cartController) {
        return SizedBox(height: 56,
          child: Padding(padding: const EdgeInsets.only(bottom: 8.0),
            child: Autocomplete<TemporaryCartListModel>(
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                searchController = controller;
                searchFocusNode = focusNode;


                return Material(child:
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).hintColor),
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Icon(Icons.search, size: 20)
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: CustomTextFieldWidget(
                            borderColor: Colors.transparent,
                            hintText: 'search_by_customer_name'.tr,
                            controller: searchController,
                            focusNode: searchFocusNode,
                            inputAction : TextInputAction.search,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                );
              },

              optionsBuilder: (TextEditingValue textEditingValue) async {

                if (textEditingValue.text.isEmpty) {
                  return const Iterable<TemporaryCartListModel>.empty();
                } else {
                  List<TemporaryCartListModel> cartList = cartController.customerCartList;
                  Iterable<TemporaryCartListModel> matchingProducts = cartList.where(
                     (product) => product.customerName!.toLowerCase().contains(textEditingValue.text.toLowerCase())
                  );
                  return  matchingProducts.isEmpty ? [TemporaryCartListModel(holdId : null)] :   matchingProducts;
                }
              },
              optionsViewOpenDirection: OptionsViewOpenDirection.down,

              optionsViewBuilder: (context, Function(TemporaryCartListModel) onSelected, options) {
                return Material(elevation: 0,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final cart = options.elementAt(index);

                      if(cart.holdId == null)
                        return Padding(
                          padding: EdgeInsets.only(right: Dimensions.radiusExtraLarge),
                          child: Container(
                            margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Column(mainAxisSize: MainAxisSize.min,children: [
                                Text('no_data_found'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                              ]),
                            ),
                          ),
                        );

                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        child: HoldOrderItemCardWidget(holdOrder: cart)
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemCount: options.length)
                );
              },


              onSelected: (selectedString) {
                if (kDebugMode) {
                  print(selectedString);
                }
              },

            ),
          ),
        );
      }
    );
  }
}
