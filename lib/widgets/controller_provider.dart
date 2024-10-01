import 'package:flutter/material.dart';

class ControllerProvider<T extends Object> extends StatefulWidget {
  const ControllerProvider({
    required this.create,
    required this.builder,
    this.dispose,
    super.key,
  });

  final T Function() create;
  final void Function(T controller)? dispose;
  final Widget Function(BuildContext context, T controller) builder;

  @override
  State createState() => ControllerProviderState<T>();
}

class ControllerProviderState<T extends Object>
    extends State<ControllerProvider<T>> {
  late final T controller = widget.create();

  @override
  void dispose() {
    widget.dispose?.call(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controller);
}

class TextEditingControllerProvider
    extends ControllerProvider<TextEditingController> {
  TextEditingControllerProvider({required super.builder, super.key})
      : super(
          create: () => TextEditingController(),
          dispose: (controller) => controller.dispose(),
        );
}
