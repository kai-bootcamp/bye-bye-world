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
