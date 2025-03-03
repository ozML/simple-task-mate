import 'dart:math';

import 'package:intl/intl.dart';

extension DurationExtension on Duration {
  String get asHHMM {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final isNegative = hours < 0 || minutes < 0;

    return '${isNegative ? '-' : ''}'
        '${hours.abs().toString().padLeft(2, '0')}:'
        '${minutes.abs().toString().padLeft(2, '0')}';
  }

  String asDecimal([String? languageCode]) {
    final hours = inHours;
    final hourFraction = inMinutes.remainder(60) / 60;
    final fac = pow(10, 3) as int;
    final time = hours + ((hourFraction * fac).round() / fac);

    return NumberFormat.decimalPattern(languageCode).format(time);
  }
}
