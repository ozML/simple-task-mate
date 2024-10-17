import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/date_time.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/models/stamp_summary_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/date_time_utils.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/widgets/date_selector.dart';
import 'package:simple_task_mate/widgets/title_bands.dart';
import 'package:simple_task_mate/widgets/page_scaffold.dart';
import 'package:simple_task_mate/widgets/stamp_entry_viewer.dart';
import 'package:simple_task_mate/widgets/time_ticker.dart';
import 'package:simple_task_mate/widgets/week_summary_panel.dart';

class StampView extends StatefulWidget {
  const StampView({super.key});

  @override
  State<StatefulWidget> createState() => StampViewState();
}

class StampViewState extends State<StampView> {
  bool _manualStampMode = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh([bool? success]) async {
    if (success == null || success) {
      if (!mounted) {
        return;
      }
      final date = context.read<DateTimeModel>().selectedDate;
      final stampModel = context.read<StampModel>();
      final stampSummaryModel = context.read<StampSummaryModel>();

      await stampModel.loadStampsForDate(date);
      await stampSummaryModel.loadSummariesForWeek(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: IconUtils.circleQuestion(context),
            onPressed: () => PackageInfo.fromPlatform().then(
              (value) {
                if (context.mounted) {
                  showAboutDialog(
                    context: context,
                    applicationVersion: value.version,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );

    final content = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Consumer<DateTimeModel>(
                  builder: (context, value, child) {
                    final date = value.selectedDate;
                    final minDate = DateTime(1900);
                    final maxDate = value.date.add(
                      const Duration(days: 365 * 5),
                    );

                    return DateSelector(
                      date: date,
                      currentDate: value.date,
                      minDate: minDate,
                      maxDate: maxDate,
                      onSelectDate: (date) {
                        value.selectDate(date);
                        _refresh();
                      },
                      onPreviousDate: date != minDate
                          ? () {
                              value.selectDate(
                                date.subtract(const Duration(days: 1)),
                              );
                              _refresh();
                            }
                          : null,
                      onNextDate: date != maxDate
                          ? () {
                              value.selectDate(
                                date.add(const Duration(days: 1)),
                              );
                              _refresh();
                            }
                          : null,
                      onReset: () {
                        value.clearDateSelection();
                        _refresh();
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Consumer<DateTimeModel>(
                  builder: (context, value, child) =>
                      TimeTicker(time: value.dateTime),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
        Consumer<StampModel>(
          builder: (context, value, _) =>
              WorkTimeSummaryBand(stamps: value.stamps),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Consumer<StampSummaryModel>(
                      builder: (context, value, _) {
                        final date = context.select<DateTimeModel, DateTime>(
                          (value) => value.selectedDate,
                        );
                        final weekDates = getWeekDates(date);

                        final summaries = <int, StampSummary>{};
                        for (int i = 0; i < 7; i++) {
                          final weekDate = weekDates[i];
                          final summary = value.summaries.singleWhereOrNull(
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
                          date: date.date,
                          isLoading: value.isLoading,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Consumer<StampModel>(
                    builder: (context, value, child) {
                      final isCurrentDate = context.select<DateTimeModel, bool>(
                        (value) => value.selectedDate == value.date,
                      );

                      return StampEntryViewer(
                        stamps: value.stamps.reversed.toList(),
                        isManualMode: _manualStampMode,
                        isStampDisabled: !isCurrentDate,
                        isLoading: value.isLoading,
                        onSaveStamp: (stamp) => value
                            .addStamp(stamp)
                            .then((value) => _refresh(value.$1)),
                        onDeleteStamp: (stamp) => confirmDeleteStamp(
                          context: context,
                          stamp: stamp,
                          action: () => value.deleteStamp(stamp).then(_refresh),
                        ),
                        onModeChanged: (value) => setState(() {
                          _manualStampMode = value;
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: PageScaffold(
        selectedPageIndex: 0,
        child: Stack(
          children: [content, header],
        ),
      ),
    );
  }
}
