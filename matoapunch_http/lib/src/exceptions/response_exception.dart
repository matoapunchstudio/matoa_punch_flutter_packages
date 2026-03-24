import 'package:flutter/foundation.dart';
import 'package:matoapunch_http/src/enums/connection_result_status.dart';

/// Structured exception returned by the HTTP layer.
@immutable
class ResponseException implements Exception {
  /// Creates a response exception with request and transport details.
  const ResponseException({
    required this.status,
    required this.code,
    required this.message,
    this.httpCode,
    this.stackTrace,
    this.body = '',
  });

  /// High-level connection status for the failed request.
  final ConnectionResultStatus status;

  /// Internal package error code.
  final num code;

  /// HTTP status code associated with the failure.
  final num? httpCode;

  /// Human-readable error message.
  final String message;

  /// Stack trace captured when the exception was created.
  final StackTrace? stackTrace;

  /// Raw response body when available.
  final String body;

  @override
  String toString() => message;
}
