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
    this.onSelect,
    this.actions = const [],
    super.key,
  });

  final T item;
  final String? title;
  final String? subTitle;
  final Widget? content;
  final String? footNote;
  final void Function(T item)? onSelect;
  final List<ItemTileAction<T>> actions;

  @override
  State<StatefulWidget> createState() => ItemTileState<T>();
}

class ItemTileAction<T> {
  ItemTileAction({required this.icon, required this.onPressed});

  final Widget icon;
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
    final footNode = widget.footNote;

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
                children: [
                  if (title != null || subTitle != null)
                    RichText(
                      text: TextSpan(
                        children: [
                          if (title != null)
                            TextSpan(
                              text: '$title\n',
                              style: primaryTextStyle?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (subTitle != null)
                            TextSpan(text: subTitle, style: secondaryTextStyle),
                        ],
                      ),
                    ),
                  if (content != null) content,
                  if (footNode != null) ...[
                    const SizedBox(height: 20),
                    Text(footNode, style: secondaryTextStyle),
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
    this.searchFieldHintText,
    this.onSelect,
    this.onSearchTextChanged,
    super.key,
  });

  final List<T> items;
  final ItemTile<T> Function(
    BuildContext context,
    T item,
    void Function(T item)? onSelect,
  ) tileBuilder;
  final String title;
  final TitleStyle titleStyle;
  final bool showSearchField;
  final String? searchFieldHintText;
  final void Function(T item)? onSelect;
  final void Function(String value)? onSearchTextChanged;

  @override
  State<ItemListViewer<T>> createState() => _ItemListViewerState<T>();
}

class _ItemListViewerState<T> extends State<ItemListViewer<T>> {
  static const _searchDelay = Duration(milliseconds: 500);
  final _searchTextController = TextEditingController();
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
                  context, widget.items[index], widget.onSelect),
            ),
          ),
        ),
      ],
    );
  }
}
