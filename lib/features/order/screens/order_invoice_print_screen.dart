import 'dart:async';
import 'dart:isolate';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/langulage/controllers/localization_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:image/image.dart' as img;




class OrderInvoicePrintScreen extends StatefulWidget {
  final ScreenshotController screenshotController;
  const OrderInvoicePrintScreen({super.key, required this.screenshotController});

  @override
  State<OrderInvoicePrintScreen> createState() => _OrderInvoicePrintScreenState();
}

class _OrderInvoicePrintScreenState extends State<OrderInvoicePrintScreen> {

  bool connected = false;
  List<BluetoothInfo>? availableBluetoothDevices;
  bool _isLoading = false;
  bool _isSearchPrinterLoading = false;
  final List<int> _paperSizeList = [80, 58];
  int _selectedSize = 80;


  Future<void> _getBluetooth() async {
    setState(() {
      _isLoading = true;

    });


    final List<BluetoothInfo> bluetoothDevices = await PrintBluetoothThermal.pairedBluetooths;
    if (kDebugMode) {
      print("Print $bluetoothDevices");
    }
    connected = await PrintBluetoothThermal.connectionStatus;

    if(!connected) {
      Get.find<OrderController>().setBluetoothMacAddress('');
    }

    setState(() {
      availableBluetoothDevices = bluetoothDevices;
      _isLoading = false;

    });

  }

  Future<bool> _setConnect(String mac) async {
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);


    if (result) {
      setState(() {
        connected = true;
      });
    }
    return result;
  }


  @override
  void initState() {
    super.initState();

    _getBluetooth();


  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Text('paired_bluetooth'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                SizedBox(height: 20, width: 20,
                  child: _isLoading ?
                  CircularProgressIndicator(color: Theme.of(context).primaryColor) :
                  InkWell(
                    onTap: ()=> _getBluetooth(),
                    child: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
                  ),
                ),
              ]),

              SizedBox(width: 100, child: DropdownButton<int>(
                hint: Text('select'.tr),
                value: _selectedSize,
                items: _paperSizeList.map((int? value) {
                  return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value''mm'.tr));
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    _selectedSize = value!;

                  });
                },
                isExpanded: true, underline: const SizedBox(),
              ))
            ]),
          ),

          Expanded(child: availableBluetoothDevices != null && (availableBluetoothDevices?.length ?? 0) > 0 ?
          ListView.builder(
            itemCount: availableBluetoothDevices?.length,
            itemBuilder: (context, index) {
              return GetBuilder<OrderController>(builder: (orderController) {
                bool isConnected = connected &&  availableBluetoothDevices![index].macAdress == orderController.getBluetoothMacAddress();

                return Stack(children: [
                  ListTile(
                    selected: isConnected,
                    onTap: () async {

                      if(availableBluetoothDevices?[index].macAdress.isNotEmpty ?? false) {
                        if(!connected) {
                          orderController.setBluetoothMacAddress(availableBluetoothDevices?[index].macAdress);
                        }

                        setState(() => _isSearchPrinterLoading = true);
                        bool isConnect = await _setConnect(availableBluetoothDevices?[index].macAdress ?? '');
                        setState(() => _isSearchPrinterLoading = false);

                        if(isConnect || (availableBluetoothDevices?[index].macAdress == orderController.getBluetoothMacAddress())) {
                          showCustomSnackBarHelper('printer_connected_successfully'.tr, isError: false);
                        }else {
                          showCustomSnackBarHelper('printer_is_not_connected'.tr, isError: true);
                        }
                      }

                    },
                    title: Text(availableBluetoothDevices?[index].name ?? ''),
                    subtitle:  Text(isConnected ? 'connected'.tr : "click_to_connect".tr, style: ubuntuLight.copyWith(
                      color: isConnected ? null : Theme.of(context).primaryColor,
                    )),
                  ),


                  if(_isSearchPrinterLoading &&  availableBluetoothDevices?[index].macAdress == orderController.getBluetoothMacAddress())
                    GetBuilder<LocalizationController>(builder: (localizationController) {
                      return Positioned.fill(child: Align(
                        alignment: localizationController.isLtr ? Alignment.topRight : Alignment.topLeft,
                        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                      ));
                    }),

                  if(!_isSearchPrinterLoading &&  availableBluetoothDevices?[index].macAdress == orderController.getBluetoothMacAddress())
                    GetBuilder<LocalizationController>(builder: (localizationController) {
                      return Positioned.fill(child: Align(
                        alignment: localizationController.isLtr ? Alignment.topRight : Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall,
                            horizontal: Dimensions.paddingSizeLarge,
                          ),
                          child: Icon(Icons.check_circle_outline_outlined, color: Theme.of(context).primaryColor),
                        ),
                      ));
                    }),

                ]);
              });
            },
          ) :
          const NoDataWidget()),

          CustomButtonWidget(
            isLoading: _isLoading,
            onPressed: connected ? _takeScreenShot : null,
            buttonText: 'print_invoice'.tr,
          ),
        ]),
      ),
    );
  }

  Future<void> _takeScreenShot() async {
    setState(() => _isLoading = true);

    try {
      Uint8List? capturedImage = await widget.screenshotController.capture(delay: const Duration(milliseconds: 10));
      if (capturedImage != null) {
        await _printReceiptIsolate(capturedImage);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<int>> _convertImageTOBytesIsolate(Uint8List screenshot, int selectedSize, CapabilityProfile profile) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_convertImageTOBytes, receivePort.sendPort);

    final SendPort sendPort = await receivePort.first as SendPort;
    final response = ReceivePort();

    sendPort.send([screenshot, selectedSize, profile, response.sendPort]);

    return await response.first as List<int>;
  }

  static void _convertImageTOBytes(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is List && message.length == 4) {
        Uint8List screenshot = message[0];
        int selectedSize = message[1];
        CapabilityProfile profile = message[2];
        SendPort responsePort = message[3];

        final img.Image? image = img.decodeImage(screenshot);
        if (image == null) {
          responsePort.send([]);
          continue;
        }

        img.Image resized = img.copyResize(image, width: selectedSize == 80 ? 500 : 365);
        final generator = Generator(selectedSize == 80 ? PaperSize.mm80 : PaperSize.mm58, profile);

        List<int> bytes = generator.image(resized)..addAll(generator.feed(2));
        responsePort.send(bytes);
      }
    }
  }

  Future<void> _printReceiptIsolate(Uint8List screenshot) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      final profile = await CapabilityProfile.load(); // Load profile BEFORE isolate
      List<int> ticket = await _convertImageTOBytesIsolate(screenshot, _selectedSize, profile);

      if (ticket.isNotEmpty) {
        final result = await PrintBluetoothThermal.writeBytes(ticket);
        Get.back();
        showCustomSnackBarHelper('printed_successfully'.tr, isError: false);
        if (kDebugMode) print("Print result: $result");
      } else {
        showCustomSnackBarHelper('image_processing_failed'.tr, isError: true);
      }
    } else {
      showCustomSnackBarHelper('no_thermal_printer_connected'.tr);
    }
  }

}
