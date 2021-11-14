import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/domains/setting/use_cases/setting_use_case.dart';
import 'package:src/core/themes/theme.dart';

enum UpdateHomePage {
  switchButtonTheme,
  switchButtonLanguage,
}

class HomeController extends GetxController {
  HomeController(this._settingUseCase);
  final SettingUseCase _settingUseCase;

  void changeThemeData() async {
    await _settingUseCase.updateThemeApp();
    update([UpdateHomePage.switchButtonTheme]);
    Get.changeTheme(isLightMode ? AppTheme.light : AppTheme.dark);
  }

  void changeLanguageApp() async {
    final _languageCode =
        _settingUseCase.settingEntity.isVietnamese ? 'en' : 'vi';
    await _settingUseCase.updateLanguageApp(languageCode: _languageCode);
    update([UpdateHomePage.switchButtonLanguage]);
    Get.updateLocale(Locale(languageCode));
  }

  bool get isLightMode => _settingUseCase.settingEntity.isLightTheme;
  String get languageCode => _settingUseCase.settingEntity.languageCode;
  bool get isVietNamese => _settingUseCase.settingEntity.isVietnamese;
}
