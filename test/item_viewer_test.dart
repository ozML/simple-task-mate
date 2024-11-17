import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_mate/widgets/item_viewer.dart';

import '_test_utils.dart';

void main() {
  group('ItemListViewer -', () {
    testWidgets('Validate', (tester) async {
      const keyItemTile = Key('itemtile');
      const keyContent = Key('content');
      const keyIcon = Key('icon');
      const keyLink = Key('link');
      const keyAction = Key('action');
      const keyActionIcon = Key('actionicon');
      const items = ['item0', 'item1', 'item2'];

      bool triggeredAction = false;

      await tester.pumpWidget(
        TestApp(
          child: ItemListViewer(
            items: items,
            tileBuilder: (context, item, onSelect) => ItemTile(
              key: keyItemTile,
              item: item,
              title: item,
              subTitle: 'subtitle',
              footNote: 'footnote',
              content: Container(key: keyContent),
              infoIcon: Container(key: keyIcon),
              linkIcon: Container(key: keyLink),
              actions: [
                ItemTileAction(
                  key: keyAction,
                  icon: Container(key: keyActionIcon),
                  onPressed: (item) => triggeredAction = true,
                ),
              ],
            ),
            title: 'title',
          ),
        ),
      );

      expect(find.byKey(keyItemTile), findsNWidgets(items.length));
      expect(
        tester
            .widgetList<ItemTile>(find.byKey(keyItemTile))
            .map((e) => e.title),
        items,
      );

      expect(find.text('title'), findsOneWidget);
      expect(find.byKey(ItemListViewer.keySearchField), findsNothing);
      expect(find.byKey(keyContent), findsNWidgets(items.length));
      expect(find.byKey(keyIcon), findsNWidgets(items.length));
      expect(find.byKey(keyLink), findsNWidgets(items.length));
      expect(find.byKey(keyAction), findsNothing);
      expect(find.byKey(keyActionIcon), findsNothing);

      await tester.hoverOver(find.byKey(keyItemTile).first);

      expect(find.byKey(keyAction), findsOneWidget);
      expect(find.byKey(keyActionIcon), findsOneWidget);

      await tester.tap(find.byKey(keyAction));
      expect(triggeredAction, true);
    });

    testWidgets(
      'Searchfield',
      (tester) => tester.runAsync(
        () async {
          const items = ['item0', 'item1', 'item2'];

          String? enteredSearchText;

          await tester.pumpWidget(
            TestApp(
              child: ItemListViewer(
                items: items,
                tileBuilder: (context, item, onSelect) => ItemTile(
                  item: item,
                  title: item,
                  subTitle: 'subtitle',
                  footNote: 'footnote',
                  actions: [
                    ItemTileAction(
                      icon: Container(),
                      onPressed: (item) {},
                    ),
                  ],
                ),
                title: 'title',
                showSearchField: true,
                searchFieldHintText: 'hint',
                searchText: 'search',
                onSearchTextChanged: (value) => enteredSearchText = value,
              ),
            ),
          );

          final searchField = tester.widget<TextField>(
            find.byKey(ItemListViewer.keySearchField),
          );

          expect(searchField.controller?.text, 'search');
          expect(searchField.decoration?.hintText, 'hint');

          await tester.enterText(find.byWidget(searchField), 'search X');
          await Future.delayed(const Duration(milliseconds: 500));

          expect(enteredSearchText, 'search X');
        },
      ),
    );
  });
}
