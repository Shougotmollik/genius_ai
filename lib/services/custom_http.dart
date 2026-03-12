import 'dart:convert';
import 'package:genius_ai/services/http_logger.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/constants/credential.dart';
import 'package:genius_ai/services/local_storage.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:genius_ai/utils/check_for_internet.dart';

class CustomHttpResult {
  final dynamic data;
  final int status_code;
  final String? error;
  final bool ok;

  const CustomHttpResult({
    this.data,
    required this.status_code,
    this.error,
    required this.ok,
  });
}

enum _HttpMethod { post, put, patch, delete }

class CustomHttp {
  CustomHttp._();

  static Future<CustomHttpResult> get({
    required String endpoint,
    bool show_floating_error = true,
    bool need_auth = true,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
  }) async {
    if (!await hasInternet(showError: true)) {
      return const CustomHttpResult(
        ok: false,
        status_code: -1,
        error: 'No internet! Please check your internet connection.',
      );
    }

    late String url;

    try {
      final resolved_headers = await _build_headers(
        need_auth: need_auth,
        extra: headers,
      );

      if (resolved_headers == null) {
        return const CustomHttpResult(ok: false, status_code: 401);
      }

      url = _build_url('${AppCredentials.domain}/api$endpoint', queries);

      HttpLogger.logRequest(method: 'GET', url: url, headers: resolved_headers);

      final response = await http.get(
        Uri.parse(url),
        headers: resolved_headers,
      );

      return _handle_response(response, show_floating_error);
    } catch (e, stackTrace) {
      _log_error('GET', url, e, stackTrace);

      return CustomHttpResult(status_code: -2, error: e.toString(), ok: false);
    }
  }

  static Future<CustomHttpResult> post({
    required String endpoint,
    bool add_api_prefix = true,
    Map<String, String>? headers,
    dynamic body,
    bool show_floating_error = true,
    bool need_auth = true,
    Map<String, dynamic>? queries,
  }) async {
    return _send_with_body(
      method: _HttpMethod.post,
      endpoint: endpoint,
      add_api_prefix: add_api_prefix,
      headers: headers,
      body: body,
      show_floating_error: show_floating_error,
      need_auth: need_auth,
      queries: queries,
    );
  }

  static Future<CustomHttpResult> put({
    required String endpoint,
    required bool add_api_prefix,
    Map<String, String>? headers,
    dynamic body,
    bool show_floating_error = true,
    bool need_auth = true,
    Map<String, dynamic>? queries,
  }) async {
    return _send_with_body(
      method: _HttpMethod.put,
      endpoint: endpoint,
      add_api_prefix: add_api_prefix,
      headers: headers,
      body: body,
      show_floating_error: show_floating_error,
      need_auth: need_auth,
      queries: queries,
    );
  }

  static Future<CustomHttpResult> patch({
    required String endpoint,
    bool add_api_prefix = true,
    Map<String, String>? headers,
    dynamic body,
    bool show_floating_error = true,
    bool need_auth = true,
    Map<String, dynamic>? queries,
  }) async {
    return _send_with_body(
      method: _HttpMethod.patch,
      endpoint: endpoint,
      add_api_prefix: add_api_prefix,
      headers: headers,
      body: body,
      show_floating_error: show_floating_error,
      need_auth: need_auth,
      queries: queries,
    );
  }

  static Future<CustomHttpResult> delete({
    required String endpoint,
    bool add_api_prefix = true,
    Map<String, String>? headers,
    dynamic body,
    bool show_floating_error = true,
    bool need_auth = true,
    Map<String, dynamic>? queries,
  }) async {
    return _send_with_body(
      method: _HttpMethod.delete,
      endpoint: endpoint,
      add_api_prefix: add_api_prefix,
      headers: headers,
      body: body,
      show_floating_error: show_floating_error,
      need_auth: need_auth,
      queries: queries,
    );
  }

