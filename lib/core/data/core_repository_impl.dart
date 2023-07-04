import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:griot_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreRepositoryImpl implements CoreRepository {
  CoreRepositoryImpl();

  @override
  Future<int> performTokenExceptionPolicies() async {
    final authBloc = sl<AuthBlocBloc>();
    // Destroy the token
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // Notify the presentation layer
    authBloc.add(TokenFailedEvent());

    return 0;
  }
}
