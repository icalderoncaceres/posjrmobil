import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_menu_textfield_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/features/currency/controllers/currency_controller.dart';
import 'package:six_pos/features/currency/data/models/currency_model.dart';
import 'package:six_pos/features/product_setup/widgets/currency_price_field_widget.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';

class ProductPriceInfoWidget extends StatefulWidget {
  const ProductPriceInfoWidget({Key? key}) : super(key: key);

  @override
  State<ProductPriceInfoWidget> createState() => _ProductPriceInfoWidgetState();
}

class _ProductPriceInfoWidgetState extends State<ProductPriceInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  Dimensions.paddingSizeLarge,
                ).copyWith(top: 0),
                child: Text(
                  'price_setup'.tr,
                  style: ubuntuMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                color: Theme.of(context).cardColor,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.fontSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      Dimensions.paddingSizeExtraSmall,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ResponsiveHelper.isTab(context)) ...[
                        Row(
                          children: [
                            Expanded(
                              child: CurrencyPriceFieldWidget(
                                priceController: productController
                                    .productSellingPriceController,
                                title: 'selling_price'.tr,
                                hint: 'selling_price_hint'.tr,
                                isRequired: true,
                                onCurrencyChanged: (currency, originalPrice) {
                                  productController.setSelectedCurrency(
                                    currency.id,
                                  );
                                  productController.setOriginalSellingPrice(
                                    originalPrice,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: Dimensions.paddingSizeLarge),

                            Expanded(
                              child: CustomFieldWithTitleWidget(
                                customTextField: CustomTextFieldWidget(
                                  hintText: 'purchase_price_hint'.tr,
                                  controller: productController
                                      .productPurchasePriceController,
                                  fontSize: Dimensions.fontSizeSmall,
                                  inputType: TextInputType.number,
                                  contentPadding: Dimensions.paddingSizeDefault,
                                ),
                                title: 'purchase_price'.tr,
                                requiredField: true,
                                padding: 0,
                              ),
                            ),
                            SizedBox(width: Dimensions.paddingSizeLarge),

                            Expanded(
                              child: CustomFieldWithTitleWidget(
                                customTextField: CustomMenuTextFieldWidget(
                                  hintText: 'amount'.tr,
                                  fontSize: Dimensions.fontSizeSmall,
                                  controller: productController
                                      .productDiscountController,
                                  inputType: TextInputType.number,
                                  menuWidget: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall,
                                    ),
                                    height: 50,
                                    width: Get.width * 0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).hintColor.withValues(alpha: 0.15),
                                    ),
                                    child: DropdownButton<String>(
                                      value:
                                          productController.discountTypeIndex ==
                                              0
                                          ? 'percent'
                                          : 'amount',
                                      items: <String>['percent', 'amount'].map((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value.tr,
                                            style: ubuntuRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        productController
                                            .setSelectedDiscountType(value);
                                        productController.setDiscountTypeIndex(
                                          value == 'percent' ? 0 : 1,
                                          true,
                                        );
                                      },
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      iconEnabledColor: Theme.of(
                                        context,
                                      ).hintColor,
                                    ),
                                  ),
                                ),
                                title: 'discount_type'.tr,
                                padding: 0,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        CurrencyPriceFieldWidget(
                          priceController:
                              productController.productSellingPriceController,
                          title: 'selling_price'.tr,
                          hint: 'selling_price_hint'.tr,
                          isRequired: true,
                          onCurrencyChanged: (currency, originalPrice) {
                            productController.setSelectedCurrency(currency.id);
                            productController.setOriginalSellingPrice(
                              originalPrice,
                            );
                          },
                        ),
                        SizedBox(height: Dimensions.paddingSizeLarge),

                        // Widget para mostrar precios en todas las monedas
                        GetBuilder<CurrencyController>(
                          builder: (currencyController) {
                            return GetBuilder<ProductController>(
                              builder: (productController) {
                                // Solo mostrar si hay un precio de venta ingresado
                                if (productController
                                    .productSellingPriceController
                                    .text
                                    .isNotEmpty) {
                                  double sellingPrice =
                                      double.tryParse(
                                        productController
                                            .productSellingPriceController
                                            .text,
                                      ) ??
                                      0;
                                  if (sellingPrice > 0) {
                                    return _buildPriceConversionsWidget(
                                      context,
                                      sellingPrice,
                                      currencyController,
                                      productController,
                                    );
                                  }
                                }
                                return SizedBox.shrink();
                              },
                            );
                          },
                        ),

                        SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomFieldWithTitleWidget(
                          customTextField: CustomTextFieldWidget(
                            hintText: 'purchase_price_hint'.tr,
                            controller: productController
                                .productPurchasePriceController,
                            fontSize: Dimensions.fontSizeSmall,
                            inputType: TextInputType.number,
                            contentPadding: Dimensions.paddingSizeDefault,
                          ),
                          title: 'purchase_price'.tr,
                          requiredField: true,
                          padding: 0,
                        ),
                        SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomFieldWithTitleWidget(
                          customTextField: CustomMenuTextFieldWidget(
                            hintText: 'amount'.tr,
                            fontSize: Dimensions.fontSizeSmall,
                            controller:
                                productController.productDiscountController,
                            inputType: TextInputType.number,
                            menuWidget: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                color: Theme.of(
                                  context,
                                ).hintColor.withValues(alpha: 0.15),
                              ),
                              child: DropdownButton<String>(
                                value: productController.discountTypeIndex == 0
                                    ? 'percent'
                                    : 'amount',
                                items: <String>['percent', 'amount'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.tr,
                                      style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  productController.setSelectedDiscountType(
                                    value,
                                  );
                                  productController.setDiscountTypeIndex(
                                    value == 'percent' ? 0 : 1,
                                    true,
                                  );
                                },
                                isExpanded: true,
                                underline: const SizedBox(),
                                iconEnabledColor: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          title: 'discount_type'.tr,
                          padding: 0,
                        ),
                      ],
                      SizedBox(height: Dimensions.paddingSizeLarge),

                      if (ResponsiveHelper.isTab(context)) ...[
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomFieldWithTitleWidget(
                                  customTextField: CustomTextFieldWidget(
                                    hintText: 'tax_hint'.tr,
                                    fontSize: Dimensions.fontSizeSmall,
                                    controller:
                                        productController.productTaxController,
                                    inputType: TextInputType.number,
                                    contentPadding:
                                        Dimensions.paddingSizeDefault,
                                  ),
                                  title: '${'tax_in_percent'.tr}  (%)',
                                  padding: 0,
                                ),
                              ),
                              SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(
                                child: GetBuilder<SupplierController>(
                                  builder: (supplierController) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'supplier'.tr,
                                          style: ubuntuRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeSmall,
                                        ),

                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                              width: .5,
                                              color: Theme.of(
                                                context,
                                              ).hintColor.withValues(alpha: .7),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeMediumBorder,
                                            ),
                                          ),
                                          child: DropdownButton<int>(
                                            hint: Text(
                                              'select_supplier'.tr,
                                              style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            value: supplierController
                                                .selectedSupplierId,
                                            items: supplierController
                                                .supplierModel
                                                ?.supplierList
                                                ?.map((Suppliers? value) {
                                                  return DropdownMenuItem<int>(
                                                    value: value?.id,
                                                    child: Text(
                                                      value?.name ?? '',
                                                      style: ubuntuRegular
                                                          .copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                          ),
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                            onChanged: (int? value) {
                                              supplierController
                                                  .setSupplierIndex(
                                                    value,
                                                    true,
                                                  );
                                            },
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            iconEnabledColor: Theme.of(
                                              context,
                                            ).hintColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Dimensions.paddingSizeSmall,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(child: const SizedBox()),
                            ],
                          ),
                        ),
                      ] else ...[
                        CustomFieldWithTitleWidget(
                          customTextField: CustomTextFieldWidget(
                            hintText: 'tax_hint'.tr,
                            fontSize: Dimensions.fontSizeSmall,
                            controller: productController.productTaxController,
                            inputType: TextInputType.number,
                            contentPadding: Dimensions.paddingSizeDefault,
                          ),
                          title: '${'tax_in_percent'.tr}  (%)',
                          padding: 0,
                        ),
                        SizedBox(height: Dimensions.paddingSizeLarge),

                        GetBuilder<SupplierController>(
                          builder: (supplierController) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'supplier'.tr,
                                  style: ubuntuRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeSmall,
                                ),

                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                      width: .5,
                                      color: Theme.of(
                                        context,
                                      ).hintColor.withValues(alpha: .7),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeMediumBorder,
                                    ),
                                  ),
                                  child: DropdownButton<int>(
                                    hint: Text(
                                      'select_supplier'.tr,
                                      style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    value:
                                        supplierController.selectedSupplierId,
                                    items: supplierController
                                        .supplierModel
                                        ?.supplierList
                                        ?.map((Suppliers? value) {
                                          return DropdownMenuItem<int>(
                                            value: value?.id,
                                            child: Text(
                                              value?.name ?? '',
                                              style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (int? value) {
                                      supplierController.setSupplierIndex(
                                        value,
                                        true,
                                      );
                                    },
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: Theme.of(
                                      context,
                                    ).hintColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeSmall,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceConversionsWidget(
    BuildContext context,
    double sellingPrice,
    CurrencyController currencyController,
    ProductController productController,
  ) {
    // Obtener la moneda seleccionada para el precio
    Currency? selectedCurrency = currencyController.currencyList
        .firstWhereOrNull((c) => c.id == productController.selectedCurrencyId);

    // Si no hay moneda seleccionada, usar USD por defecto
    selectedCurrency ??= currencyController.baseCurrency;

    if (selectedCurrency == null) return SizedBox.shrink();

    // Convertir el precio a USD (moneda base) primero
    double priceInUSD = selectedCurrency.isBase
        ? sellingPrice
        : sellingPrice / selectedCurrency.exchangeRate;

    // Obtener solo las monedas activas y diferentes a la seleccionada
    List<Currency> otherCurrencies = currencyController.currencyList
        .where((c) => c.isActive && c.id != selectedCurrency!.id)
        .take(6) // Limitar a 6 monedas para no sobrecargar la UI
        .toList();

    if (otherCurrencies.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precio en otras monedas',
            style: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            'Precio actual: ${selectedCurrency.symbol}${sellingPrice.toStringAsFixed(2)} ${selectedCurrency.country}',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.paddingSizeSmall),

          Wrap(
            spacing: Dimensions.paddingSizeSmall,
            runSpacing: Dimensions.paddingSizeExtraSmall,
            children: otherCurrencies.map((currency) {
              double convertedPrice = currency.isBase
                  ? priceInUSD
                  : priceInUSD * currency.exchangeRate;

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${currency.symbol}${convertedPrice.toStringAsFixed(2)} ${_getCurrencyCode(currency.country)}',
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            '* Solo para visualización',
            style: ubuntuRegular.copyWith(
              fontSize: 10,
              color: Theme.of(context).hintColor.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyCode(String countryName) {
    // Extraer código de moneda del nombre del país
    if (countryName.contains('Dólar')) return 'USD';
    if (countryName.contains('Peso Colombiano')) return 'COP';
    if (countryName.contains('Bolívar Venezolano')) return 'VES';
    if (countryName.contains('Euro')) return 'EUR';
    if (countryName.contains('Peso')) return 'MXN';
    if (countryName.contains('Real')) return 'BRL';

    // Retornar las primeras 3 letras si no encuentra coincidencia
    return countryName.length >= 3
        ? countryName.substring(0, 3).toUpperCase()
        : countryName.toUpperCase();
  }
}
