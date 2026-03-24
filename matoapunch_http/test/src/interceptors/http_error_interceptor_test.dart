import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matoapunch_http/matoapunch_http.dart';

void main() {
  group('HttpErrorInterceptor', () {
    late HttpErrorInterceptor interceptor;
    late Request request;

    setUp(() {
      interceptor = HttpErrorInterceptor();
      request = Request(
        'GET',
        Uri.parse('/users'),
        Uri.parse('https://example.com'),
      );
    });

    test('returns successful responses unchanged', () async {
      final response = Response<String>(
        http.Response('ok', 200),
        'ok',
      );

      final result = await interceptor.intercept(_FakeChain<String>(
        request: request,
        onProceed: (_) async => response,
      ));

      expect(result, same(response));
    });

    test('wraps non-2xx responses with message from body', () async {
      final response = Response<String>(
        http.Response('{"message":"Unauthorized"}', 401),
        null,
      );

      await expectLater(
        () => interceptor.intercept(_FakeChain<String>(
          request: request,
          onProceed: (_) async => response,
        )),
        throwsA(
          isA<ResponseException>()
              .having((e) => e.status, 'status', ConnectionResultStatus.error)
              .having((e) => e.code, 'code', 401)
              .having((e) => e.httpCode, 'httpCode', 401)
              .having((e) => e.message, 'message', 'Unauthorized')
              .having(
                (e) => e.body,
                'body',
                '{"message":"Unauthorized"}',
              ),
        ),
      );
    });

    test('falls back to generic message for non-json error bodies', () async {
      final response = Response<String>(
        http.Response('server unavailable', 503),
        null,
      );

      await expectLater(
        () => interceptor.intercept(_FakeChain<String>(
          request: request,
          onProceed: (_) async => response,
        )),
        throwsA(
          isA<ResponseException>().having(
            (e) => e.message,
            'message',
            'HTTP Error with status code 503',
          ),
        ),
      );
    });

    test('does not try to decode plain text containing message', () async {
      final response = Response<String>(
        http.Response('message unavailable', 502),
        null,
      );

      await expectLater(
        () => interceptor.intercept(_FakeChain<String>(
          request: request,
          onProceed: (_) async => response,
        )),
        throwsA(
          isA<ResponseException>()
              .having((e) => e.code, 'code', 502)
              .having((e) => e.httpCode, 'httpCode', 502)
              .having(
                (e) => e.message,
                'message',
                'HTTP Error with status code 502',
              ),
        ),
      );
    });

    test('maps socket exceptions to noInternet errors', () async {
      await expectLater(
        () => interceptor.intercept(_FakeChain<String>(
          request: request,
          onProceed: (_) => throw const SocketException('No route to host'),
        )),
        throwsA(
          isA<ResponseException>()
              .having(
                (e) => e.status,
                'status',
                ConnectionResultStatus.noInternet,
              )
              .having((e) => e.code, 'code', 1101)
              .having((e) => e.httpCode, 'httpCode', isNull)
              .having((e) => e.message, 'message', 'No route to host'),
        ),
      );
    });

    test('maps timeout exceptions to timeout errors', () async {
      await expectLater(
        () => interceptor.intercept(_FakeChain<String>(
          request: request,
          onProceed: (_) => throw TimeoutException('slow network'),
        )),
        throwsA(
          isA<ResponseException>()
              .having(
                (e) => e.status,
                'status',
                ConnectionResultStatus.timeout,
              )
              .having((e) => e.code, 'code', 1103)
              .having((e) => e.httpCode, 'httpCode', isNull)
              .having((e) => e.message, 'message', 'slow network'),
        ),
      );
    });
  });
}

class _FakeChain<BodyType> implements Chain<BodyType> {
  _FakeChain({
    required this.request,
    required this.onProceed,
  });

  @override
  final Request request;

  final FutureOr<Response<BodyType>> Function(Request request) onProceed;

  @override
  FutureOr<Response<BodyType>> proceed(Request request) => onProceed(request);
}
