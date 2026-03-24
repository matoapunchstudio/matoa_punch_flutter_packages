import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_http/matoapunch_http.dart';

void main() {
  group('ResponseException', () {
    test('returns message from toString', () {
      const exception = ResponseException(
        status: ConnectionResultStatus.error,
        code: 1100,
        message: 'Request failed',
      );

      expect(exception.toString(), 'Request failed');
    });

    test('allows null httpCode for transport failures', () {
      const exception = ResponseException(
        status: ConnectionResultStatus.noInternet,
        code: 1101,
        message: 'No internet connection',
      );

      expect(exception.httpCode, isNull);
    });
  });
}
