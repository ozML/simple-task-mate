import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/models/stamp_summary_model.dart';
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
              child: Center(child: TimeTicker.fromProvider(context: context)),
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
                    child: WeekSummaryPanel.fromProvider(context: context),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: StampEntryViewer.fromProvider(
                    context: context,
                    isManualMode: _manualStampMode,
                    onSaveStamp: (stamp) => context
                        .read<StampModel>()
                        .addStamp(stamp)
                        .then((value) => _refresh(value.$1)),
                    onDeleteStamp: (stamp) => confirmDeleteStamp(
                      context: context,
                      stamp: stamp,
                      action: () => context
                          .read<StampModel>()
                          .deleteStamp(stamp)
                          .then(_refresh),
                    ),
                    onModeChanged: (value) => setState(() {
                      _manualStampMode = value;
                    }),
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
