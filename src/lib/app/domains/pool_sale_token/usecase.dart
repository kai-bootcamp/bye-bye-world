import 'dart:typed_data';

import 'package:src/app/domains/pool_sale_token/entity/pool_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/repository.dart';

class PoolSaleTokenUseCase {
  PoolSaleTokenUseCase(this._repo);

  PoolEntity pool = PoolEntity(tokenSales: [], tokens: []);

  final PoolSaleTokenRepository _repo;

  Future<void> getTokenSaleOfPool() async {
    try {
      pool.tokenSales = await _repo.getTokenSaleOfPool();
    } catch (exp) {
      pool
        ..tokenSales = []
        ..tokens = [];
    }
  }

  Future<void> createTokenSale({
    required String name,
    required String symbol,
    required String url,
    required int decimal,
    required BigInt totalSupply,
    required BigInt baseRate,
    required BigInt saleRate,
    required BigInt minCap,
    required BigInt maxCap,
  }) async {
    await _repo.createTokenSale(
      name: name,
      symbol: symbol,
      url: url,
      decimal: decimal,
      totalSupply: totalSupply,
      baseRate: baseRate,
      saleRate: saleRate,
      minCap: minCap,
      maxCap: maxCap,
    );
  }

  Future<void> buySaleToken({
    required TokenSaleEntity tokenSale,
    required BigInt amount,
  }) async {
    await _repo.buySaleToken(
      tokenSale: tokenSale,
      amount: amount,
    );
  }

  Future<void> getInformationToken(String token) async {
    if (!pool.isHaveInformation(token)) {
      TokenEntity tokenData = await _repo.getInformationToken(token);
      pool.tokens.add(tokenData);
    }
  }

  bool isGetTokenInfo(String token) => !pool.isHaveInformation(token);

  Future<String> uploadImageToIpfs({required Uint8List file}) async {
    return await _repo.uploadImageToIpfs(file: file);
  }
}
