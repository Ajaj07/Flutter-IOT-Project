import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.4.1';
  static const Duration timeout = Duration(seconds: 10);
  static const int maxRetries = 3;

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _makeRequest(() => _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache',
      },
      body: jsonEncode(body),
    ).timeout(timeout));
  }

  Future<Map<String, dynamic>> _makeRequest(
    Future<http.Response> Function() request,
  ) async {
    Exception? lastException;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await request();
        
        if (response.statusCode == 200) {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } else {
          throw ServerException(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}',
            response.statusCode,
          );
        }
      } on SocketException catch (e) {
        lastException = NetworkException('Network connection failed: ${e.message}');
      } on TimeoutException catch (e) {
        lastException = NetworkException('Request timeout: ${e.message}');
      } on FormatException catch (e) {
        lastException = ServerException('Invalid JSON response: ${e.message}', 0);
      } catch (e) {
        lastException = NetworkException('Unexpected error: $e');
      }

      if (attempt < maxRetries) {
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    throw lastException!;
  }

  void dispose() {
    _client.close();
  }
} 