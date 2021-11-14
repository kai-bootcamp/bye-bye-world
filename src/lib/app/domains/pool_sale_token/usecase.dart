import 'package:flutter/material.dart';
import 'package:src/app/domains/pool_sale_token/entity/pool_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/repository.dart';

class PoolSaleTokenUseCase {
  PoolSaleTokenUseCase(this._repo);

  PoolEntity pool = PoolEntity(tokenSales: []);

  final PoolSaleTokenRepository _repo;

  Future<void> getTokenSaleOfPool() async {
    pool.tokenSales = await _repo.getTokenSaleOfPool();
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
}
