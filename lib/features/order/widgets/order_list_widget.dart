import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/order/screens/order_details_screen.dart';
import 'package:six_pos/features/order/widgets/order_card_widget.dart';


class OrderListWidget extends StatefulWidget {
  const OrderListWidget({super.key});

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<OrderController>(
      builder: (orderController) {
        if(orderController.orderModel == null) return const CustomLoaderWidget();

        return (orderController.orderModel?.orders?.isNotEmpty ?? false) ? PaginatedListWidget(
          onPaginate: (int? offset) async => await orderController.getOrderList(offset ?? 1),
          totalSize: orderController.orderModel?.total,
          offset: orderController.orderModel?.offset,
          limit: orderController.orderModel?.limit,
          itemView: Expanded(child: ListView.builder(
            itemCount: orderController.orderModel?.orders?.length ?? 0,
            itemBuilder: (ctx,index){
              return InkWell(
                onTap: ()=> Get.to(OrderDetailsScreen(orderId: orderController.orderModel?.orders?[index].orderId)),
                child: OrderCardWidget(order: orderController.orderModel?.orders?[index]),
              );

            },
          )),
        ) :
        const NoDataWidget();
      },
    );
  }
}

