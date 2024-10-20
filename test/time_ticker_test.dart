import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/widgets/time_ticker.dart';

import 'test_utils.dart';

void main() {
  group('TimeTicker -', () {
    testWidgets('Validate', (tester) async {
      await tester.pumpWidget(TestApp(child: TimeTicker(time: testDateTime)));

      var clockTime = tester.widget<Text>(
        find.byKey(TimeTicker.keyClockTime),
      );

      expect(clockTime.data, '20:30:00');
      expect(find.byKey(TimeTicker.keyDayTimeIndicator), findsNothing);

      await tester.pumpWidget(
        TestApp(
          child: TimeTicker(
            time: testDateTime,
            clockTimeFormat: ClockTimeFormat.twelveHours,
          ),
        ),
      );

      clockTime = tester.widget<Text>(
        find.byKey(TimeTicker.keyClockTime),
      );

      expect(clockTime.data, '08:30:00');
      expect(find.byKey(TimeTicker.keyDayTimeIndicator), findsOneWidget);
    });
  });
}
