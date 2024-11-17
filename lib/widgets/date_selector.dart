import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.date,
    required this.selectedDate,
    required this.minDate,
    required this.maxDate,
    this.locale = const Locale('en'),
    this.onSelectDate,
    this.onPreviousDate,
    this.onNextDate,
    this.onReset,
    super.key,
  });

  static Key get keyLabelWeek => Key('$DateSelector/week');
  static Key get keyLabelDate => Key('$DateSelector/date');
  static Key get keyLabelWeekDay => Key('$DateSelector/weekDay');
  static Key get keyButtonNextDate => Key('$DateSelector/nextDate');
  static Key get keyButtonPreviousDate => Key('$DateSelector/previousDate');
  static Key get keyButtonPicker => Key('$DateSelector/picker');
  static Key get keyButtonResetDate => Key('$DateSelector/toResetDate');

  final DateTime date;
  final DateTime selectedDate;
  final DateTime minDate;
  final DateTime maxDate;
  final Locale locale;
  final ValueChanged<DateTime>? onSelectDate;
  final VoidCallback? onPreviousDate;
  final VoidCallback? onNextDate;
  final VoidCallback? onReset;

  static Widget fromProvider({
    required BuildContext context,
    VoidCallback? onUpdate,
  }) {
    final locale = context.select<ConfigModel, Locale>(
      (value) => value.getValue(settingLanguage),
    );

    final selectedDate = context.select<DateTimeModel, DateTime>(
      (value) => value.selectedDate,
    );
    final date = context.select<DateTimeModel, DateTime>(
      (value) => value.date,
    );

    final minDate = DateTime(1900);
    final maxDate = date.add(
      const Duration(days: 365 * 5),
    );

    return DateSelector(
      date: selectedDate,
      selectedDate: date,
      minDate: minDate,
      maxDate: maxDate,
      locale: locale,
      onSelectDate: (date) {
        context.read<DateTimeModel>().selectDate(date);
        onUpdate?.call();
      },
      onPreviousDate: selectedDate != minDate
          ? () {
              context.read<DateTimeModel>().selectDate(
                    selectedDate.subtract(const Duration(days: 1)),
                  );
              onUpdate?.call();
            }
          : null,
      onNextDate: selectedDate != maxDate
          ? () {
              context.read<DateTimeModel>().selectDate(
                    selectedDate.add(const Duration(days: 1)),
                  );
              onUpdate?.call();
            }
          : null,
      onReset: () {
        context.read<DateTimeModel>().clearDateSelection();
        onUpdate?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);
    final numberFormat = NumberFormat('00');

    final languageCode = locale.languageCode;

    final showResetButton = date != selectedDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: keyButtonPreviousDate,
          icon: IconUtils.caretLeft(context),
          onPressed: onPreviousDate,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            key: keyButtonPicker,
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  key: keyLabelWeek,
                  '${context.texts.labelWeek} '
                  '${numberFormat.format(getWeekNumber(date))}',
                  style: secondaryTextStyle,
                ),
                Text(
                  key: keyLabelDate,
                  CustomDateFormats.yMMdd(date, languageCode),
                  style: primaryTextStyle,
                ),
                Text(
                  key: keyLabelWeekDay,
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
          key: keyButtonNextDate,
          icon: IconUtils.caretRight(context),
          onPressed: onNextDate,
        ),
        if (showResetButton) ...[
          const SizedBox(width: 10),
          IconButton(
            key: keyButtonResetDate,
            icon: date.isBefore(selectedDate)
                ? IconUtils.doubleRightArrow(context)
                : IconUtils.doubleLeftArrow(context),
            onPressed: onReset,
          ),
        ],
      ],
    );
  }
}
