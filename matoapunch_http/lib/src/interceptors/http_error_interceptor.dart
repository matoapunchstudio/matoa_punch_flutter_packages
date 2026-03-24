import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:matoapunch_http/src/enums/connection_result_status.dart';
import 'package:matoapunch_http/src/exceptions/response_exception.dart';

/// Intercepts failed HTTP responses
/// and normalizes them into [ResponseException].
class HttpErrorInterceptor implements Interceptor {
  @override
  Future<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    try {
      final response = await chain.proceed(chain.request);

      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        final bodyString = response.bodyString;

        throw ResponseException(
          status: ConnectionResultStatus.error,
          code: statusCode,
          httpCode: statusCode,
          message: _extractMessage(bodyString, statusCode),
          body: bodyString,
        );
      }

      return response;
    } on SocketException catch (e, s) {
      throw ResponseException(
        status: ConnectionResultStatus.noInternet,
        code: 1101,
        message: e.message,
        stackTrace: s,
      );
    } on HandshakeException catch (e, s) {
      throw ResponseException(
        status: ConnectionResultStatus.noInternet,
        code: 1102,
        message: e.message,
        stackTrace: s,
      );
    } on TimeoutException catch (e, s) {
      throw ResponseException(
        status: ConnectionResultStatus.timeout,
        code: 1103,
        message: e.message ?? 'Request timed out',
        stackTrace: s,
      );
    } on ResponseException {
      rethrow;
    } on Exception catch (e, s) {
      throw ResponseException(
        status: ConnectionResultStatus.error,
        code: 1100,
        message: e.toString(),
        stackTrace: s,
      );
    }
  }

  String _extractMessage(String bodyString, int statusCode) {
    try {
      final decoded = jsonDecode(bodyString);
      if (decoded case {
        'message': final String message,
      } when message.isNotEmpty) {
        return message;
      }
    } on FormatException {
      // Fall through to the default message for non-JSON responses.
    }

    return 'HTTP Error with status code $statusCode';
  }
}
