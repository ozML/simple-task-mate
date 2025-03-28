import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/collapsable_button.dart';
import 'package:simple_task_mate/widgets/content_box.dart';
import 'package:simple_task_mate/widgets/context_menu_button.dart';
import 'package:simple_task_mate/widgets/flex_container.dart';

class ItemRef<T> {
  ItemRef({
    required this.id,
    required this.item,
    this.isSelected = false,
    this.onSelect,
  });

  final Object id;
  final T item;
  final bool isSelected;
  final void Function(bool value)? onSelect;
}

abstract class LocalActionsElement<T> {
  LocalActionsElement({this.label, this.icon, this.key})
      : assert(label != null || icon != null);

  final String? label;
  final Widget? icon;
  final Key? key;
}

class LocalItemsGroup<T> extends LocalActionsElement<T> {
  LocalItemsGroup({required this.items, super.label, super.icon, super.key});

  final List<LocalItemAction<T>> items;
}

class LocalItemAction<T> extends LocalActionsElement<T> {
  LocalItemAction({
    required this.onPressed,
    super.label,
    super.icon,
    super.key,
  });

  final void Function(ItemRef<T> ref) onPressed;
}

abstract class GlobalActionsElement<T> {
  GlobalActionsElement({this.label, this.icon, this.key})
      : assert(label != null || icon != null);

  final String? label;
  final Widget? icon;
  final Key? key;
}

class GlobalItemsGroup<T> extends GlobalActionsElement<T> {
  GlobalItemsGroup({required this.items, super.label, super.icon, super.key});

  final List<GlobalItemsAction<T>> items;
}

class GlobalItemsAction<T> extends GlobalActionsElement<T> {
  GlobalItemsAction({
    required this.onPressed,
    this.itemFilter,
    super.label,
    super.icon,
    super.key,
  });

  final void Function(List<ItemRef<T>> refs) onPressed;
  final List<ItemRef<T>> Function(List<ItemRef<T>> refs)? itemFilter;
}

class TapInfo {
  TapInfo({this.isLeft = true, this.isRight = false, this.isDouble = false});

  TapInfo.left({bool isDouble = false})
      : this(isLeft: true, isRight: false, isDouble: isDouble);

  TapInfo.right({bool isDouble = false})
      : this(isLeft: false, isRight: true, isDouble: isDouble);

  final bool isLeft;
  final bool isRight;
  final bool isDouble;
}

class ItemTile<T> extends StatefulWidget {
  const ItemTile({
    required this.ref,
    this.title,
    this.subTitle,
    this.content,
    this.footNote,
    this.infoIcon,
    this.linkIcon,
    this.isHighlighted = false,
    this.onTap,
    this.actions = const [],
    super.key,
  });

  static Key get keyTitle => Key('$ItemTile/title');
  static Key get keySubTitle => Key('$ItemTile/subTitle');
  static Key get keyFootNote => Key('$ItemTile/footNote');

  final ItemRef<T> ref;
  final String? title;
  final String? subTitle;
  final Widget? content;
  final String? footNote;
  final Widget? infoIcon;
  final Widget? linkIcon;
  final bool isHighlighted;
  final void Function(ItemRef<T> ref, TapInfo info)? onTap;
  final List<LocalActionsElement<T>> actions;

  @override
  State<StatefulWidget> createState() => ItemTileState<T>();
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
    final onTap = widget.onTap;

    Widget buildActionButton(LocalActionsElement element) {
      final icon = element.icon;
      final label = element.label;
      final key = element.key;

      if (element is LocalItemAction<T>) {
        if (icon != null && label != null) {
          return TextButton.icon(
            key: key,
            label: Text(label, style: secondaryTextStyle),
            icon: icon,
            onPressed: () => element.onPressed(widget.ref),
          );
        } else {
          return TextButton(
            key: key,
            child: label != null
                ? Text(label, style: secondaryTextStyle)
                : icon ?? Container(),
            onPressed: () => element.onPressed(widget.ref),
          );
        }
      }

      if (element is LocalItemsGroup<T>) {
        final items = element.items
            .map(
              (e) => ContextMenuItem(
                key: e.key,
                title: e.label,
                iconBuilder: (context, {color, size}) => e.icon ?? Container(),
                onPressed: () => e.onPressed(widget.ref),
              ),
            )
            .toList();

        return ContextMenuButton.labelText(
          key: key,
          text: label,
          icon: icon,
          items: items,
        );
      }

      throw Exception('Could not build local action button');
    }

    final actionButtons = widget.actions
        .where(
          (element) =>
              element is LocalItemAction<T> ||
              element is LocalItemsGroup<T> && element.items.isNotEmpty,
        )
        .map(buildActionButton)
        .toList();

