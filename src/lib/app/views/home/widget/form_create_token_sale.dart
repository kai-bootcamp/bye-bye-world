import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/views/home/home_controller.dart';
import 'package:src/core/themes/colors.dart';
import 'package:src/core/themes/styles.dart';
import 'package:src/core/widgets/button_base.dart';
import 'package:src/core/widgets/input_base.dart';

class FormCreateTokenSaleWidget extends GetView<HomeController> {
  FormCreateTokenSaleWidget({Key? key}) : super(key: key);

  var name = "";
  var symbol = "";
  BigInt totalSupply = BigInt.zero;
  int decimal = 0;
  double rateToken = 1;
  double rateBase = 1;
  double maxBuy = 5;
  double minBuy = 1;
  Uint8List? file;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColors.backGroundDialog(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "CREATE NEW TOKEN FOR SALE",
                style: AppTextStyle.appBarTitle(context),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.all(8.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)),
                    child: GetBuilder<HomeController>(
                        id: UpdateHomePage.image,
                        builder: (_) {
                          return file != null
                              ? InkWell(
                                  onTap: () async {
                                    file = await controller
                                        .handleLoadImageButton();
                                  },
                                  child: Image.memory(file!, fit: BoxFit.fill))
                              : IconButton(
                                  onPressed: () async {
                                    file = await controller
                                        .handleLoadImageButton();
                                  },
                                  icon: const Icon(Icons.image),
                                );
                        })),
                SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputBase(
                        hintText: "Name",
                        onChange: (value) {
                          name = value;
                        },
                      ),
                      InputBase(
                        hintText: "Symbol",
                        onChange: (value) {
                          symbol = value;
                        },
                      ),
                      InputBase(
                        hintText: "Total Supply",
                        onChange: (value) {
                          totalSupply = BigInt.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Decimal",
                        onChange: (value) {
                          decimal = int.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Rate Token",
                        onChange: (value) {
                          rateToken = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Rate USDT",
                        onChange: (value) {
                          rateBase = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Max buy",
                        onChange: (value) {
                          maxBuy = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Min buy",
                        onChange: (value) {
                          minBuy = double.parse(value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 500,
              child: ButtonBase(
                padding: const EdgeInsets.all(16.0),
                title: "Create",
                onTap: () async {
                  if (file != null) {
                    controller.handleOnTapCreateTokenSaleButton(
                      name: name,
                      symbol: symbol,
                      decimal: decimal,
                      totalSupply: totalSupply,
                      file: file!,
                      baseRate: rateBase,
                      saleRate: rateToken,
                      minCap: minBuy,
                      maxCap: maxBuy,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
