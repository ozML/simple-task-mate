import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class TimeTicker extends StatelessWidget {
  const TimeTicker({required this.time, super.key});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigModel>();
    final clockTimeFormatConfigValue = config.getValue(settingClockTimeFormat);
    final clockTimeFormat = switch (clockTimeFormatConfigValue) {
      ClockTimeFormat.twelveHours => 'hh:mm:ss',
      _ => 'HH:mm:ss',
    };
    final languageCode = config.getValue<Locale>(settingLanguage).languageCode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat(clockTimeFormat, languageCode).format(time),
          style: bigPrimaryTextStyleFrom(context),
        ),
        if (clockTimeFormatConfigValue == ClockTimeFormat.twelveHours)
          Text(
            DateFormat('a', languageCode).format(time),
            style: secondaryTextStyleFrom(context),
          ),
      ],
    );
  }
}
