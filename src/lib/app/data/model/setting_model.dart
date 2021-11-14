import 'dart:convert';

import 'package:src/app/domains/setting/entities/setting_entity.dart';

class SettingModel extends SettingEntity {
  SettingModel({
    required String languageCode,
    required String currencyCode,
    required bool isLightTheme,
  }) : super(
          currencyCode: currencyCode,
          isLightTheme: isLightTheme,
          languageCode: languageCode,
        );

  factory SettingModel.fromEntity(SettingEntity entity) {
    return SettingModel(
      languageCode: entity.languageCode,
      currencyCode: entity.currencyCode,
      isLightTheme: entity.isLightTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': languageCode,
      'currency': currencyCode,
      'isLightTheme': isLightTheme,
    };
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      languageCode: map['language'],
      currencyCode: map['currency'],
      isLightTheme: map['isLightTheme'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingModel.fromJson(String source) =>
      SettingModel.fromMap(json.decode(source));
}
