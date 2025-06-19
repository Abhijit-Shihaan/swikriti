import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.shihaantech.net';

  static Future<http.Response> authUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/User/AuthUser');

      print('Making API call to: $url'); // Debug log
      print('Request body: ${jsonEncode({'email': email, 'password': password})}'); // Debug log

      final response = await http.put(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          // Add User-Agent header for better compatibility
          'User-Agent': 'Flutter App',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 30), // Add timeout
        onTimeout: () {
          throw Exception('Request timeout - please check your internet connection');
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      return response;
    } catch (e) {
      print('API Error: $e'); // Debug log
      rethrow; // Re-throw to handle in UI
    }
  }
}