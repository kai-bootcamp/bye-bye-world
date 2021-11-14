import 'dart:html';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get_connect.dart';
import 'package:src/app/data/config.dart';

class Web3ConnectProvider extends GetConnect {
  final supportChain = rinkeby.chainId;
  static const poolSaleToken = "0x8d9325369781aeEAc9A73CacD29EEe1d86e7effe";
  static const tokenFactory = "0x435a9C938A1469C2717cC1564FAC781B14931DaC";
  static const tokenUSDT = "0x5CD0508320eEA7F86a075fb3C243015c1C4a2ba4";

  Future<bool> connectToMetamask() async {
    if (ethereum != null) {
      final addresss = await ethereum!.requestAccount();
      if (addresss.isNotEmpty) {
        final _currentChain = await ethereum!.getChainId();
        if (_currentChain == supportChain) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  Future<String> createTokenFactory({
    required String name,
    required String symbol,
    required String url,
    required int decimal,
    required BigInt totalSupply,
  }) async {
    print("------------createTokenFactory--------------------");
    print(url);
    print(name);
    print(symbol);
    print(decimal);
    print(totalSupply);

    final tx = await Contract(
            tokenFactory, Interface(tokenFactoryAbi), provider!.getSigner())
        .send("create", [
      poolSaleToken,
      name,
      symbol,
      url,
      decimal,
      totalSupply,
    ]);
    var data = await tx.wait();
    print(data);
    print("------------createTokenFactory--------------------");
    return data.from;
  }

  Future<dynamic> getTokenOfCreator({required String creator}) async {
    print("-------------getTokenOfCreator-------------------");
    print(creator);

    final addressToken =
        await Contract(tokenFactory, Interface(tokenFactoryAbi), provider!)
            .call<String>("tokenOf", [
      creator,
    ]);
    print(addressToken);
    print("--------------getTokenOfCreator------------------");
    return addressToken;
  }

  Future<void> createTokenSale({
    required String tokenSale,
    required BigInt totalSale,
    required BigInt saleRate,
    required BigInt baseRate,
    required BigInt maxCap,
    required BigInt minCap,
  }) async {
    print("-------------createTokenSale-------------------");
    print(tokenSale);
    print(totalSale);
    print(saleRate);
    print(baseRate);
    print(maxCap);
    print(minCap);

    final tx = await Contract(
            poolSaleToken, Interface(poolSaleTokenAbi), provider!.getSigner())
        .send("createTokenSale", [
      tokenSale,
      tokenUSDT,
      totalSale,
      saleRate,
      baseRate,
      maxCap,
      minCap,
    ]);
    final data = await tx.wait();
    print(data);
    print("-------------createTokenSale-------------------");
  }

  Future<List<dynamic>> getTokenSaleOfPool() async {
    print("-------------getTokenSaleOfPool-------------------");

    final data =
        await Contract(poolSaleToken, Interface(poolSaleTokenAbi), provider!)
            .call<List<dynamic>>("tokenSaleInfo", []);
    print(data);
    print("--------------getTokenSaleOfPool------------------");
    return data;
  }

  Future<void> approveBaseTokenForPool({
    required BigInt amount,
    required String baseToken,
  }) async {
    print("-------------approveBaseTokenForPool-------------------");
    print(amount);
    print(baseToken);
    final tx =
        await Contract(baseToken, Interface(tokenAbi), provider!.getSigner())
            .send("approve", [poolSaleToken, amount * BigInt.two]);
    final data = await tx.wait();
    print(data);
    print("-------------createTokenSale-------------------");
  }

  Future<void> buySaleToken({
    required BigInt tokenSaleId,
    required BigInt baseAmount,
  }) async {
    print("-------------buySaleToken-------------------");
    print(tokenSaleId);
    print(baseAmount);
    final tx = await Contract(
            poolSaleToken, Interface(poolSaleTokenAbi), provider!.getSigner())
        .send("buySaleToken", [tokenSaleId, baseAmount]);
    final data = await tx.wait();
    print(data);
    print("-------------buySaleToken-------------------");
  }
}