    return GestureDetector(
      onTap: onTap != null
          ? () => widget.onTap?.call(widget.ref, TapInfo.left())
          : null,
      onDoubleTap: onTap != null
          ? () => widget.onTap?.call(
                widget.ref,
                TapInfo.left(isDouble: true),
              )
          : null,
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovering = true),
        onExit: (event) => setState(() => isHovering = false),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: isHovering
                  ? widget.isHighlighted
                      ? 2.5
                      : 1
                  : widget.isHighlighted
                      ? 2
                      : 0.5,
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
              if (isHovering && actionButtons.isNotEmpty)
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actionButtons,
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
    required this.getItemId,
    required this.tileBuilder,
    required this.title,
    this.subTitle,
    this.headerColor,
    this.hideHeader = false,
    this.showSearchField = false,
    this.searchText,
    this.searchFieldHintText,
    this.decorateSearchField,
    this.footer,
    this.onSearchTextChanged,
    this.onTapItem,
    this.actions = const [],
    super.key,
  });

  static Key get keySearchField => Key('$ItemListViewer/search<field');

  final List<T> items;
  final Object Function(T item) getItemId;
  final ItemTile<T> Function(
    BuildContext context,
    ItemRef<T> ref,
    void Function(ItemRef<T> ref, TapInfo info)? onTap,
  ) tileBuilder;
  final String title;
  final String? subTitle;
  final Color? headerColor;
  final bool hideHeader;
  final bool showSearchField;
  final String? searchText;
  final String? searchFieldHintText;
  final Widget Function(BuildContext context, Widget searchField)?
      decorateSearchField;
  final Widget? footer;
  final void Function(String value)? onSearchTextChanged;
  final void Function(ItemRef<T> ref, TapInfo info)? onTapItem;
  final List<GlobalActionsElement<T>> actions;

  @override
  State<ItemListViewer<T>> createState() => _ItemListViewerState<T>();
}

class _ItemListViewerState<T> extends State<ItemListViewer<T>> {
  static const _searchDelay = Duration(milliseconds: 500);
  late final _searchTextController = TextEditingController(
    text: widget.searchText,
  );
  RestartableTimer? _searchDelayTimer;

  final _selectionIds = <Object>{};

  @override
  void dispose() {
    _searchDelayTimer?.cancel();
    _searchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refs = widget.items.map((e) {
      final id = widget.getItemId(e);

      return ItemRef(
        id: id,
        item: e,
        isSelected: _selectionIds.contains(id),
        onSelect: (value) {
          setState(() {
            if (value) {
              _selectionIds.add(id);
            } else {
              _selectionIds.remove(id);
            }
          });
        },
      );
    }).toList();

    List<ItemRef<T>> getItems([
      List<ItemRef<T>> Function(List<ItemRef<T>> refs)? filter,
    ]) =>
        filter?.call(refs) ?? refs;

    Widget buildActionButton(GlobalActionsElement element) {
      final icon = element.icon;
      final label = element.label;
      final key = element.key;

      if (element is GlobalItemsAction<T>) {
        return CollapsableButton(
          key: key,
          icon: icon,
          label: label,
          onPressed: () => element.onPressed(getItems(element.itemFilter)),
        );
      }

      if (element is GlobalItemsGroup<T>) {
        final items = element.items
            .map(
              (e) => ContextMenuItem(
                key: e.key,
                title: e.label,
                iconBuilder: (context, {color, size}) => e.icon ?? Container(),
                onPressed: () => e.onPressed(getItems(e.itemFilter)),
              ),
            )
            .toList();

        return CollapsableButton.contextMenu(
          key: key,
          label: label,
          icon: icon,
          items: items,
        );
      }

      throw Exception('Could not build global action button');
    }

    bool canDisplayButton(GlobalActionsElement<T> element) {
      if (element is GlobalItemsAction<T>) {
        return element.itemFilter == null ||
            getItems(element.itemFilter).isNotEmpty;
      }

      if (element is GlobalItemsGroup<T>) {
        return element.items.isNotEmpty &&
            element.items.every(
              (element) =>
                  element.itemFilter == null ||
                  getItems(element.itemFilter).isNotEmpty,
            );
      }

      return false;
    }

    final actionButtons =
        widget.actions.where(canDisplayButton).map(buildActionButton).toList();

    Widget? searchField;
    if (widget.showSearchField) {
      final baseSearchField = Row(
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
                      labelText: context.texts.labelSearch,
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
      );

      searchField =
          widget.decorateSearchField?.call(context, baseSearchField) ??
              baseSearchField;
    }

    final Widget? globalActionsBar;
    if (actionButtons.isNotEmpty) {
      globalActionsBar = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: FlexHorizontalContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final button in actionButtons)
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: button,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      globalActionsBar = null;
    }

    final listContent = Expanded(
      child: ListView.builder(
        itemCount: refs.length,
        itemBuilder: (context, index) {
          final ref = refs[index];

          return Row(
            children: [
              if (refs.any((element) => element.isSelected))
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.all(2),
                  child: Checkbox(
                    value: ref.isSelected,
                    onChanged: (value) => ref.onSelect?.call(value ?? false),
                  ),
                ),
              Expanded(
                child: widget.tileBuilder(
                  context,
                  ref,
                  widget.onTapItem,
                ),
              ),
            ],
          );
        },
      ),
    );

    final footer = widget.footer;

    return Column(
      children: [
        if (searchField != null) searchField,
        Expanded(
          child: ContentBox(
            header: !widget.hideHeader
                ? ContentBoxHeader.title(
                    title: widget.title,
                    subTitle: widget.subTitle,
                    color: widget.headerColor,
                  )
                : null,
            child: Column(
              children: [
                if (globalActionsBar != null) globalActionsBar,
                listContent,
                if (footer != null) footer,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
