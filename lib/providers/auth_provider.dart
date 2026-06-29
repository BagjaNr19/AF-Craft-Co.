import 'package:flutter/foundation.dart';

import '../core/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────────────────────
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  // ── Getters ───────────────────────────────────────────────────────────────────
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // ── Init ──────────────────────────────────────────────────────────────────────
  Future<void> checkAuthStatus() async {
    _setStatus(AuthStatus.loading);
    try {
      final hasToken = await TokenStorage.hasToken();
      if (!hasToken) {
        _setStatus(AuthStatus.unauthenticated);
        return;
      }

      // Try fetching current user profile to validate token
      final response = await ApiService.instance.get(ApiConstants.me);
      final userData = response['data'] ?? response['user'] ?? response;
      _user = UserModel.fromJson(userData as Map<String, dynamic>);
      _setStatus(AuthStatus.authenticated);
    } catch (_) {
      // Token expired or invalid
      await TokenStorage.clearAll();
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setLoading();
    try {
      final response = await ApiService.instance.post(
        ApiConstants.login,
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      final token = _extractToken(response);
      if (token == null) {
        _setError('Token tidak ditemukan dalam respons');
        return false;
      }

      await TokenStorage.saveToken(token);

      final userData = response['data'] ??
          response['user'] ??
          (response is Map ? response : null);
      if (userData != null) {
        _user = UserModel.fromJson(userData as Map<String, dynamic>);
        await _cacheUserData(_user!);
      }

      _setStatus(AuthStatus.authenticated);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Login gagal. Periksa email dan password Anda.');
      return false;
    }
  }

  // ── Register ──────────────────────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _setLoading();
    try {
      final body = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      };
      if (phone != null && phone.isNotEmpty) body['phone'] = phone;

      final response = await ApiService.instance.post(
        ApiConstants.register,
        body: body,
        requiresAuth: false,
      );

      final token = _extractToken(response);
      if (token != null) {
        await TokenStorage.saveToken(token);

        final userData = response['data'] ?? response['user'];
        if (userData != null) {
          _user = UserModel.fromJson(userData as Map<String, dynamic>);
          await _cacheUserData(_user!);
        }
        _setStatus(AuthStatus.authenticated);
      } else {
        // Some APIs require login after register
        _setStatus(AuthStatus.unauthenticated);
      }
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Registrasi gagal. Coba lagi.');
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await ApiService.instance.post(ApiConstants.logout);
    } catch (_) {
      // Ignore logout API error
    } finally {
      await TokenStorage.clearAll();
      _user = null;
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Refresh User ──────────────────────────────────────────────────────────────
  Future<void> refreshUser() async {
    try {
      final response = await ApiService.instance.get(ApiConstants.me);
      final userData = response['data'] ?? response['user'] ?? response;
      _user = UserModel.fromJson(userData as Map<String, dynamic>);
      await _cacheUserData(_user!);
      notifyListeners();
    } catch (_) {
      // Silently fail
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  String? _extractToken(dynamic response) {
    if (response is Map) {
      return response['token']?.toString() ??
          response['access_token']?.toString() ??
          response['accessToken']?.toString();
    }
    return null;
  }

  Future<void> _cacheUserData(UserModel user) async {
    await TokenStorage.saveUserData(
      userId: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
    );
  }

  void _setLoading() {
    _errorMessage = null;
    _setStatus(AuthStatus.loading);
  }

  void _setError(String message) {
    _errorMessage = message;
    _setStatus(
      _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
