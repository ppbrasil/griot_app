class ServerException implements Exception {}

class CacheExceptions implements Exception {}

class InvalidTokenException implements Exception {
  final String message;

  InvalidTokenException([this.message = "Invalid token"]);

  @override
  String toString() => 'InvalidTokenException: $message';
}
