# API Reference

## Import

```dart
import 'package:matoapunch_http/matoapunch_http.dart';
```

## HttpErrorInterceptor

Use `HttpErrorInterceptor` in a `ChopperClient` to normalize failures into `ResponseException`.

```dart
final client = ChopperClient(
  baseUrl: Uri.parse('https://api.example.com'),
  interceptors: const [
    HttpErrorInterceptor(),
  ],
);
```

## ResponseException

`ResponseException` exposes:

- `status` as `ConnectionResultStatus`
- `code` as the internal package error code
- `httpCode` as the HTTP status code when applicable
- `message` as the normalized error message
- `body` as the raw response body when available
- `stackTrace` when captured

```dart
try {
  await service.getProfile();
} on ResponseException catch (error) {
  print(error.status);
  print(error.httpCode);
  print(error.message);
}
```

## ConnectionResultStatus

Use `ConnectionResultStatus` to classify failures:

- `success`
- `timeout`
- `noInternet`
- `error`

## Error Mapping

`HttpErrorInterceptor` currently maps:

- non-2xx HTTP responses to `ResponseException` with `code == httpCode`
- `SocketException` to `noInternet` with code `1101`
- `HandshakeException` to `noInternet` with code `1102`
- `TimeoutException` to `timeout` with code `1103`
- other exceptions to `error` with code `1100`
