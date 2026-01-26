abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  final int statusCode;
  const ServerException(String message, this.statusCode) : super(message);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
} 