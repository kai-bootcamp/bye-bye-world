import 'dart:typed_data';

import 'package:src/app/data/provider/ipfs_provider.dart';
import 'package:src/app/data/provider/web3_provider.dart';
import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';
import 'package:src/app/domains/pool_sale_token/repository.dart';
import '../models/token_sale_model.dart';

class PoolSaleTokenRepositoryImpl implements PoolSaleTokenRepository {
  PoolSaleTokenRepositoryImpl(this._web3, this._ipfs);
  final Web3ConnectProvider _web3;
  final IPFSProvider _ipfs;

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
    final allowanceValue = await _web3.checkAllowanceOfAddress();
    if (allowanceValue <= amount) {
      await _web3.approveBaseTokenForPool(
        amount: amount,
        baseToken: tokenSale.tokenBase,
      );
    }
    await _web3.buySaleToken(
      tokenSaleId: tokenSale.tokenId,
      baseAmount: amount,
    );
  }

  @override
  Future<TokenEntity> getInformationToken(String token) async {
    final data = await _web3.getTokenInformation(token);
    return TokenModel.fromBlockChain(data, token);
  }

  @override
  Future<String> uploadImageToIpfs({required Uint8List file}) async {
    return await _ipfs.uploadImage(file: file);
  }
}
