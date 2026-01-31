import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/account_management/domain/models/income_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';

class IncomeInfoCardWidget extends StatelessWidget {
  final Incomes? income;
  final int? index;
  const IncomeInfoCardWidget({Key? key, this.index, this.income}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 5, color: Theme.of(context).primaryColor.withValues(alpha:0.06)),

        Container(color: Theme.of(context).cardColor, child: Column(children: [
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: Text('${index! + 1}.', style: ubuntuRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
            title: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text('${'account_type'.tr}: ${income!.account != null? income!.account!.account: ''}', style: ubuntuMedium.copyWith(color: Theme.of(context).primaryColor),),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${'debit'.tr}: ', style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('- ${income!.debit == 1? PriceConverterHelper.priceWithSymbol(income!.amount!): 0}', style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${'credit'.tr}: ', style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),

                Text(' ${income!.credit == 1? PriceConverterHelper.priceWithSymbol(income!.amount!): 0 }', style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

            ]),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: CustomDividerWidget(color: Theme.of(context).hintColor),
          ),

          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const SizedBox(),
            title: Text('balance'.tr, style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),
            trailing: Text(' ${PriceConverterHelper.priceWithSymbol(income!.balance!)}', style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
              Text('${'description'.tr} : ', style: ubuntuRegular.copyWith(color: context.customThemeColors.textColor)),

              Expanded(
                child: Text('- ${income!.description}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuRegular.copyWith(
                    color:  Theme.of(context).hintColor,
                  ),
                ),
              ),

            ],),
          ),
        ],),),

        Container(height: 5, color: Theme.of(context).primaryColor.withValues(alpha:0.06)),
      ],
    );
  }
}
