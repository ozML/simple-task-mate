import 'package:flutter/material.dart';
import 'package:simple_task_mate/widgets/views/config_view.dart';
import 'package:simple_task_mate/widgets/views/stamp_view.dart';
import 'package:simple_task_mate/widgets/views/task_summary_view.dart';
import 'package:simple_task_mate/widgets/views/task_view.dart';

PageRouteBuilder get stampViewRoute => PageRouteBuilder(
      pageBuilder: (_, __, ___) => const StampView(),
    );

PageRouteBuilder get taskViewRoute => PageRouteBuilder(
      pageBuilder: (_, __, ___) => const TaskView(),
    );

PageRouteBuilder get taskSummaryViewRoute => PageRouteBuilder(
      pageBuilder: (_, __, ___) => const TaskSummaryView(),
    );

PageRouteBuilder get configViewRoute => PageRouteBuilder(
      pageBuilder: (_, __, ___) => const ConfigView(),
    );
