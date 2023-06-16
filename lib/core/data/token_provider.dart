import 'package:griot_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenProvider {
  Future<String> getToken();
}

class TokenProviderImpl implements TokenProvider {
  @override
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tokenString = prefs.getString('token');

    if (tokenString == null) {
      throw NoTokenException();
    } else {
      return 'Token $tokenString';
    }
  }
}
