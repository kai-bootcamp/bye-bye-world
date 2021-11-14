import 'package:src/app/domains/connect_provider/entity.dart';
import 'package:src/app/domains/connect_provider/repository.dart';

class ConnectProviderUseCase {
  ConnectProviderUseCase(this._repo);

  final ConnectProviderRepository _repo;

  final ConnectProviderEntity connectProviderEntity = ConnectProviderEntity(
    isConnected: false,
  );

  Future<void> connectWallet() async {
    connectProviderEntity.isConnected = await _repo.connectWithProvider();
  }

  bool get isConnected => connectProviderEntity.isConnected;
}
