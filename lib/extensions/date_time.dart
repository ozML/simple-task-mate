extension DateTimeExtension on DateTime {
  /// Returns the date of this instance.
  ///
  /// Creates an copy instance with only year, month and day set.
  DateTime get date => DateTime(year, month, day);

  /// The number of seconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  // Source: https://stackoverflow.com/questions/52153920/how-to-convert-from-datetime-to-unix-timestamp-in-flutter-or-dart-in-general
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  /// Constructs a new [DateTime] instance
  /// with the given [secondsSinceEpoch].
  static DateTime fromSecondsSinceEpoch(int secondsSinceEpoch) =>
      DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
}
