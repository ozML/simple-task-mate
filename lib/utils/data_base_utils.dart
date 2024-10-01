import 'package:simple_task_mate/extensions/object_extension.dart';

enum Order {
  none,
  ascending,
  descending;

  String get statement => switch (this) {
        Order.ascending => 'ASC',
        Order.descending => 'DESC',
        _ => ''
      };
}

class ColumnOrder {
  ColumnOrder({required this.column, this.order = Order.ascending});

  ColumnOrder.asc(String column) : this(column: column, order: Order.ascending);

  ColumnOrder.desc(String column)
      : this(column: column, order: Order.descending);

  final String column;
  final Order order;

  OrderBy toOrderBy() => OrderBy(columnOrders: [this]);
}

class OrderBy {
  const OrderBy({required this.columnOrders});

  OrderBy.asc({required List<String> columns})
      : this(
          columnOrders: columns
              .map((e) => ColumnOrder(column: e, order: Order.ascending))
              .toList(),
        );

  OrderBy.desc({required List<String> columns})
      : this(
          columnOrders: columns
              .map((e) => ColumnOrder(column: e, order: Order.descending))
              .toList(),
        );

  const OrderBy.none() : columnOrders = const [];
  final List<ColumnOrder> columnOrders;

  bool get isEmpty => columnOrders.isEmpty;

  String get statement => columnOrders
      .map((e) => '${e.column} ${e.order.statement}')
      .join(', ')
      .mapTo((e) => e.isNotEmpty ? 'ORDER BY $e' : e);
}
