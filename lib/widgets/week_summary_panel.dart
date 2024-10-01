import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class WeekSummaryPanel extends StatelessWidget {
  const WeekSummaryPanel({
    required this.summaries,
    this.date,
    this.isLoading = false,
    super.key,
  });

  final Map<int, StampSummary> summaries;
  final DateTime? date;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final config = context.watch<ConfigModel>();

    final weekDayShortNames = () {
      final result = DateFormat.EEEE(
        config.getValue<Locale>(settingLanguage).languageCode,
      ).dateSymbols.STANDALONESHORTWEEKDAYS;

      return [for (int i = 0; i < result.length; i++) result[(i + 1) % 7]];
    }();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 600,
      width: 700,
      child: isLoading
          ? Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Row(
              children: [
                ...List.generate(7, (index) => index).expandIndexed(
                  (i, e) {
                    final summary = summaries[e];
                    final time = summary?.duration;
                    final isCurrentDate =
                        date != null && summary?.date.date == date?.date;

                    return [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 50),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: isCurrentDate
                                    ? inversePrimaryColorFrom(context)
                                    : null,
                                child: Text(
                                  weekDayShortNames[i],
                                  style: primaryTextStyle?.copyWith(
                                    fontWeight:
                                        isCurrentDate ? FontWeight.bold : null,
                                  ),
                                ),
                              ),
                              if (summary != null)
                                Text(
                                  DateFormat('dd.MM').format(summary.date),
                                  style: secondaryTextStyle,
                                ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    time != null && time != Duration.zero
                                        ? time.asHHMM
                                        : '',
                                    style: secondaryTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (e != 6)
                        const VerticalDivider(
                          width: 1,
                          indent: 30,
                          endIndent: 30,
                        ),
                    ];
                  },
                )
              ],
            ),
    );
  }
}
