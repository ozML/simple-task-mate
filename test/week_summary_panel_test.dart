import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/widgets/week_summary_panel.dart';

import '_test_utils.dart';

void main() {
  initializeDateFormatting('en', null);

  group('WeekSummaryPanel -', () {
    final summaries = {
      0: StampSummary(
        date: testWeek[0],
        duration: const Duration(days: 1),
      ),
      1: StampSummary(
        date: testWeek[1],
        duration: const Duration(hours: 2),
      ),
      2: StampSummary(
        date: testWeek[2],
        duration: const Duration(minutes: 50),
      ),
      for (int i = 3; i < 7; i++)
        i: StampSummary(
          date: testWeek[i],
          duration: Duration.zero,
        ),
    };
    final currentDate = testWeek[3];

    testWidgets('Loading', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: WeekSummaryPanel(
            summaries: summaries,
            date: currentDate,
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('Validate', (tester) async {
      bool isAvatarBackgroundSet(CircleAvatar avatar) =>
          avatar.backgroundColor != null;

      bool isTextBold(Text text) => text.style?.fontWeight == FontWeight.bold;

      await tester.pumpWidget(
        TestApp(
          child: WeekSummaryPanel(
            summaries: summaries,
            date: currentDate,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(WeekSummaryPanel.keyContentRow), findsOneWidget);

      final avatars = tester
          .widgetList<CircleAvatar>(find.byKey(WeekSummaryPanel.keyTileAvatar))
          .toList();
      final titles = tester
          .widgetList<Text>(find.byKey(WeekSummaryPanel.keyTileTitle))
          .toList();
      final dates = tester
          .widgetList<Text>(find.byKey(WeekSummaryPanel.keyTileDate))
          .toList();
      final durations = tester
          .widgetList<Text>(find.byKey(WeekSummaryPanel.keyTileDuration))
          .toList();

      expect(avatars.indexWhere(isAvatarBackgroundSet), 3);
      expect(avatars.singleWhereOrNull(isAvatarBackgroundSet), isNotNull);

      expect(titles.indexWhere(isTextBold), 3);
      expect(titles.singleWhereOrNull(isTextBold), isNotNull);
      expect(
        titles.map((e) => e.data),
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      );

      expect(
        dates.map((e) => e.data),
        ['14.10', '15.10', '16.10', '17.10', '18.10', '19.10', '20.10'],
      );

      expect(
        durations.map((e) => e.data),
        ['24:00', '02:00', '00:50', '', '', '', ''],
      );
    });
  });
}
