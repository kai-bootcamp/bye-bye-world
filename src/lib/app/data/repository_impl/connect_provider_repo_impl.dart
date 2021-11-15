import 'package:src/app/data/provider/web3_provider.dart';
import 'package:src/app/domains/connect_provider/repository.dart';

class ConnectProviderRepositoryImpl implements ConnectProviderRepository {
  ConnectProviderRepositoryImpl(this._web3);
  final Web3ConnectProvider _web3;

  @override
  Future<void> connectWithProvider() async {
    return await _web3.connectToMetamask();
  }
}
