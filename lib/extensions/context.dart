import 'package:flutter/material.dart';
import 'package:simple_task_mate/l10n/generated/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get texts => AppLocalizations.of(this)!;
}
