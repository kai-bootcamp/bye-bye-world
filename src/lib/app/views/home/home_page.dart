import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
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
    return GetBuilder<HomeController>(
        id: UpdateHomePage.page,
        builder: (_) {
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
                        title: _.isConnectedTotal
                            ? "Connected"
                            : _.isDisconnect
                                ? "Connect Wallet"
                                : _.isWrongConnected
                                    ? "Wrong Network"
                                    : "Unknow",
                      );
                    })
              ],
            ),
            body: SingleChildScrollView(
              child: GetBuilder<HomeController>(
                  id: UpdateHomePage.tokenSales,
                  builder: (_) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Wrap(
                            spacing: 32.0,
                            runSpacing: 32.0,
                            children: _.tokenSales
                                .map((tokenSale) => _TokenSaleWidget(tokenSale))
                                .toList()),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}

class _TokenSaleWidget extends StatelessWidget {
  const _TokenSaleWidget(
    this.tokenSalePair, {
    Key? key,
  }) : super(key: key);

  final TokenSaleEntity tokenSalePair;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        id: UpdateHomePage.information,
        builder: (_) {
          _.getTokenInformation(tokenSalePair.tokenSale);
          _.getTokenInformation(tokenSalePair.tokenBase);
          final tokenSale = _.tokenInformation(tokenSalePair.tokenSale);
          final tokenBase = _.tokenInformation(tokenSalePair.tokenBase);
          print('--------_TokenSaleWidget----------');
          print(tokenSalePair);
          print('--------_TokenSaleWidget----------');
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColors.backGroundDialog(context),
                borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 100,
                    width: 300,
                    child: tokenSale != null
                        ? Image.network(tokenSale.getIpfs, fit: BoxFit.fill)
                        : Text(
                            "Waitting!",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.button(context),
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  _Information(
                    title: "Token Sale: ",
                    copyData: tokenSalePair.tokenSale,
                    detail: tokenSale != null
                        ? tokenSale.name + "-" + tokenSale.symbol
                        : tokenSalePair.tokenSale,
                  ),
                  _Information(
                    title: "Token Base: ",
                    copyData: tokenSalePair.tokenSale,
                    detail: tokenBase != null
                        ? tokenBase.name + "-" + tokenBase.symbol
                        : tokenSalePair.tokenBase,
                  ),
                  _Information(
                    title: "Total Sale: ",
                    detail: tokenSale != null
                        ? (tokenSalePair.totalSale / tokenSale.powDecimal)
                                .toString() +
                            " " +
                            tokenSale.symbol
                        : (tokenSalePair.totalSale).toString() + " " + "Wei",
                  ),
                  _Information(
                    title: "Token Solded: ",
                    detail: tokenSale != null
                        ? (tokenSalePair.totalSold / tokenSale.powDecimal)
                                .toString() +
                            " " +
                            tokenSale.symbol
                        : (tokenSalePair.totalSold).toString() + " " + "Wei",
                  ),
                  _Information(
                    title: "Sale rate: ",
                    detail: tokenSale != null
                        ? (tokenSalePair.saleRate / tokenSale.powDecimal)
                                .toString() +
                            " " +
                            tokenSale.symbol
                        : (tokenSalePair.saleRate).toString() + " " + "Wei",
                  ),
                  _Information(
                    title: "Base rate: ",
                    detail: tokenBase != null
                        ? (tokenSalePair.baseRate / tokenBase.powDecimal)
                                .toString() +
                            " " +
                            tokenBase.symbol
                        : (tokenSalePair.baseRate).toString() + " " + "Wei",
                  ),
                  _Information(
                      title: "Max cap: ",
                      detail: (tokenSalePair.maxCap *
                                  tokenSalePair.saleRate /
                                  (tokenSalePair.baseRate))
                              .toString() +
                          " " +
                          (tokenSale != null ? tokenSale.symbol : "Token")),
                  _Information(
                      title: "Min Cap: ",
                      detail: (tokenSalePair.minCap *
                                  tokenSalePair.saleRate /
                                  (tokenSalePair.baseRate))
                              .toString() +
                          " " +
                          (tokenSale != null ? tokenSale.symbol : "Token")),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ButtonBase(
                    onTap: () {
                      if (tokenBase != null &&
                          tokenSale != null &&
                          tokenSalePair.isActiveSale) {
                        _.handleOnTapBuyTokenButton(
                            tokenSalePair, tokenBase, tokenSale);
                      }
                    },
                    title: tokenSalePair.isActiveSale ? "Buy" : "Sold Out",
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _Information extends StatelessWidget {
  const _Information({
    Key? key,
    required this.title,
    required this.detail,
    this.copyData,
  }) : super(key: key);

  final String title;
  final String detail;
  final String? copyData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(title),
        ),
        copyData != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.copy,
                  size: 14,
                ),
                onPressed: () {
                  FlutterClipboard.copy(copyData!);
                },
                minSize: 0.0,
              )
            : const SizedBox(),
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
