import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_summary_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class WeekSummaryPanel extends StatelessWidget {
  const WeekSummaryPanel({
    required this.summaries,
    this.date,
    this.locale = const Locale('en'),
    this.durationFormat = DurationFormat.standard,
    this.isLoading = false,
    super.key,
  });

  static Key get keyContentRow => Key('$WeekSummaryPanel/content');
  static Key get keyTile => Key('$WeekSummaryPanel/tile');
  static Key get keyTileAvatar => Key('$WeekSummaryPanel/avatar');
  static Key get keyTileTitle => Key('$WeekSummaryPanel/title');
  static Key get keyTileDate => Key('$WeekSummaryPanel/date');
  static Key get keyTileDuration => Key('$WeekSummaryPanel/duration');

  final Map<int, StampSummary> summaries;
  final DateTime? date;
  final Locale locale;
  final DurationFormat durationFormat;
  final bool isLoading;

  static Widget buildFromModels({required BuildContext context, Key? key}) {
    final locale = context.select<ConfigModel, Locale>(
      (value) => value.getValue<Locale>(settingLanguage),
    );
    final durationFormat = context.select<ConfigModel, DurationFormat>(
      (value) => value.getValue<DurationFormat>(settingTimeTrackingFormat),
    );

    final date = context.select<DateTimeModel, DateTime>(
      (value) => value.selectedDate,
    );
    final weekDates = getWeekDates(date);

    final summaryModel = context.watch<StampSummaryModel>();
    final summaries = <int, StampSummary>{};
    for (int i = 0; i < 7; i++) {
      final weekDate = weekDates[i];
      final summary = summaryModel.summaries.singleWhereOrNull(
        (element) => element.date == weekDate,
      );
      summaries[i] = summary ??
          StampSummary(
            date: weekDate,
            duration: Duration.zero,
          );
    }

    return WeekSummaryPanel(
      summaries: summaries,
      date: date,
      isLoading: summaryModel.isLoading,
      locale: locale,
      durationFormat: durationFormat,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final weekDayShortNames = () {
      final result = DateFormat.EEEE(locale.languageCode)
          .dateSymbols
          .STANDALONESHORTWEEKDAYS;

      return [for (int i = 0; i < result.length; i++) result[(i + 1) % 7]];
    }();

    String getTimeText(Duration time) =>
        durationFormat == DurationFormat.decimal
            ? time.asDecimal(locale.languageCode)
            : time.asHHMM;

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
              key: keyContentRow,
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
                            key: keyTile,
                            children: [
                              CircleAvatar(
                                key: keyTileAvatar,
                                radius: 40,
                                backgroundColor: isCurrentDate
                                    ? inversePrimaryColorFrom(context)
                                    : null,
                                child: Text(
                                  key: keyTileTitle,
                                  weekDayShortNames[i],
                                  style: primaryTextStyle?.copyWith(
                                    fontWeight:
                                        isCurrentDate ? FontWeight.bold : null,
                                  ),
                                ),
                              ),
                              if (summary != null)
                                Text(
                                  key: keyTileDate,
                                  DateFormat('dd.MM').format(summary.date),
                                  style: secondaryTextStyle,
                                ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    key: keyTileDuration,
                                    time != null && time != Duration.zero
                                        ? getTimeText(time)
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
