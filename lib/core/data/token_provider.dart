import 'package:griot_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenProvider {
  Future<String> getToken();
  Future<void> destroyToken();
}

class TokenProviderImpl implements TokenProvider {
  final SharedPreferences sharedPreferences;

  TokenProviderImpl({required this.sharedPreferences});

  @override
  Future<String> getToken() async {
    final String? tokenString = sharedPreferences.getString('token');

    if (tokenString == null) {
      throw NoTokenException();
    } else {
      return 'Token $tokenString';
    }
  }

  @override
  Future<bool> destroyToken() async {
    final String? tokenString = sharedPreferences.getString('token');
    if (tokenString == null) {
      throw NoTokenException();
    } else {
      sharedPreferences.remove('token');
      return true;
    }
  }
}
