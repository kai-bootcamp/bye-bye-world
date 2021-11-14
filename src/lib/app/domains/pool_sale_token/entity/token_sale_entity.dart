import 'dart:math';

class TokenSaleEntity {
  final String tokenSale;
  final String tokenBase;
  final BigInt totalSale;
  BigInt totalSold;
  final BigInt saleRate;
  final BigInt baseRate;
  final BigInt maxCap;
  final BigInt minCap;
  final BigInt tokenId;
  bool isActive;
  TokenSaleEntity({
    required this.tokenSale,
    required this.tokenBase,
    required this.totalSale,
    required this.totalSold,
    required this.saleRate,
    required this.baseRate,
    required this.maxCap,
    required this.minCap,
    required this.isActive,
    required this.tokenId,
  });

  double getAmountBase(double amountSale) {
    return amountSale * (baseRate / saleRate) / pow(10, 6);
  }
}
