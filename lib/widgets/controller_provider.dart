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

class ControllerListProvider<T extends Object> extends StatefulWidget {
  const ControllerListProvider({
    required this.create,
    required this.builder,
    this.dispose,
    super.key,
  });

  final List<T> Function() create;
  final void Function(List<T> controllers)? dispose;
  final Widget Function(BuildContext context, List<T> controllers) builder;

  @override
  State createState() => ControllerListProviderState<T>();
}

class ControllerListProviderState<T extends Object>
    extends State<ControllerListProvider<T>> {
  late final List<T> controllers = widget.create();

  @override
  void dispose() {
    widget.dispose?.call(controllers);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controllers);
}

class TextEditingControllerProvider
    extends ControllerProvider<TextEditingController> {
  TextEditingControllerProvider({
    required super.builder,
    String? initialText,
    super.key,
  }) : super(
          create: () => TextEditingController(text: initialText),
          dispose: (controller) => controller.dispose(),
        );
}

class TextEditingControllerListProvider
    extends ControllerListProvider<TextEditingController> {
  TextEditingControllerListProvider({
    required int count,
    required super.builder,
    List<String?>? initialTexts,
    super.key,
  }) : super(
          create: () => List.generate(
            count,
            (index) => TextEditingController(text: initialTexts?[index]),
          ),
          dispose: (controllers) {
            for (final controller in controllers) {
              controller.dispose;
            }
          },
        );
}
