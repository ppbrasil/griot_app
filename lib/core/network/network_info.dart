import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  final CoreRepository coreRepository;

  NetworkInfoImpl({
    required this.internetConnectionChecker,
    required this.coreRepository,
  });

  @override
  Future<bool> get isConnected async {
    final hasConnection = await internetConnectionChecker.hasConnection;
    if (hasConnection) {
      return true;
    }
    coreRepository.performNotifyNoInternetConnection();
    return false;
  }
}
