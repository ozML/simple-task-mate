import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';
import 'package:simple_task_mate/widgets/task_summary_viewer.dart';

import '_test_utils.dart';

void main() {
  group('TaskSummaryViewer -', () {
    testWidgets('Validate', (tester) async {
      int? selectedTaskId;
      Object? copiedTaskData;
      int? deletedTaskId;
      int? editTaskId;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (message) {
          if (message.method == 'Clipboard.setData') {
            copiedTaskData = message.arguments['text'];
            return Future.value(message.arguments);
          }

          return null;
        },
      );

      await tester.pumpWidget(
        TestApp(
          child: TaskSummaryViewer(
            summaries: testTaskSummaries,
            onTapItem: (ref) => selectedTaskId = ref.item.taskId,
            onDeleteItem: (ref) => deletedTaskId = ref.item.taskId,
            onEditItem: (ref) => editTaskId = ref.item.taskId,
          ),
        ),
      );

      expect(find.byKey(TaskSummaryViewer.keyItemTile), findsNWidgets(2));
      expect(find.byKey(ItemTile.keyTitle), findsOneWidget);
      expect(find.byKey(ItemTile.keySubTitle), findsNWidgets(2));
      expect(find.byKey(ItemTile.keyFootNote), findsNWidgets(2));

      expect(tester.widget<Text>(find.byKey(ItemTile.keyTitle)).data, 'ref0');
      expect(
        tester
            .widgetList<Text>(find.byKey(ItemTile.keySubTitle))
            .map((e) => e.data),
        ['task0', 'task1'],
      );
      expect(
        tester
            .widgetList<Text>(find.byKey(ItemTile.keyFootNote))
            .map((e) => e.data),
        ['Duration: 06:30', 'Duration: 00:15'],
      );

      expect(find.byKey(TaskSummaryViewer.keyItemActionCopy), findsNothing);
      expect(find.byKey(TaskSummaryViewer.keyItemActionDelete), findsNothing);
      expect(find.byKey(TaskSummaryViewer.keyItemActionEdit), findsNothing);

      await tester.hoverOver(find.byKey(TaskSummaryViewer.keyItemTile).first);

      expect(find.byKey(TaskSummaryViewer.keyItemActionCopy), findsOneWidget);
      expect(find.byKey(TaskSummaryViewer.keyItemActionDelete), findsOneWidget);
      expect(find.byKey(TaskSummaryViewer.keyItemActionEdit), findsOneWidget);

      await tester.tap(find.byKey(TaskSummaryViewer.keyItemTile).first);
      expect(selectedTaskId, 0);

      await tester.tap(find.byKey(TaskSummaryViewer.keyItemActionCopy));
      expect(copiedTaskData, 'ref0 - task0');

      await tester.tap(find.byKey(TaskSummaryViewer.keyItemActionDelete));
      expect(deletedTaskId, 0);

      await tester.tap(find.byKey(TaskSummaryViewer.keyItemActionEdit));
      expect(editTaskId, 0);
    });
  });
}
