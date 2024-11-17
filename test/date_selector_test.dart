import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/widgets/date_selector.dart';

import '_test_utils.dart';

void main() {
  final minDate = testWeek.first;
  final maxDate = testWeek.last;

  group('DateSelector -', () {
    testWidgets('Validate', (tester) async {
      bool onNextDatePressed = false;
      bool onPreviousDatePressed = false;
      bool onResetDatePressed = false;
      DateTime? selectedDate;

      await tester.pumpWidget(
        TestApp(
          child: DateSelector(
            date: testWeek[3],
            selectedDate: testWeek[3],
            minDate: minDate,
            maxDate: maxDate,
            onNextDate: () => onNextDatePressed = true,
            onPreviousDate: () => onPreviousDatePressed = true,
            onReset: () => onResetDatePressed = true,
          ),
        ),
      );

      final week = tester.widget<Text>(find.byKey(DateSelector.keyLabelWeek));
      final date = tester.widget<Text>(find.byKey(DateSelector.keyLabelDate));
      final weekDay =
          tester.widget<Text>(find.byKey(DateSelector.keyLabelWeekDay));

      expect(week.data, 'Week 42');
      expect(date.data, '10/17/2024');
      expect(weekDay.data, 'Thursday');

      expect(find.byKey(DateSelector.keyButtonResetDate), findsNothing);

      await tester.tap(find.byKey(DateSelector.keyButtonPreviousDate));
      expect(onPreviousDatePressed, true);

      await tester.tap(find.byKey(DateSelector.keyButtonNextDate));
      expect(onNextDatePressed, true);

      await tester.pumpWidget(
        TestApp(
          child: DateSelector(
            date: testWeek[3],
            selectedDate: testWeek[2],
            minDate: minDate,
            maxDate: maxDate,
            onReset: () => onResetDatePressed = true,
          ),
        ),
      );

      expect(find.byKey(DateSelector.keyButtonResetDate), findsOneWidget);

      await tester.tap(find.byKey(DateSelector.keyButtonResetDate));
      expect(onResetDatePressed, true);

      await tester.pumpWidget(
        TestApp(
          child: DateSelector(
            date: testWeek[3],
            selectedDate: testWeek[4],
            minDate: minDate,
            maxDate: maxDate,
            onSelectDate: (value) => selectedDate = value,
          ),
        ),
      );

      expect(find.byKey(DateSelector.keyButtonResetDate), findsOneWidget);

      await tester.tap(find.byKey(DateSelector.keyButtonPicker));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(DatePickerDialog),
          matching: find.text('17'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(DatePickerDialog),
          matching: find.text('OK'),
        ),
      );
      await tester.pumpAndSettle();

      expect(selectedDate, testWeek[3]);
    });
  });
}
