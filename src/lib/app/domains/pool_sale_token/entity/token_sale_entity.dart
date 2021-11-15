class TokenSaleEntity {
  final String tokenSale;
  final String tokenBase;
  final BigInt totalSale;
  final BigInt totalSold;
  final BigInt saleRate;
  final BigInt baseRate;
  final BigInt maxCap;
  final BigInt minCap;
  final BigInt tokenId;
  final bool isActive;
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

  double getAmountBase(
      double amountSale, BigInt powDecimalSale, BigInt powDecimalBase) {
    return (amountSale * (baseRate / saleRate)) /
        (powDecimalBase / powDecimalSale);
  }

  bool get isActiveSale => totalSale > totalSold;

  @override
  String toString() {
    return 'TokenSaleEntity(tokenSale: $tokenSale, tokenBase: $tokenBase, totalSale: $totalSale, totalSold: $totalSold, saleRate: $saleRate, baseRate: $baseRate, maxCap: $maxCap, minCap: $minCap, tokenId: $tokenId, isActive: $isActive)';
  }
}
