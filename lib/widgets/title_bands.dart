import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/extensions/duration.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/utils/time_summary_utils.dart';

class PlainTitleBand extends StatelessWidget {
  const PlainTitleBand({required this.title, this.subTitle, super.key});

  static get keyTitle => Key('$PlainTitleBand/title');
  static get keySubTitle => Key('$PlainTitleBand/subTitle');

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);

    final subTitle = this.subTitle;

    return Container(
      constraints: const BoxConstraints(minHeight: 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, color: primaryColor),
          ),
          Text(
            key: keyTitle,
            title,
            style: primaryTextStyleFrom(context, bold: true),
            textAlign: TextAlign.center,
          ),
          if (subTitle != null)
            Text(
              key: keySubTitle,
              subTitle,
              style: primaryTextStyleFrom(context),
              textAlign: TextAlign.center,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, color: primaryColor),
          ),
        ],
      ),
    );
  }
}

class WorkTimeSummaryBand extends StatelessWidget {
  const WorkTimeSummaryBand({required this.stamps, super.key});

  static Key get keyWorkingTime => Key('$WorkTimeSummaryBand/workingTime');
  static Key get keyPauseTime => Key('$WorkTimeSummaryBand/pauseTime');
  static Key get keyPresentnessTime => Key('$WorkTimeSummaryBand/presentTime');

  final List<Stamp> stamps;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final presentnessTime = getPresentnessTime(stamps);
    final workTime = getWorkTime(stamps);
    final pauseTime = getPauseTime(stamps);

    final configModel = context.watch<ConfigModel>();
    final locale = configModel.getValue<Locale>(settingLanguage);

    String getTimeText(Duration time) =>
        configModel.getValue(settingTimeTrackingFormat) ==
                DurationFormat.decimal
            ? time.asDecimal(locale.languageCode)
            : time.asHHMM;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(height: 1, color: primaryColor),
        ),
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.texts.labelWorkingTime,
                      style: primaryTextStyle,
                    ),
                    Text(
                      key: keyWorkingTime,
                      getTimeText(workTime),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.texts.labelPauseTime, style: primaryTextStyle),
                    Text(
                      key: keyPauseTime,
                      getTimeText(pauseTime),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.texts.labelPresentnessTime,
                      style: primaryTextStyle,
                    ),
                    Text(
                      key: keyPresentnessTime,
                      getTimeText(presentnessTime),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(height: 1, color: primaryColor),
        ),
      ],
    );
  }
}

class BookedTimeSummaryBand extends StatelessWidget {
  const BookedTimeSummaryBand({
    required this.workTime,
    required this.tasks,
    super.key,
  });

  static Key get keyWorkingTime => Key('$BookedTimeSummaryBand/workingTime');
  static Key get keyBookedTime => Key('$BookedTimeSummaryBand/bookedTime');
  static Key get keyLeftTime => Key('$BookedTimeSummaryBand/leftTime');

  final Duration workTime;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final bookedTime = tasks.expand((element) => element.entries ?? []).fold(
          Duration.zero,
          (previousValue, element) => previousValue + element.time(),
        );

    final configModel = context.watch<ConfigModel>();
    final locale = configModel.getValue<Locale>(settingLanguage);

    String getTimeText(Duration time) =>
        configModel.getValue(settingTimeTrackingFormat) ==
                DurationFormat.decimal
            ? time.asDecimal(locale.languageCode)
            : time.asHHMM;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(height: 1, color: primaryColor),
        ),
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.texts.labelWorkingTime,
                      style: primaryTextStyle,
                    ),
                    Text(
                      key: keyWorkingTime,
                      getTimeText(workTime),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.texts.labelBookedTime,
                      style: primaryTextStyle,
                    ),
                    Text(
                      key: keyBookedTime,
                      getTimeText(bookedTime),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.texts.labelRemainingTime,
                      style: primaryTextStyle,
                    ),
                    Text(
                      key: keyLeftTime,
                      getTimeText((workTime - bookedTime)),
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(height: 1, color: primaryColor),
        ),
      ],
    );
  }
}