  static Future<CustomHttpResult> multipart({
    required String endpoint,
    required String fieldName,
    required String filePath,
    String method = 'POST',
    bool need_auth = true,
    bool show_floating_error = true,
    Map<String, String>? headers,
  }) async {
    if (!await hasInternet(showError: true)) {
      return const CustomHttpResult(
        ok: false,
        status_code: -1,
        error: 'No internet! Please check your internet connection.',
      );
    }

    String url = '';

    try {
      final resolved_headers = await _build_headers(
        need_auth: need_auth,
        extra: headers,
      );

      if (resolved_headers == null) {
        return const CustomHttpResult(ok: false, status_code: 401);
      }

      url = '${AppCredentials.domain}/api$endpoint';

      final uri = Uri.parse(url);

      final request = http.MultipartRequest(method, uri);

      request.headers.addAll(resolved_headers);

      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      // Multipart should NOT have JSON content type
      request.headers.remove('Content-Type');

      HttpLogger.logRequest(
        method: method,
        url: url,
        headers: resolved_headers,
        body: {'file': filePath},
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handle_response(response, show_floating_error);
    } catch (e, stackTrace) {
      _log_error(method, url, e, stackTrace);

      return CustomHttpResult(status_code: -2, error: e.toString(), ok: false);
    }
  }

  static Future<CustomHttpResult> _send_with_body({
    required _HttpMethod method,
    required String endpoint,
    required bool add_api_prefix,
    Map<String, String>? headers,
    dynamic body,
    required bool show_floating_error,
    required bool need_auth,
    Map<String, dynamic>? queries,
  }) async {
    if (!await hasInternet(showError: true)) {
      return const CustomHttpResult(
        ok: false,
        status_code: -1,
        error: 'No internet! Please check your internet connection.',
      );
    }
    late String url;

    try {
      final resolved_headers = await _build_headers(
        need_auth: need_auth,
        extra: headers,
      );
      if (resolved_headers == null)
        return const CustomHttpResult(ok: false, status_code: 401);

      final prefix = add_api_prefix ? '/api' : '';
      url = _build_url('${AppCredentials.domain}$prefix$endpoint', queries);

      // Log Request
      HttpLogger.logRequest(
        method: method.name.toUpperCase(),
        url: url,
        headers: resolved_headers,
        body: body,
      );

      final encoded_body = jsonEncode(body ?? {});
      late http.Response response;

      switch (method) {
        case _HttpMethod.post:
          response = await http.post(
            Uri.parse(url),
            body: encoded_body,
            headers: resolved_headers,
          );
          break;
        case _HttpMethod.put:
          response = await http.put(
            Uri.parse(url),
            body: encoded_body,
            headers: resolved_headers,
          );
          break;
        case _HttpMethod.patch:
          response = await http.patch(
            Uri.parse(url),
            body: encoded_body,
            headers: resolved_headers,
          );
          break;
        case _HttpMethod.delete:
          response = await http.delete(
            Uri.parse(url),
            body: encoded_body,
            headers: resolved_headers,
          );
          break;
      }

      return _handle_response(response, show_floating_error);
    } catch (e, stackTrace) {
      _log_error(method.name.toUpperCase(), url, e, stackTrace);

      return CustomHttpResult(status_code: -2, error: e.toString(), ok: false);
    }
  }

  static Future<Map<String, String>?> _build_headers({
    required bool need_auth,
    Map<String, String>? extra,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (need_auth) {
      final valid_till = await LocalStorage.access_token_valid_till.get();
      if (valid_till == null ||
          valid_till < DateTime.now().millisecondsSinceEpoch) {
        if (!await _refresh_access_token()) {
          Get.toNamed(RouteNames.onBoarding);
          return null;
        }
      }
      final access_token = await LocalStorage.access_token.get();
      headers['Authorization'] = 'Bearer $access_token';
    }
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  static Future<bool> _refresh_access_token() async {
    // ... (Keep your existing token refresh logic)
    return true; // Simplified for length
  }

  static String _build_url(String base, Map<String, dynamic>? queries) {
    if (queries == null || queries.isEmpty) return base;
    final buffer = StringBuffer('$base?');
    queries.forEach((key, value) => buffer.write('$key=$value&'));
    return buffer.toString().substring(0, buffer.length - 1);
  }

  static CustomHttpResult _handle_response(
    http.Response response,
    bool show_error,
  ) {
    final method = response.request?.method ?? 'UNKNOWN';
    final url = response.request?.url.toString() ?? 'UNKNOWN';

    dynamic data;
    try {
      data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      data = response.body;
    }

    // Call Response Logger
    HttpLogger.logResponse(
      method: method,
      url: url,
      statusCode: response.statusCode,
      body: data,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CustomHttpResult(
        ok: true,
        status_code: response.statusCode,
        data: data,
      );
    }

    final message = _parse_error_message(response);
    if (show_error) AppSnackbar.show(message: message);
    return CustomHttpResult(
      status_code: response.statusCode,
      error: message,
      ok: false,
    );
  }

  static String _parse_error_message(http.Response response) {
    try {
      return jsonDecode(response.body)['message'] ?? 'Error';
    } catch (_) {
      return 'Error';
    }
  }

  static void _log_error(
    String method,
    String url,
    Object error,
    StackTrace stackTrace,
  ) {
    HttpLogger.logError(url: url, error: error, stackTrace: stackTrace);
  }
}
