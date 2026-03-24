---
name: matoapunch-http
description: Use when working with the matoapunch_http Flutter/Dart package, including Chopper integration, HttpErrorInterceptor, ResponseException, and ConnectionResultStatus. Trigger for tasks such as adding matoapunch_http to a project, wiring HTTP interceptors into a ChopperClient, normalizing transport or non-2xx failures, handling timeout or offline states, or writing tests around matoapunch_http-based networking code.
---

# Matoa Punch Http

Use this skill when the user is implementing or refactoring Flutter or Dart networking code around `matoapunch_http`.

## What The Package Exports

- `HttpErrorInterceptor` for normalizing failed HTTP responses and transport exceptions
- `ResponseException` as the structured error model
- `ConnectionResultStatus` for high-level request state classification

If you need the exact public API or example usage, read [references/api.md](references/api.md).

## Workflow

1. Add the package import:

```dart
import 'package:matoapunch_http/matoapunch_http.dart';
```

2. Attach `HttpErrorInterceptor` to the `ChopperClient` interceptor list.

3. Catch `ResponseException` at the service, repository, or use-case boundary where the app turns transport failures into domain behavior.

4. Branch on `ConnectionResultStatus` instead of parsing raw exception strings.

## Guidance

- Use `HttpErrorInterceptor` when the project wants one consistent error shape across timeout, offline, TLS, and non-2xx HTTP failures.
- Treat `ResponseException.code` as the package-level error code and `httpCode` as the HTTP status when available.
- Prefer checking `ConnectionResultStatus.noInternet` and `ConnectionResultStatus.timeout` before generic `error`.
- If the backend returns a JSON body with a `message` field, rely on the interceptor to surface that message.
- Keep business logic out of the interceptor. Map transport failures here, then convert them into product-specific messaging elsewhere.

## Common Patterns

### Chopper client

```dart
final client = ChopperClient(
  baseUrl: Uri.parse('https://api.example.com'),
  interceptors: const [
    HttpErrorInterceptor(),
  ],
);
```

### Error handling

```dart
try {
  await service.getProfile();
} on ResponseException catch (error) {
  switch (error.status) {
    case ConnectionResultStatus.timeout:
      // Retry or show timeout UI
      break;
    case ConnectionResultStatus.noInternet:
      // Show offline UI
      break;
    case ConnectionResultStatus.error:
      // Handle HTTP or unexpected error
      break;
    case ConnectionResultStatus.success:
      break;
  }
}
```

## Validation

- Run `dart analyze`
- Run `flutter test`

Keep changes aligned with the package’s exported API and examples in [README.md](../../../README.md).
