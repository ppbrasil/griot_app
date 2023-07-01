import 'package:griot_app/core/domain/repositories/core_repository.dart';
import 'package:griot_app/core/presentation/bloc/user_session_bloc_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreRepositoryImpl implements CoreRepository {
  final UserSessionBlocBloc userSessionBloc;

  CoreRepositoryImpl({required this.userSessionBloc});

  @override
  Future<int> performTokenExceptionPolicies() async {
    // Destroy the token
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    // Notify the presentation layer
    userSessionBloc.add(TokenFailedBlocEvent());

    return 0;
  }
}
