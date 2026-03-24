/// The kind of constraint a `Limitation` represents.
enum LimitationType {
  /// A numeric cap (e.g. max 5 projects, max 100 API calls).
  count,

  /// A feature toggle (enabled / disabled).
  boolean,

  /// A time-based constraint (e.g. 30-day trial, 1-hour session).
  duration,

  /// A storage or file-size cap (e.g. 500 MB upload limit).
  size,
}
