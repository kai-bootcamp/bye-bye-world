import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';

extension TokenSaleModel on TokenSaleEntity {
  static TokenSaleEntity fromBlockChain(List<dynamic> data) {
    return TokenSaleEntity(
      tokenSale: data[0],
      tokenBase: data[1],
      totalSale: BigInt.parse(data[2].toString()),
      totalSold: BigInt.parse(data[3].toString()),
      saleRate: BigInt.parse(data[4].toString()),
      baseRate: BigInt.parse(data[5].toString()),
      maxCap: BigInt.parse(data[6].toString()),
      minCap: BigInt.parse(data[7].toString()),
      tokenId: BigInt.parse(data[8].toString()),
      isActive: data[9],
    );
  }
}

extension TokenModel on TokenSaleEntity {
  static TokenEntity fromBlockChain(List<dynamic> data, String address) {
    return TokenEntity(
        address: address,
        name: data[0],
        symbol: data[1],
        decimal: int.parse(data[2].toString()),
        totalSupply: BigInt.parse(data[3].toString()),
        url: data[4]);
  }
}
