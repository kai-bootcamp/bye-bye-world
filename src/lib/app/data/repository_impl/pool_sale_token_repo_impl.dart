import 'package:src/app/data/provider/web3_provider.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/repository.dart';
import '../models/token_sale_model.dart';

class PoolSaleTokenRepositoryImpl implements PoolSaleTokenRepository {
  PoolSaleTokenRepositoryImpl(this._web3);
  final Web3ConnectProvider _web3;

  @override
  Future<void> createTokenSale({
    required String name,
    required String symbol,
    required String url,
    required int decimal,
    required BigInt totalSupply,
    required BigInt saleRate,
    required BigInt baseRate,
    required BigInt maxCap,
    required BigInt minCap,
  }) async {
    var ownerAddress = await _web3.createTokenFactory(
        name: name,
        symbol: symbol,
        url: url,
        decimal: decimal,
        totalSupply: totalSupply);
    final addressTokenCreate =
        await _web3.getTokenOfCreator(creator: ownerAddress);
    await _web3.createTokenSale(
        tokenSale: addressTokenCreate,
        totalSale: totalSupply,
        saleRate: saleRate,
        baseRate: baseRate,
        maxCap: maxCap,
        minCap: minCap);
  }

  @override
  Future<List<TokenSaleEntity>> getTokenSaleOfPool() async {
    final result = await _web3.getTokenSaleOfPool();
    return result.map((data) => TokenSaleModel.fromBlockChain(data)).toList();
  }

  @override
  Future<void> buySaleToken({
    required TokenSaleEntity tokenSale,
    required BigInt amount,
  }) async {
    await _web3.approveBaseTokenForPool(
      amount: amount,
      baseToken: tokenSale.tokenBase,
    );
    await _web3.buySaleToken(
      tokenSaleId: tokenSale.tokenId,
      baseAmount: amount,
    );
  }
}
