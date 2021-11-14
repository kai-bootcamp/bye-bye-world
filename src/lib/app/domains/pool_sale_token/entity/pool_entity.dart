import 'package:src/app/domains/pool_sale_token/entity/data_token_entity.dart';
import 'package:src/app/domains/pool_sale_token/entity/token_sale_entity.dart';

class PoolEntity {
  List<TokenSaleEntity> tokenSales;
  List<TokenEntity> tokens;

  PoolEntity({
    required this.tokenSales,
    required this.tokens,
  });

  bool isHaveInformation(String token) {
    return tokens.indexWhere((element) => element.address == token) != -1;
  }
}
