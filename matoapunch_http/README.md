# matoapunch_http

HTTP utilities for Matoa Punch Studio Flutter packages.

This package is built on top of `chopper` and currently provides:

- `HttpErrorInterceptor` to normalize failed HTTP responses and transport errors.
- `ResponseException` as a structured exception model for request failures.
- `ConnectionResultStatus` to classify request outcomes.

## Installation

This package is internal and is not published to `pub.dev` (`publish_to: none`).

Use it from the monorepo with a local path dependency:

```yaml
dependencies:
  matoapunch_http:
    path: ../matoapunch_http
```

Or consume it from the shared package repository:

```yaml
dependencies:
  matoapunch_http:
    git:
      url: https://github.com/matoapunchstudio/matoapunch_flutter_packages.git
      ref: main
      path: matoapunch_http
```

## Exports

Import the package entrypoint:

```dart
import 'package:matoapunch_http/matoapunch_http.dart';
```

It exports:

- `ConnectionResultStatus`
- `ResponseException`
- `HttpErrorInterceptor`

## Usage

Attach `HttpErrorInterceptor` to your `ChopperClient` so HTTP failures are surfaced as `ResponseException`.

```dart
import 'package:chopper/chopper.dart';
import 'package:matoapunch_http/matoapunch_http.dart';

final client = ChopperClient(
  baseUrl: Uri.parse('https://api.example.com'),
  interceptors: const [
    HttpErrorInterceptor(),
  ],
);
```

When a request fails, inspect the normalized exception:

```dart
try {
  await service.getProfile();
} on ResponseException catch (error) {
  switch (error.status) {
    case ConnectionResultStatus.timeout:
      // Handle timeout
      break;
    case ConnectionResultStatus.noInternet:
      // Handle offline state
      break;
    case ConnectionResultStatus.error:
      // Handle HTTP or unexpected error
      break;
    case ConnectionResultStatus.success:
      break;
  }
}
```

## Error Mapping

`HttpErrorInterceptor` currently maps errors as follows:

- Non-2xx HTTP responses become `ResponseException` with the HTTP status code.
- Response bodies containing a `message` field use that message in the exception.
- `SocketException` maps to `ConnectionResultStatus.noInternet` with code `1101`.
- `HandshakeException` maps to `ConnectionResultStatus.noInternet` with code `1102`.
- `TimeoutException` maps to `ConnectionResultStatus.timeout` with code `1103`.
- Any other exception maps to `ConnectionResultStatus.error` with code `1100`.

## Development

Run the package checks locally with:

```sh
dart analyze
flutter test
```
