import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:src/app/views/home/home_controller.dart';
import 'package:src/core/themes/colors.dart';
import 'package:src/core/themes/styles.dart';
import 'package:src/core/widgets/button_base.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "BYE BYE WORLD",
          style: AppTextStyle.appBarTitle(context),
        ),
        actions: [
          ButtonBase(
            onTap: controller.handleOnTapSaleYourTokenButton,
            title: "Sale Your Token",
          ),
          GetBuilder<HomeController>(
              id: UpdateHomePage.connectButton,
              builder: (_) {
                return ButtonBase(
                  onTap: _.handleOnTapConnectWalletButton,
                  title: _.isConnected ? "Connected" : "Connect Wallet",
                );
              })
        ],
      ),
      body: Center(
        child: GetBuilder<HomeController>(
            id: UpdateHomePage.tokenSales,
            builder: (_) {
              return Wrap(
                  spacing: 32.0,
                  runSpacing: 32.0,
                  children: _.tokenSales
                      .map((tokenSale) => Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: AppColors.backGroundDialog(context),
                                borderRadius: BorderRadius.circular(20)),
                            child: SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _Information(
                                    title: "Token Sale: ",
                                    detail: tokenSale.tokenSale,
                                  ),
                                  _Information(
                                    title: "Token Base: ",
                                    detail: tokenSale.tokenBase,
                                  ),
                                  _Information(
                                    title: "Total Sale: ",
                                    detail: tokenSale.totalSale.toString(),
                                  ),
                                  _Information(
                                    title: "Token Solded: ",
                                    detail: tokenSale.totalSold.toString(),
                                  ),
                                  _Information(
                                    title: "Sale rate: ",
                                    detail: tokenSale.saleRate.toString(),
                                  ),
                                  _Information(
                                    title: "Base rate: ",
                                    detail: tokenSale.baseRate.toString(),
                                  ),
                                  _Information(
                                    title: "Max cap: ",
                                    detail: tokenSale.maxCap.toString(),
                                  ),
                                  _Information(
                                    title: "Min Cap: ",
                                    detail: tokenSale.minCap.toString(),
                                  ),
                                  ButtonBase(
                                    onTap: () {
                                      controller
                                          .handleOnTapBuyTokenButton(tokenSale);
                                    },
                                    title: "Buy",
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList());
            }),
      ),
    );
  }
}

class _Information extends StatelessWidget {
  const _Information({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(title),
        ),
        Expanded(
          child: Text(
            detail,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
