import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';

// Define any custom types here. For example, if Token is a custom type, you might need to define it.

abstract class AuthRepository {
  Future<Either<Failure, Token>> login({
    required String username,
    required String password,
  });
}
