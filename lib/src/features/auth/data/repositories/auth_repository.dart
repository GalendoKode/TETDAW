import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';
import '../sources/auth_api_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  final localStorage = ref.watch(localStorageServiceProvider);
  return AuthRepository(apiService, localStorage);
});

class AuthRepository {
  final AuthApiService _apiService;
  final LocalStorageService _localStorage;

  AuthRepository(this._apiService, this._localStorage);

  Future<void> login(String email) async {
    try {
      final response = await _apiService.login(email);

      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }

      if (response.containsKey('data')) {
        await _localStorage.saveSession(response['data']);
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _localStorage.deleteSession();
  }
  
  bool isLoggedIn() {
    return _localStorage.isSessionValid();
  }
}
