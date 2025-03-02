extension DurationExtension on Duration {
  String get asHHMM {
    final hours = inHours;
    final minutes = inMinutes;
    final isNegative = hours < 0 || minutes < 0;

    return '${isNegative ? '-' : ''}'
        '${hours.abs().toString().padLeft(2, '0')}:'
        '${minutes.remainder(60).abs().toString().padLeft(2, '0')}';
  }
}
