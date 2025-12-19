import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

class AuthApiService {
  static const String _baseUrl = 'https://script.google.com/macros/s/AKfycbw4s_1-6gT-Egnk_pTABuh-jI94LNP8NGUxNHin3J-0Q_zJhkIv8rqNsg-kVPKnqyc/exec';

  Future<Map<String, dynamic>> login(String email) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode({
          'action': 'userLogin',
          'email': email,
        }),
        // GAS sometimes needs these headers to handle POST data correctly if it's not a simple form
        // But usually plain text or no header works best for GAS `doPost(e)` depending on implementation.
        // User said "Request Body ... in JSON format".
        // Often GAS requires Content-Type: application/json but sometimes it fails with CORS if triggered from browser.
        // Since this is Flutter, mobile is fine, but Web might have CORS issues.
        // I will assume standard JSON content type.
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // GAS might return a 200 with error inside JSON
        final data = jsonDecode(response.body);
        return data as Map<String, dynamic>;
      } else if (response.statusCode == 302) {
         // Handle redirect manually if needed, but client usually does.
         throw Exception('Redirect returned from API');
      } else {
        throw Exception('Failed to connect to API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
