import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/barcode_generate_mobile_widget.dart';
import 'package:six_pos/features/product/widgets/barcode_generate_tab_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  final Products? product;
  const BarCodeGenerateScreen({super.key, this.product});

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  final TextEditingController quantityController = TextEditingController();
  final ReceivePort _port = ReceivePort();
  final ConfigModel? configModel = Get.find<SplashController>().configModel;

  @override
  void initState() {
    super.initState();

    quantityController.text = '10';
    Get.find<ProductController>().setBarCodeQuantity(10, isUpdate: false);

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });

    FlutterDownloader.registerCallback((id, status, progress) => downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'product'.tr),
      endDrawer:  const CustomDrawerWidget(),
      body: ResponsiveHelper.isTab(context)
          ? BarcodeGeneratorTabWidget(product: widget.product, quantityController: quantityController, configModel: configModel)
          : BarcodeGeneratorMobileWidget(product: widget.product, quantityController: quantityController, configModel: configModel),
    );
  }
}
