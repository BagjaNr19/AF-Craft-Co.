import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/api_constants.dart';
import '../utils/token_storage.dart';

/// Exception thrown when an API call fails.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Central HTTP service that handles all REST API communication.
class ApiService {
  // ── Singleton ─────────────────────────────────────────────────────────────────
  ApiService._();
  static final ApiService instance = ApiService._();

  final http.Client _client = http.Client();

  // ── Header Builders ───────────────────────────────────────────────────────────
  Future<Map<String, String>> _headers({bool requiresAuth = true}) async {
    final headers = <String, String>{
      ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
    };

    if (requiresAuth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers[ApiConstants.authHeader] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ── Response Handler ──────────────────────────────────────────────────────────
  dynamic _handleResponse(http.Response response) {
    final body = _decodeBody(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = _extractMessage(body) ??
        'Request failed with status ${response.statusCode}';

    throw ApiException(message, statusCode: response.statusCode);
  }

  dynamic _decodeBody(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String? _extractMessage(dynamic body) {
    if (body is Map) {
      return body['message']?.toString() ??
          body['error']?.toString() ??
          body['msg']?.toString();
    }
    return body?.toString();
  }

  // ── GET ───────────────────────────────────────────────────────────────────────
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      var uri = Uri.parse(ApiConstants.fullUrl(endpoint));
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await _client
          .get(uri, headers: await _headers(requiresAuth: requiresAuth))
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet');
    } on HttpException {
      throw const ApiException('Terjadi kesalahan jaringan');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  // ── POST ──────────────────────────────────────────────────────────────────────
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.fullUrl(endpoint));

      final response = await _client
          .post(
            uri,
            headers: await _headers(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet');
    } on HttpException {
      throw const ApiException('Terjadi kesalahan jaringan');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  // ── PUT ───────────────────────────────────────────────────────────────────────
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.fullUrl(endpoint));

      final response = await _client
          .put(
            uri,
            headers: await _headers(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet');
    } on HttpException {
      throw const ApiException('Terjadi kesalahan jaringan');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  // ── PATCH ─────────────────────────────────────────────────────────────────────
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.fullUrl(endpoint));

      final response = await _client
          .patch(
            uri,
            headers: await _headers(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet');
    } on HttpException {
      throw const ApiException('Terjadi kesalahan jaringan');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────────
  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.fullUrl(endpoint));

      final response = await _client
          .delete(uri, headers: await _headers(requiresAuth: requiresAuth))
          .timeout(ApiConstants.connectTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet');
    } on HttpException {
      throw const ApiException('Terjadi kesalahan jaringan');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
