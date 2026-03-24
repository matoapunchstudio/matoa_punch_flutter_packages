/// Describes the high-level outcome of an HTTP request.
enum ConnectionResultStatus {
  /// The request completed successfully.
  success,

  /// The request exceeded its configured timeout.
  timeout,

  /// The client could not reach the network.
  noInternet,

  /// The request failed for a non-network reason.
  error,
}
