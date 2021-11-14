import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';

abstract class PoolSaleTokenRepository {
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
  });

  Future<List<TokenSaleEntity>> getTokenSaleOfPool();

  Future<void> buySaleToken({
    required TokenSaleEntity tokenSale,
    required BigInt amount,
  });
}
