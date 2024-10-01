import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

class TimeTicker extends StatelessWidget {
  const TimeTicker({required this.time, super.key});

  final DateTime time;

  @override
  Widget build(BuildContext context) => Text(
        DateFormat('HH:mm:ss').format(time),
        style: bigPrimaryTextStyleFrom(context),
      );
}
