# matoapunch_http

HTTP utilities for Matoa Punch Studio Flutter packages.

This package is built on top of `chopper` and currently provides:

- `HttpErrorInterceptor` to normalize failed HTTP responses and transport errors.
- `AuthBearerInterceptor` to attach Bearer tokens from `shared_preferences` with optional auto-refresh on 401.
- `HttpClient` factory for creating unauthenticated `ChopperClient` instances.
- `AuthHttpClient` factory for creating authenticated `ChopperClient` instances.
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
- `AuthBearerInterceptor`
- `HttpClient`
- `AuthHttpClient`

## Usage

### Quick Start with Client Factories

Use the factory classes to create pre-configured `ChopperClient` instances:

```dart
import 'package:matoapunch_http/matoapunch_http.dart';

// Unauthenticated client (includes HttpErrorInterceptor)
final client = HttpClient.create(
  baseUrl: Uri.parse('https://api.example.com'),
);

// Authenticated client (includes AuthBearerInterceptor + HttpErrorInterceptor)
final authClient = AuthHttpClient.create(
  baseUrl: Uri.parse('https://api.example.com'),
  tokenKey: 'token',
);
```

### Manual ChopperClient Setup

Attach interceptors directly to your `ChopperClient`:

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

### AuthBearerInterceptor

The `AuthBearerInterceptor` reads a Bearer token from `shared_preferences` and attaches it to every request:

```dart
final client = ChopperClient(
  baseUrl: Uri.parse('https://api.example.com'),
  interceptors: [
    AuthBearerInterceptor(tokenKey: 'token'),
    HttpErrorInterceptor(),
  ],
);
```

#### Auto Token Refresh on 401

Pass an `onRefreshToken` callback to automatically refresh expired tokens:

```dart
final client = AuthHttpClient.create(
  baseUrl: Uri.parse('https://api.example.com'),
  tokenKey: 'token',
  onRefreshToken: () async {
    // Your refresh logic (e.g., call a refresh endpoint)
    final newToken = await refreshToken();
    return newToken; // Return null to indicate failure
  },
);
```

When a 401 response is received:
1. The `onRefreshToken` callback is called.
2. If it returns a new token, the token is saved and the request is retried.
3. If it returns `null`, the original 401 response is returned.

### Error Handling

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

For transport failures such as timeout or offline state, `error.httpCode` is
`null` because no HTTP response was received.

## Error Mapping

`HttpErrorInterceptor` currently maps errors as follows:

- Non-2xx HTTP responses become `ResponseException` with both `code` and
  `httpCode` set to the response status.
- Response bodies containing a `message` field use that message in the exception.
- `SocketException` maps to `ConnectionResultStatus.noInternet` with code `1101`.
- `HandshakeException` maps to `ConnectionResultStatus.noInternet` with code `1102`.
- `TimeoutException` maps to `ConnectionResultStatus.timeout` with code `1103`.
- Transport and unexpected failures leave `httpCode` as `null`.
- Any other exception maps to `ConnectionResultStatus.error` with code `1100`.

## Development

Run the package checks locally with:

```sh
dart analyze
flutter test
```
