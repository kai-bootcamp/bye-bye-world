import 'package:src/app/domains/connect_provider/entity.dart';
import 'package:src/app/domains/connect_provider/repository.dart';

class ConnectProviderUseCase {
  ConnectProviderUseCase(this._repo);

  final ConnectProviderRepository _repo;

  final ConnectProviderEntity connectProviderEntity = ConnectProviderEntity(
    isConnected: false,
    isWrongConnect: true,
  );

  Future<void> connectWallet() async {
    await _repo.connectWithProvider();
  }

  void updateConnect(
    bool isConnected,
    bool isWrongConnect,
  ) async {
    connectProviderEntity.isConnected = isConnected;
    connectProviderEntity.isWrongConnect = isWrongConnect;
  }

  bool get isConnected => connectProviderEntity.isConnected;
  bool get isWrongConnect => connectProviderEntity.isWrongConnect;
}
