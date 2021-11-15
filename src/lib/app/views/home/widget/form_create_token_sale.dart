import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/views/home/home_controller.dart';
import 'package:src/core/themes/colors.dart';
import 'package:src/core/themes/styles.dart';
import 'package:src/core/widgets/button_base.dart';
import 'package:src/core/widgets/input_base.dart';

// ignore: must_be_immutable
class FormCreateTokenSaleWidget extends GetView<HomeController> {
  FormCreateTokenSaleWidget({Key? key}) : super(key: key);

  var _name = "";
  var _symbol = "";
  BigInt _totalSupply = BigInt.zero;
  int _decimal = 0;
  double _rateToken = 1;
  double _rateBase = 1;
  double _maxBuy = 5;
  double _minBuy = 1;
  Uint8List? _file;

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
                          return _file != null
                              ? InkWell(
                                  onTap: () async {
                                    _file = await controller
                                        .handleLoadImageButton();
                                  },
                                  child: Image.memory(_file!, fit: BoxFit.fill))
                              : IconButton(
                                  onPressed: () async {
                                    _file = await controller
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
                          _name = value;
                        },
                      ),
                      InputBase(
                        hintText: "Symbol",
                        onChange: (value) {
                          _symbol = value;
                        },
                      ),
                      InputBase(
                        hintText: "Total Supply",
                        onChange: (value) {
                          _totalSupply = BigInt.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Decimal",
                        onChange: (value) {
                          _decimal = int.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Rate Token",
                        onChange: (value) {
                          _rateToken = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Rate USDT",
                        onChange: (value) {
                          _rateBase = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Max buy",
                        onChange: (value) {
                          _maxBuy = double.parse(value);
                        },
                      ),
                      InputBase(
                        hintText: "Min buy",
                        onChange: (value) {
                          _minBuy = double.parse(value);
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
                  if (_file != null) {
                    controller.handleOnTapCreateTokenSaleButton(
                      name: _name,
                      symbol: _symbol,
                      decimal: _decimal,
                      totalSupply: _totalSupply,
                      file: _file!,
                      baseRate: _rateBase,
                      saleRate: _rateToken,
                      minCap: _minBuy,
                      maxCap: _maxBuy,
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
