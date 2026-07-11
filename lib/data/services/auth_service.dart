import 'package:tranzgoo/data/models/auth_session.dart';
import 'package:tranzgoo/data/services/api_client.dart';
import 'package:tranzgoo/data/services/session_storage.dart';

class AuthService {
  final ApiClient _apiClient;
  final SessionStorage _sessionStorage;

  AuthService({ApiClient? apiClient, SessionStorage? sessionStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _sessionStorage = sessionStorage ?? SessionStorage();

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/api/auth/login', {
      'email': email.trim(),
      'password': password,
    });

    final session = _sessionFromResponse(response);
    await _sessionStorage.saveSession(session);
    return session;
  }

  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post('/api/auth/register', {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
    });

    final session = _sessionFromResponse(response);
    await _sessionStorage.saveSession(session);
    return session;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _apiClient.post('/api/auth/forgot-password', {
      'email': email.trim(),
    });

    final data = response['data'];
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<void> verifyResetCode(String token) async {
    await _apiClient.post('/api/auth/verify-reset-code', {
      'token': token.trim(),
    });
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiClient.post('/api/auth/reset-password', {
      'token': token.trim(),
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });
  }

  AuthSession _sessionFromResponse(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map<String, dynamic>) {
      throw const FormatException('The server did not return session details.');
    }

    return AuthSession.fromJson(data);
  }
}
