import 'dart:convert';
import 'package:flutter/foundation.dart';

class HttpLogger {
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';

  /// ================================
  /// 🚀 REQUEST
  /// ================================
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    debugPrint('\n$_cyan━━━━━━━━━━ 🚀 REQUEST ━━━━━━━━━━$_reset');
    debugPrint('$_cyan➜ URL: $_reset$url');
    debugPrint('$_cyan➜ METHOD: $_magenta$method$_reset');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('$_cyan➜ HEADERS:$_reset');
      _printPretty(headers, _cyan);
    }

    if (body != null) {
      debugPrint('$_cyan➜ BODY:$_reset');
      _printPretty(body, _cyan);
    }

    debugPrint('$_cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset\n');
  }

  /// ================================
  /// ✅ RESPONSE
  /// ================================
  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    required dynamic body,
  }) {
    if (!kDebugMode) return;

    final bool isSuccess = statusCode >= 200 && statusCode < 300;
    final color = isSuccess ? _green : _red;
    final title = isSuccess ? '✅ SUCCESS RESPONSE' : '❌ ERROR RESPONSE';

    debugPrint('\n$color━━━━━━━━━━ $title ━━━━━━━━━━$_reset');
    debugPrint('$color➜ URL: $_reset$url');
    debugPrint('$color➜ STATUS: $statusCode$_reset');

    if (body != null) {
      debugPrint('$color➜ RESPONSE BODY:$_reset');
      _printPretty(body, color);
    }

    debugPrint('$color━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset\n');
  }

  /// ================================
  /// ❌ NETWORK ERROR (Timeout / Socket / Exception)
  /// ================================
  static void logError({
    required String url,
    required dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    debugPrint('\n$_red━━━━━━━━━━ ❌ NETWORK ERROR ━━━━━━━━━━$_reset');
    debugPrint('$_red➜ URL: $_reset$url');
    debugPrint('$_red➜ ERROR TYPE: ${error.runtimeType}$_reset');
    debugPrint('$_red➜ MESSAGE: $error$_reset');

    if (stackTrace != null) {
      debugPrint('$_yellow➜ STACK TRACE:$_reset');
      debugPrint(stackTrace.toString());
    }

    debugPrint('$_red━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_reset\n');
  }

  /// ================================
  /// 🔍 Pretty JSON Printer
  /// ================================
  static void _printPretty(dynamic data, String color) {
    try {
      dynamic object = data;

      if (data is String) {
        try {
          object = jsonDecode(data);
        } catch (_) {}
      }

      final prettyJson = const JsonEncoder.withIndent('  ').convert(object);

      _printLongString(prettyJson, color);
    } catch (e) {
      _printLongString(data.toString(), color);
    }
  }

  /// Prevents debugPrint cut-off (large responses)
  static void _printLongString(String text, String color) {
    const int chunkSize = 800;

    for (var i = 0; i < text.length; i += chunkSize) {
      final chunk = text.substring(
        i,
        i + chunkSize > text.length ? text.length : i + chunkSize,
      );
      debugPrint('$color$chunk$_reset');
    }
  }
}
