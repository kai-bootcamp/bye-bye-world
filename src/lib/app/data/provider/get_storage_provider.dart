import 'package:get_storage/get_storage.dart';

class GetStorageProvider {
  final GetStorage _storageBox = GetStorage();

  String? getData({required String key}) {
    return _storageBox.read<String>(key);
  }

  Future<void> writeData({
    required String key,
    required String value,
  }) async {
    await _storageBox.write(key, value);
  }
}
