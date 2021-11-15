import 'dart:typed_data';

import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
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

  Future<TokenEntity> getInformationToken(String token);

  Future<String> uploadImageToIpfs({required Uint8List file});
}
