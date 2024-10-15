import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef EditableRowBuider<T> = TableRow Function(
  BuildContext context,
  int index,
  T item,
  bool isEditMode,
  void Function() toggleEditMode,
);

class TableRowHeightConstraints {
  const TableRowHeightConstraints(double this.height)
      : minHeight = 0,
        maxHeight = null;

  const TableRowHeightConstraints.min(double this.minHeight)
      : height = null,
        maxHeight = null;

  const TableRowHeightConstraints.max(double this.maxHeight)
      : height = null,
        minHeight = null;

  final double? height;
  final double? minHeight;
  final double? maxHeight;
}

class EditableTable<T extends Object> extends StatefulWidget {
  const EditableTable({
    required this.items,
    required this.header,
    required this.rowBuilder,
    this.footer,
    this.columnWidths,
    this.defaultColumnWidth = const FlexColumnWidth(),
    this.rowHeight,
    this.textDirection,
    this.border,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.top,
    this.textBaseline,
    super.key,
  });

  final List<T> items;
  final TableRow header;
  final TableRow? footer;
  final Map<int, TableColumnWidth>? columnWidths;
  final TableColumnWidth defaultColumnWidth;
  final TableRowHeightConstraints? rowHeight;
  final TextDirection? textDirection;
  final TableBorder? border;
  final TableCellVerticalAlignment defaultVerticalAlignment;
  final TextBaseline? textBaseline;
  final EditableRowBuider<T> rowBuilder;

  @override
  State<EditableTable> createState() => _EditableTableState<T>();
}

class _EditableTableState<T extends Object> extends State<EditableTable<T>> {
  int? editIndex;

  @override
  Widget build(BuildContext context) {
    final rowHeight = widget.rowHeight;
    final footer = widget.footer;

    return Table(
      columnWidths: widget.columnWidths,
      defaultColumnWidth: widget.defaultColumnWidth,
      textDirection: widget.textDirection,
      border: widget.border,
      defaultVerticalAlignment: widget.defaultVerticalAlignment,
      textBaseline: widget.textBaseline,
      children: [
        widget.header,
        ...widget.items.mapIndexed(
          (i, e) {
            final row = widget.rowBuilder(
              context,
              i,
              e,
              i == editIndex,
              () => setState(() {
                editIndex = i != editIndex ? i : null;
              }),
            );

            if (rowHeight != null) {
              return TableRow(
                key: row.key,
                decoration: row.decoration,
                children: row.children
                    .map((e) => Container(
                          constraints: rowHeight.minHeight != null
                              ? BoxConstraints(
                                  minHeight: rowHeight.minHeight ?? 0,
                                )
                              : rowHeight.maxHeight != null
                                  ? BoxConstraints(
                                      maxHeight: rowHeight.maxHeight ??
                                          double.infinity,
                                    )
                                  : null,
                          height: rowHeight.height,
                          child: e,
                        ))
                    .toList(),
              );
            }

            return row;
          },
        ),
        if (footer != null) footer,
      ],
    );
  }
}
