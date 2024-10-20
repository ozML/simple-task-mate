import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/utils/tuple.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';
import 'package:simple_task_mate/widgets/task_viewer.dart';

import 'test_utils.dart';

void main() {
  group('TaskViewer -', () {
    testWidgets('Validate', (tester) async {
      int? selectedTaskId;
      Object? copiedTaskData;
      int? deletedTaskId;
      int? addedTaskId;

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
          child: TaskViewer(
            tasks: testFullTasks,
            onSelect: (task) => selectedTaskId = task.id,
            onDelete: (task) => deletedTaskId = task.id,
            onAdd: (task) => addedTaskId = task.id,
          ),
        ),
      );

      expect(find.byKey(TaskViewer.keyItemTile), findsNWidgets(2));
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
      expect(
        tester.widget<Tooltip>(find.byKey(TaskViewer.keyItemInfoIcon)).message,
        'First task',
      );
      expect(find.byKey(TaskViewer.keyItemLinkIcon), findsNothing);

      expect(find.byKey(TaskViewer.keyItemActionCopy), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionAdd), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionDelete), findsNothing);

      await tester.hoverOver(find.byKey(TaskViewer.keyItemTile).first);

      expect(find.byKey(TaskViewer.keyItemActionCopy), findsOneWidget);
      expect(find.byKey(TaskViewer.keyItemActionAdd), findsOneWidget);
      expect(find.byKey(TaskViewer.keyItemActionDelete), findsOneWidget);

      await tester.tap(find.byKey(TaskViewer.keyItemTile).first);
      expect(selectedTaskId, 0);

      await tester.tap(find.byKey(TaskViewer.keyItemActionCopy));
      expect(copiedTaskData, 'ref0 - task0');

      await tester.tap(find.byKey(TaskViewer.keyItemActionAdd));
      expect(addedTaskId, 0);

      await tester.tap(find.byKey(TaskViewer.keyItemActionDelete));
      expect(deletedTaskId, 0);
    });

    testWidgets('Reduced', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: TaskViewer(
            tasks: testFullTasks,
            hideCopyButton: true,
            hideDurations: true,
          ),
        ),
      );

      expect(find.byKey(TaskViewer.keyItemTile), findsNWidgets(2));
      expect(find.byKey(ItemTile.keyTitle), findsOneWidget);
      expect(find.byKey(ItemTile.keySubTitle), findsNWidgets(2));
      expect(find.byKey(ItemTile.keyFootNote), findsNothing);
      expect(find.byKey(TaskViewer.keyItemInfoIcon), findsOneWidget);
      expect(find.byKey(TaskViewer.keyItemLinkIcon), findsNothing);

      expect(find.byKey(TaskViewer.keyItemActionCopy), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionAdd), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionDelete), findsNothing);

      await tester.hoverOver(find.byKey(TaskViewer.keyItemTile).first);

      expect(find.byKey(TaskViewer.keyItemActionCopy), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionAdd), findsNothing);
      expect(find.byKey(TaskViewer.keyItemActionDelete), findsNothing);
    });

    testWidgets('Auto links', (tester) async {
      String? openedLink;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (message) {
          openedLink = message.arguments['url'];

          return Future.value(true);
        },
      );

      await tester.pumpWidget(
        TestApp(
          child: TaskViewer(
            tasks: testFullTasks,
            hideCopyButton: true,
            hideDurations: true,
            autoLinkGroups: [Tuple('ref0', 'http:example.org/')],
          ),
        ),
      );

      expect(find.byKey(TaskViewer.keyItemLinkIcon), findsOneWidget);
      expect(
        tester.widget<Tooltip>(find.byKey(TaskViewer.keyItemLinkIcon)).message,
        'http:example.org/ref0',
      );

      await tester.tap(find.byKey(TaskViewer.keyItemLinkIcon));
      expect(openedLink, 'http:example.org/ref0');
    });
  });
}
