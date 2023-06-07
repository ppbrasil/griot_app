import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {  
  /// Calls the http://app.griot.me/api/user/auth endpoint 
  ///
  /// Throws a [AuthException] for all error codes.
  ///
  Future<TokenModel> login(String email, String password);
  Future<void> storeToken(TokenModel tokenToStore);
}


class AuthRemoteDataSourceImpl extends AuthRemoteDataSource{
  @override
  Future<TokenModel> login(String email, String password) {
    throw ServerException();
  }

  @override
  Future<void> storeToken(TokenModel tokenToStore) {
    throw ServerException();
  }

}