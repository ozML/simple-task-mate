import 'package:flutter/material.dart';

class SizeBuilder extends StatefulWidget {
  const SizeBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, Size? size) builder;

  @override
  State<SizeBuilder> createState() => _SizeBuilderState();
}

class _SizeBuilderState extends State<SizeBuilder> {
  Size? _currentSize;

  @override
  void initState() {
    super.initState();

    _updateSize(context);
  }

  void _updateSize(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (context.size case Size? size when size != _currentSize) {
          setState(() => _currentSize = size);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _updateSize(context);

        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: widget.builder(context, _currentSize),
      ),
    );
  }
}
