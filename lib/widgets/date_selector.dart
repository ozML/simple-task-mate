import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.date,
    required this.minDate,
    required this.maxDate,
    this.showResetButton = false,
    this.onSelectDate,
    this.onPreviousDate,
    this.onNextDate,
    this.onReset,
    super.key,
  });

  final DateTime date;
  final DateTime minDate;
  final DateTime maxDate;
  final bool showResetButton;
  final ValueChanged<DateTime>? onSelectDate;
  final VoidCallback? onPreviousDate;
  final VoidCallback? onNextDate;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);
    final numberFormat = NumberFormat('00');

    final config = context.watch<ConfigModel>();
    final languageCode = config.getValue<Locale>(settingLanguage).languageCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: IconUtils.caretLeft(context),
          onPressed: onPreviousDate,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${context.texts.labelWeek} '
                  '${numberFormat.format(getWeekNumber(date))}',
                  style: secondaryTextStyle,
                ),
                Text(
                  CustomDateFormats.yMMdd(date, languageCode),
                  style: primaryTextStyle,
                ),
                Text(
                  DateFormat('EEEE', languageCode).format(date),
                  style: secondaryTextStyle,
                ),
              ],
            ),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                currentDate: date,
                firstDate: minDate,
                lastDate: maxDate,
              );

              if (selectedDate != null) {
                onSelectDate?.call(selectedDate);
              }
            },
          ),
        ),
        IconButton(
          icon: IconUtils.caretRight(context),
          onPressed: onNextDate,
        ),
        if (showResetButton) ...[
          const SizedBox(width: 10),
          IconButton(
            icon: IconUtils.doubleLeftArrow(context),
            onPressed: onReset,
          ),
        ],
      ],
    );
  }
}
