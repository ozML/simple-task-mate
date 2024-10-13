import 'package:flutter/material.dart';

Color primaryColorFrom(BuildContext context) =>
    Theme.of(context).colorScheme.primary;

Color inversePrimaryColorFrom(BuildContext context) =>
    Theme.of(context).colorScheme.inversePrimary;

TextStyle? primaryTextStyleFrom(BuildContext context, {bool bold = false}) {
  final theme = Theme.of(context);

  return theme.textTheme.titleLarge?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

TextStyle? secondaryTextStyleFrom(BuildContext context, {bool bold = false}) {
  final theme = Theme.of(context);

  return theme.textTheme.labelLarge?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

TextStyle? bigPrimaryTextStyleFrom(BuildContext context, {bool bold = false}) {
  final theme = Theme.of(context);

  return theme.textTheme.displayLarge?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: bold ? FontWeight.bold : null,
  );
}

InputDecoration textInputDecoration(
  BuildContext context, {
  String? labelText,
  String? suffixLabelText,
  String? hintText,
}) =>
    InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColorFrom(context)),
        borderRadius: BorderRadius.circular(16),
      ),
      labelText:
          labelText != null ? '$labelText ${suffixLabelText ?? ''}' : null,
      hintText: hintText,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
