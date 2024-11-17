import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class TimeTicker extends StatelessWidget {
  const TimeTicker({
    required this.time,
    this.clockTimeFormat = ClockTimeFormat.twentyFourHours,
    this.locale = const Locale('en'),
    super.key,
  });

  static Key get keyClockTime => Key('$TimeTicker/clockTime');
  static Key get keyDayTimeIndicator => Key('$TimeTicker/dayTimeIndicator');

  final DateTime time;
  final ClockTimeFormat clockTimeFormat;
  final Locale locale;

  static Widget buildFromModels({required BuildContext context, Key? key}) {
    final config = context.watch<ConfigModel>();
    final clockTimeFormatConfigValue = config.getValue(settingClockTimeFormat);
    final locale = config.getValue<Locale>(settingLanguage);

    final dateTime = context.select<DateTimeModel, DateTime>(
      (value) => value.dateTime,
    );

    return TimeTicker(
      time: dateTime,
      clockTimeFormat: clockTimeFormatConfigValue,
      locale: locale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final clockTimeTimeFormat = switch (clockTimeFormat) {
      ClockTimeFormat.twelveHours => 'hh:mm:ss',
      _ => 'HH:mm:ss',
    };
    final languageCode = locale.languageCode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          key: keyClockTime,
          DateFormat(clockTimeTimeFormat, languageCode).format(time),
          style: bigPrimaryTextStyleFrom(context),
        ),
        if (clockTimeFormat == ClockTimeFormat.twelveHours)
          Text(
            key: keyDayTimeIndicator,
            DateFormat('a', languageCode).format(time),
            style: secondaryTextStyleFrom(context),
          ),
      ],
    );
  }
}
