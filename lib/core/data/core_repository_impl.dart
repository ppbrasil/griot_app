import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreRepositoryImpl implements CoreRepository {
  final SharedPreferences sharedPreferences;

  CoreRepositoryImpl({required this.sharedPreferences});

  @override
  Future<int> performTokenExceptionPolicies() async {
    final authBloc = sl<AuthBlocBloc>();
    // Destroy the token
    sharedPreferences.remove('token');

    // Notify the presentation layer
    authBloc.add(TokenFailedEvent());

    return 0;
  }

  @override
  Future<bool> performNotifyNoInternetConnection() async {
    final connectivityBloc = sl<ConnectivityBlocBloc>();
    connectivityBloc.add(LostConnectivityEvent());
    return true;
  }
}
