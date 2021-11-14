import 'dart:math';

class TokenEntity {
  final String address;
  final String name;
  final String symbol;
  final int decimal;
  final BigInt totalSupply;
  final String url;
  TokenEntity({
    required this.address,
    required this.name,
    required this.symbol,
    required this.decimal,
    required this.totalSupply,
    required this.url,
  });

  BigInt get powDecimal => BigInt.from(pow(10, decimal));

  String get getIpfs => "https://$url.ipfs.dweb.link/Content-Disposition";
}


// https://bafybeiawnmgzuxssirzmhfsyjoibwugx5vmli4tlbzxhgeh4qidqkac5ai.ipfs.dweb.link/Content-Disposition