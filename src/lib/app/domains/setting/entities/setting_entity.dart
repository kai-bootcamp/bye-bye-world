class SettingEntity {
  String languageCode;
  String currencyCode;
  bool isLightTheme;

  SettingEntity({
    required this.languageCode,
    required this.currencyCode,
    required this.isLightTheme,
  });

  static const keyStorage = 'setting app';

  bool get isVietnamese => languageCode == 'vi';
}
