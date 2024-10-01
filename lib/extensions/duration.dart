extension DurationExtension on Duration {
  String get asHHMM {
    return '${inHours.toString().padLeft(2, '0')}:'
        '${inMinutes.remainder(60).toString().padLeft(2, '0')}';
  }
}
