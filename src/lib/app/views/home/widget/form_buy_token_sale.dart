import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/views/home/home_controller.dart';
import 'package:src/core/themes/colors.dart';
import 'package:src/core/themes/styles.dart';
import 'package:src/core/widgets/button_base.dart';
import 'package:src/core/widgets/input_base.dart';

class FormBuyTokenSaleWidget extends StatefulWidget {
  const FormBuyTokenSaleWidget(
      this.tokenSalePair, this.tokenBase, this.tokenSale,
      {Key? key})
      : super(key: key);

  final TokenSaleEntity tokenSalePair;
  final TokenEntity tokenBase;
  final TokenEntity tokenSale;

  @override
  State<FormBuyTokenSaleWidget> createState() => _FormBuyTokenSaleWidgetState();
}

class _FormBuyTokenSaleWidgetState extends State<FormBuyTokenSaleWidget> {
  var amountSale = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.backGroundDialog(context),
        child: SizedBox(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "BUY TOKEN " + widget.tokenSale.symbol,
                style: AppTextStyle.appBarTitle(context),
              ),
            ),
            InputBase(
              hintText: "Buy number",
              onChange: (value) {
                amountSale = double.parse(value);
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.tokenSalePair
                      .getAmountBase(amountSale, widget.tokenSale.powDecimal,
                          widget.tokenBase.powDecimal)
                      .toString() +
                  " " +
                  widget.tokenBase.symbol),
            ),
            ButtonBase(
                onTap: () {
                  Get.find<HomeController>().buyTokenSale(
                    tokenSale: widget.tokenSalePair,
                    amount: amountSale,
                  );
                },
                title: "Buy")
          ]),
        ),
      ),
    );
  }
}
