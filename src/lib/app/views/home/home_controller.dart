import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/domains/connect_provider/usecase.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/usecase.dart';
import 'package:http/http.dart' as http;
import 'package:src/app/views/home/widget/form_buy_token_sale.dart';
import 'widget/form_create_token_sale.dart';

enum UpdateHomePage {
  connectButton,
  image,
  tokenSales,
}

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

  bool get isConnected => _connectProviderUseCase.isConnected;

  List<TokenSaleEntity> get tokenSales => _poolSaleTokenUseCase.pool.tokenSales;

  Future<void> handleOnTapConnectWalletButton() async {
    await _connectProviderUseCase.connectWallet();
    if (isConnected) {
      update([UpdateHomePage.connectButton]);
    }
  }

  void handleOnTapSaleYourTokenButton() async {
    if (isConnected) {
      Get.dialog(FormCreateTokenSaleWidget());
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnected) {
        Get.dialog(FormCreateTokenSaleWidget());
      } else {}
    }
  }

  void handleOnTapBuyTokenButton(TokenSaleEntity tokenSale) async {
    if (isConnected) {
      Get.dialog(FormBuyTokenSaleWidget(tokenSale));
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnected) {
        Get.dialog(FormBuyTokenSaleWidget(tokenSale));
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
      final url = await _uploadImage(file: file);
      final _minCap = minCap * baseRate / saleRate;
      final _maxCap = maxCap * baseRate / saleRate;
      await _poolSaleTokenUseCase.createTokenSale(
        name: name,
        symbol: symbol,
        url: url,
        decimal: decimal,
        totalSupply: totalSupply,
        saleRate: BigInt.from(saleRate * pow(10, decimal)),
        baseRate: BigInt.from(baseRate * pow(10, 6)),
        minCap: BigInt.from(_minCap * pow(10, 6)),
        maxCap: BigInt.from(
          _maxCap * pow(10, 6),
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

  Future<String> _uploadImage({
    required Uint8List file,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.nft.storage/upload'));
    request.files.add(http.MultipartFile.fromBytes(
      "file",
      file,
      filename: "Content-Disposition",
    ));
    request.headers.addAll({
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEU1MTBiMGRDQTI1NUJjMjk3OEQwMjZDNzc0Zjc0M0E1M2ViMGNENkIiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzNjcxMzA4NjY2MCwibmFtZSI6Ik5GVCJ9.AWoc2fS5-602ObnLVJFZHROtawsK2iobN2zv2fMdPxY"
    });

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      return jsonDecode(data)["value"]["cid"];
    } else {
      final data = await response.stream.bytesToString();
      throw Exception('MoonProvider Error: $data');
    }
  }

  Future<void> handleBuyButtonOntap() async {
    if (isConnected) {
      Get.dialog(FormCreateTokenSaleWidget());
    } else {
      await handleOnTapConnectWalletButton();
      if (isConnected) {
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
}
