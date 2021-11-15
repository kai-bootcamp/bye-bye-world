import 'package:get/instance_manager.dart';
import 'package:src/app/domains/connect_provider/usecase.dart';
import 'package:src/app/domains/pool_sale_token/usecase.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
          Get.find<ConnectProviderUseCase>(),
          Get.find<PoolSaleTokenUseCase>(),
        ));
  }
}
