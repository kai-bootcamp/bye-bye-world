import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get_connect.dart';
import 'package:get/instance_manager.dart';
import 'package:src/app/data/config.dart';
import 'package:src/app/views/home/home_controller.dart';

class Web3ConnectProvider extends GetConnect {
  final supportChain = rinkeby.chainId;
  static const poolSaleToken = "0x8d9325369781aeEAc9A73CacD29EEe1d86e7effe";
  static const tokenFactory = "0x435a9C938A1469C2717cC1564FAC781B14931DaC";
  static const tokenUSDT = "0x5CD0508320eEA7F86a075fb3C243015c1C4a2ba4";

  Future<void> connectToMetamask() async {
    final controller = Get.find<HomeController>();
    if (ethereum != null) {
      final addresss = await ethereum!.requestAccount();
      if (addresss.isNotEmpty) {
        final _currentChain = await ethereum!.getChainId();
        controller.updateConnected(true, !(_currentChain == supportChain));
      } else {
        final _currentChain = await ethereum!.getChainId();
        controller.updateConnected(false, !(_currentChain == supportChain));
      }

      ethereum!.onChainChanged((chainId) {
        print("--------onAccountsChanged-------------");
        controller.updateConnected(
            ethereum!.isConnected(), !(chainId == supportChain));
        print("--------onAccountsChanged-------------");
      });
      ethereum!.onAccountsChanged((accounts) {
        print("--------onAccountsChanged-------------");
        controller.update([UpdateHomePage.page]);
        print("--------onAccountsChanged-------------");
      });

      ethereum!.onDisconnect((error) {
        print("--------onDisconnect-------------");
        controller.updateConnected(false, true);
        print("--------onDisconnect-------------");
      });

      ethereum!.onConnect((connectInfo) async {
        print("--------onConnect-------------");
        final isConnected = ethereum!.isConnected();
        final isCorrectConnected =
            (await ethereum!.getChainId()) == supportChain;
        controller.updateConnected(isConnected, !isCorrectConnected);
        print("---------onConnect------------");
      });
    }
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

  Future<BigInt> checkAllowanceOfAddress({
    String? owner,
    String? sender,
    String? token,
  }) async {
    print("-------------buySaleToken-------------------");
    owner ??= await provider!.getSigner().getAddress();
    sender ??= poolSaleToken;
    token ??= tokenUSDT;
    final allownaceBaseTokenOfSender =
        await Contract(token, Interface(tokenAbi), provider!)
            .call<BigInt>("allowance", [owner, sender]);
    print(allownaceBaseTokenOfSender);
    print("-------------buySaleToken-------------------");
    return allownaceBaseTokenOfSender;
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

  Future<List<dynamic>> getTokenInformation(String token) async {
    print("-------------getTokenInformation-------------------");
    print(token);
    final data =
        await Contract(tokenFactory, Interface(tokenFactoryAbi), provider!)
            .call<List<dynamic>>("informationOfToken", [token]);
    print(data);
    print("--------------getTokenInformation------------------");
    return data;
  }
}
