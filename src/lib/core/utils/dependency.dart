import 'package:get/get.dart';
import 'package:src/app/data/provider/ipfs_provider.dart';
import 'package:src/app/data/provider/web3_provider.dart';
import 'package:src/app/data/repository_impl/connect_provider_repo_impl.dart';
import 'package:src/app/data/repository_impl/pool_sale_token_repo_impl.dart';
import 'package:src/app/domains/connect_provider/usecase.dart';
import 'package:src/app/domains/pool_sale_token/usecase.dart';

class Dependency {
  static init() async {
    // init web3 provider
    Get.lazyPut(() => Web3ConnectProvider());
    // init web3 provider
    Get.lazyPut(() => IPFSProvider());
    // pool domain follow add dependency
    Get.lazyPut(() => PoolSaleTokenRepositoryImpl(
          Get.find<Web3ConnectProvider>(),
          Get.find<IPFSProvider>(),
        ));
    Get.lazyPut<PoolSaleTokenUseCase>(
        () => PoolSaleTokenUseCase(Get.find<PoolSaleTokenRepositoryImpl>()));
    // connect provider domain follow add dependency
    Get.lazyPut(
        () => ConnectProviderRepositoryImpl(Get.find<Web3ConnectProvider>()));
    Get.lazyPut<ConnectProviderUseCase>(() =>
        ConnectProviderUseCase(Get.find<ConnectProviderRepositoryImpl>()));
  }
}
