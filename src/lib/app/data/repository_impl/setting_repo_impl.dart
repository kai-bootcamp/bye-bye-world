import 'dart:developer';

import 'package:src/app/data/model/setting_model.dart';
import 'package:src/app/data/provider/get_storage_provider.dart';
import 'package:src/app/domains/setting/entities/setting_entity.dart';
import 'package:src/app/domains/setting/repos/setting_repo.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(this._provider);

  final GetStorageProvider _provider;

  @override
  SettingModel getSettingApp({required String key}) {
    final result = _provider.getData(key: key);
    if (result != null) {
      return SettingModel.fromJson(result);
    } else {
      return SettingModel(
        languageCode: 'en',
        currencyCode: 'en_US',
        isLightTheme: true,
      );
    }
  }

  @override
  Future<void> updateSettingApp({
    required String key,
    required SettingEntity entity,
  }) async {
    final settingModel = SettingModel.fromEntity(entity);
    _provider.writeData(key: key, value: settingModel.toJson());
  }
}
