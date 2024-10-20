import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/widgets/title_bands.dart';

import 'test_utils.dart';

void main() {
  group('PlainTitleBand -', () {
    testWidgets('Validate', (tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: PlainTitleBand(title: 'title', subTitle: 'subTitle'),
        ),
      );

      final title = tester.widget<Text>(find.byKey(PlainTitleBand.keyTitle));
      final subTitle = tester.widget<Text>(
        find.byKey(PlainTitleBand.keySubTitle),
      );

      expect(title.data, 'title');
      expect(subTitle.data, 'subTitle');

      await tester.pumpWidget(
        const TestApp(child: PlainTitleBand(title: 'title')),
      );

      expect(find.byKey(PlainTitleBand.keyTitle), findsOneWidget);
      expect(find.byKey(PlainTitleBand.keySubTitle), findsNothing);
    });
  });

  group('WorkTimeSummaryBand -', () {
    testWidgets('Validate', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: WorkTimeSummaryBand(stamps: testStamps),
        ),
      );

      final workingTime = tester.widget<Text>(
        find.byKey(WorkTimeSummaryBand.keyWorkingTime),
      );
      final pauseTime = tester.widget<Text>(
        find.byKey(WorkTimeSummaryBand.keyPauseTime),
      );
      final presentnessTime = tester.widget<Text>(
        find.byKey(WorkTimeSummaryBand.keyPresentnessTime),
      );

      expect(workingTime.data, '08:00');
      expect(pauseTime.data, '00:30');
      expect(presentnessTime.data, '08:30');
    });
  });

  group('BookedTimeSummaryBand -', () {
    testWidgets('Validate', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: BookedTimeSummaryBand(
            workTime: const Duration(hours: 8),
            tasks: testFullTasks.sublist(0, 1),
          ),
        ),
      );

      final workingTime = tester.widget<Text>(
        find.byKey(BookedTimeSummaryBand.keyWorkingTime),
      );
      final bookedTime = tester.widget<Text>(
        find.byKey(BookedTimeSummaryBand.keyBookedTime),
      );
      final leftTime = tester.widget<Text>(
        find.byKey(BookedTimeSummaryBand.keyLeftTime),
      );

      expect(workingTime.data, '08:00');
      expect(bookedTime.data, '06:30');
      expect(leftTime.data, '01:30');
    });
  });
}
