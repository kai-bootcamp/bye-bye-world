import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:src/app/domains/setting/use_cases/setting_use_case.dart';
import 'package:src/core/themes/theme.dart';

class InitialService extends GetxService {
  InitialService(this._settingUseCase);
  final SettingUseCase _settingUseCase;

  Future<InitialService> init() async {
    _settingUseCase.getSettingApp();
    return this;
  }

  ThemeData theme() {
    return _settingUseCase.settingEntity.isLightTheme
        ? AppTheme.light
        : AppTheme.dark;
  }

  Locale get locale => Locale(_settingUseCase.settingEntity.languageCode);
}
