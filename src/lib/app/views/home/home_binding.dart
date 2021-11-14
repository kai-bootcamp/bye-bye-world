import 'package:get/instance_manager.dart';
import 'package:src/app/domains/setting/use_cases/setting_use_case.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find<SettingUseCase>()));
  }
}
