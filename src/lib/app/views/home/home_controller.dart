import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/domains/connect_provider/usecase.dart';
import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/usecase.dart';

import 'package:src/app/views/home/widget/form_buy_token_sale.dart';
import 'widget/form_create_token_sale.dart';

enum UpdateHomePage { connectButton, image, tokenSales, page, information }

class HomeController extends GetxController {
  HomeController(this._connectProviderUseCase, this._poolSaleTokenUseCase);
  final PoolSaleTokenUseCase _poolSaleTokenUseCase;
  final ConnectProviderUseCase _connectProviderUseCase;

  @override
  void onInit() async {
    await _poolSaleTokenUseCase.getTokenSaleOfPool();
    update([UpdateHomePage.tokenSales]);
    super.onInit();
  }

  bool get isConnectedTotal =>
      _connectProviderUseCase.isConnected &&
      !_connectProviderUseCase.isWrongConnect;
  bool get isDisconnect => !_connectProviderUseCase.isConnected;

  bool get isWrongConnected =>
      _connectProviderUseCase.isWrongConnect &&
      _connectProviderUseCase.isConnected;

  List<TokenSaleEntity> get tokenSales => _poolSaleTokenUseCase.pool.tokenSales;

  Future<void> handleOnTapConnectWalletButton() async {
    await _connectProviderUseCase.connectWallet();
    if (isConnectedTotal) {
      update([UpdateHomePage.connectButton]);
    }
  }

  void handleOnTapSaleYourTokenButton() async {
    if (isConnectedTotal) {
      Get.dialog(FormCreateTokenSaleWidget());
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnectedTotal) {
        Get.dialog(FormCreateTokenSaleWidget());
      } else {}
    }
  }

  void handleOnTapBuyTokenButton(
    TokenSaleEntity tokenSalePair,
    TokenEntity tokenBase,
    TokenEntity tokenSale,
  ) async {
    if (isConnectedTotal) {
      Get.dialog(FormBuyTokenSaleWidget(tokenSalePair, tokenBase, tokenSale));
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnectedTotal) {
        Get.dialog(FormBuyTokenSaleWidget(tokenSalePair, tokenBase, tokenSale));
      } else {}
    }
  }

  void handleOnTapCreateTokenSaleButton({
    required String name,
    required String symbol,
    required int decimal,
    required BigInt totalSupply,
    required double saleRate,
    required double baseRate,
    required double minCap,
    required double maxCap,
    required Uint8List file,
  }) async {
    try {
      Get.dialog(const CupertinoActivityIndicator());
      final url = await _poolSaleTokenUseCase.uploadImageToIpfs(file: file);
      final _minCap = minCap * baseRate / saleRate;
      final _maxCap = maxCap * baseRate / saleRate;
      await _poolSaleTokenUseCase.createTokenSale(
        name: name,
        symbol: symbol,
        url: url,
        decimal: decimal,
        totalSupply: totalSupply * BigInt.from(pow(10, decimal)),
        saleRate: BigInt.from(saleRate * pow(10, decimal)),
        baseRate: BigInt.from(baseRate * pow(10, 6)),
        minCap: BigInt.from(_minCap * pow(10, 6) / pow(10, decimal)),
        maxCap: BigInt.from(
          _maxCap * pow(10, 6) / pow(10, decimal),
        ),
      );
      await _poolSaleTokenUseCase.getTokenSaleOfPool();
      update([UpdateHomePage.tokenSales]);
      Get.back();
      Get.back();
    } catch (exp) {
      Get.back();
    }
  }

  Future<Uint8List?> handleLoadImageButton() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      update([UpdateHomePage.image]);
      return fileBytes;
    }
  }

  Future<void> handleBuyButtonOntap() async {
    if (isConnectedTotal) {
      Get.dialog(FormCreateTokenSaleWidget());
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnectedTotal) {
        Get.dialog(FormCreateTokenSaleWidget());
      } else {}
    }
  }

  Future<void> buyTokenSale({
    required TokenSaleEntity tokenSale,
    required double amount,
  }) async {
    try {
      Get.dialog(const CupertinoActivityIndicator());
      final baseAmount =
          BigInt.from(amount * (tokenSale.baseRate / tokenSale.saleRate));
      await _poolSaleTokenUseCase.buySaleToken(
        tokenSale: tokenSale,
        amount: baseAmount,
      );
      await _poolSaleTokenUseCase.getTokenSaleOfPool();
      Get.back();
      Get.back();
      update([UpdateHomePage.tokenSales]);
    } catch (exp) {
      Get.back();
    }
  }

  Future<void> getTokenInformation(String address) async {
    final index = _poolSaleTokenUseCase.pool.tokens
        .indexWhere((element) => element.address == address);
    if (index == -1) {
      await _poolSaleTokenUseCase.getInformationToken(address);
      update([UpdateHomePage.information]);
    }
  }

  TokenEntity? tokenInformation(String address) {
    final index = _poolSaleTokenUseCase.pool.tokens
        .indexWhere((element) => element.address == address);
    if (index != -1) {
      return _poolSaleTokenUseCase.pool.tokens[index];
    } else {
      return null;
    }
  }

  void updateConnected(bool isConnected, bool isWrongConnected) async {
    _connectProviderUseCase.updateConnect(isConnected, isWrongConnected);
    try {
      await _poolSaleTokenUseCase.getTokenSaleOfPool();
    } catch (exp) {
      _poolSaleTokenUseCase.pool
        ..tokenSales = []
        ..tokens = [];
    }
    update([UpdateHomePage.page]);
  }
}
