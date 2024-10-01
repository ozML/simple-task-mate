import 'package:intl/intl.dart';
import 'package:simple_task_mate/extensions/date_time.dart';

// Source: https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
final DateTime minDateTime = DateTime.utc(-271821, 04, 20);
final DateTime maxDateTime = DateTime.utc(275760, 09, 13);

/// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
// Source: https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object
int getNumOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
// Source: https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object
int getWeekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = getNumOfWeeks(date.year - 1);
  } else if (woy > getNumOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

/// Returns all dates which belong to the same week as [date].
List<DateTime> getWeekDates(DateTime date) {
  final int dateIndex = date.weekday - 1;
  final startDate = date.date.subtract(Duration(days: dateIndex));

  return [for (int i = 0; i < 7; i++) startDate.add(Duration(days: i))];
}

class CustomDateFormats {
  CustomDateFormats._();

  static String yMMdd(DateTime dateTime, [String? languageCode]) =>
      switch (languageCode) {
        'de' => DateFormat('dd.MM.y').format(dateTime),
        _ => DateFormat.yMd().format(dateTime)
      };
}
