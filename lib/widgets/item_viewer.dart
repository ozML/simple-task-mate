import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/content_box.dart';

class ItemTile<T> extends StatefulWidget {
  const ItemTile({
    required this.item,
    this.title,
    this.subTitle,
    this.content,
    this.footNote,
    this.infoIcon,
    this.linkIcon,
    this.onSelect,
    this.actions = const [],
    super.key,
  });

  static Key get keyTitle => Key('$ItemTile/title');
  static Key get keySubTitle => Key('$ItemTile/subTitle');
  static Key get keyFootNote => Key('$ItemTile/footNote');

  final T item;
  final String? title;
  final String? subTitle;
  final Widget? content;
  final String? footNote;
  final Widget? infoIcon;
  final Widget? linkIcon;
  final void Function(T item)? onSelect;
  final List<ItemTileAction<T>> actions;

  @override
  State<StatefulWidget> createState() => ItemTileState<T>();
}

class ItemTileAction<T> {
  ItemTileAction({required this.icon, required this.onPressed, this.key});

  final Widget icon;
  final Key? key;
  final void Function(T item) onPressed;
}

class ItemTileState<T> extends State<ItemTile<T>> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);
    final secondaryTextStyle = secondaryTextStyleFrom(context);

    final title = widget.title;
    final subTitle = widget.subTitle;
    final content = widget.content;
    final footNote = widget.footNote;
    final infoIcon = widget.infoIcon;
    final linkIcon = widget.linkIcon;

    return GestureDetector(
      onTap: () => widget.onSelect?.call(widget.item),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovering = true),
        onExit: (event) => setState(() => isHovering = false),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: isHovering ? 1 : 0.5,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (infoIcon != null || title != null || linkIcon != null)
                    Row(
                      children: [
                        if (infoIcon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: infoIcon,
                          ),
                        if (linkIcon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: linkIcon,
                          ),
                        Expanded(
                          child: Text(
                            key: ItemTile.keyTitle,
                            title ?? '',
                            style: primaryTextStyle?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (subTitle != null)
                    Text(
                      key: ItemTile.keySubTitle,
                      subTitle,
                      style: secondaryTextStyle,
                    ),
                  if (content != null) content,
                  if (footNote != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      key: ItemTile.keyFootNote,
                      footNote,
                      style: secondaryTextStyle,
                    ),
                  ],
                ],
              ),
              if (isHovering && widget.actions.isNotEmpty)
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.actions
                        .map((e) => IconButton(
                              key: e.key,
                              icon: e.icon,
                              onPressed: () => e.onPressed(widget.item),
                            ))
                        .toList(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemListViewer<T> extends StatefulWidget {
  const ItemListViewer({
    required this.items,
    required this.tileBuilder,
    required this.title,
    this.titleStyle = TitleStyle.header,
    this.showSearchField = false,
    this.searchText,
    this.searchFieldHintText,
    this.onSelect,
    this.onSearchTextChanged,
    super.key,
  });

  static Key get keySearchField => Key('$ItemListViewer/search<field');

  final List<T> items;
  final ItemTile<T> Function(
    BuildContext context,
    T item,
    void Function(T item)? onSelect,
  ) tileBuilder;
  final String title;
  final TitleStyle titleStyle;
  final bool showSearchField;
  final String? searchText;
  final String? searchFieldHintText;
  final void Function(T item)? onSelect;
  final void Function(String value)? onSearchTextChanged;

  @override
  State<ItemListViewer<T>> createState() => _ItemListViewerState<T>();
}

class _ItemListViewerState<T> extends State<ItemListViewer<T>> {
  static const _searchDelay = Duration(milliseconds: 500);
  late final _searchTextController = TextEditingController(
    text: widget.searchText,
  );
  RestartableTimer? _searchDelayTimer;

  @override
  void dispose() {
    _searchDelayTimer?.cancel();
    _searchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showSearchField)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      TextField(
                        key: ItemListViewer.keySearchField,
                        controller: _searchTextController,
                        decoration: textInputDecoration(
                          context,
                          labelText: 'Search',
                          hintText: widget.searchFieldHintText,
                        ),
                        onChanged: (value) => setState(() {
                          _searchDelayTimer ??= RestartableTimer(
                            _searchDelay,
                            () => widget.onSearchTextChanged?.call(
                              _searchTextController.text,
                            ),
                          );
                          _searchDelayTimer?.reset();
                        }),
                      ),
                      if (_searchTextController.text.isNotEmpty)
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(5),
                          child: IconButton(
                            icon: IconUtils.clear(context),
                            onPressed: () => setState(() {
                              _searchDelayTimer?.cancel();
                              _searchTextController.clear();
                              widget.onSearchTextChanged?.call('');
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        Expanded(
          child: ContentBox(
            title: widget.title,
            titleStyle: widget.titleStyle,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) => widget.tileBuilder(
                context,
                widget.items[index],
                widget.onSelect,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
