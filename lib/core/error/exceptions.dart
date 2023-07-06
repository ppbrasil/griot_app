class ServerException implements Exception {}

class MediaServiceException implements Exception {}

class CacheExceptions implements Exception {}

class InvalidTokenException implements Exception {
  final String message;

  InvalidTokenException([this.message = "Invalid token"]);

  @override
  String toString() => 'InvalidTokenException: $message';
}

class NoTokenException implements Exception {}

class NoMainAccountException implements Exception {}

class MediaServiceError implements Exception {}

class NetworkException implements Exception {}
