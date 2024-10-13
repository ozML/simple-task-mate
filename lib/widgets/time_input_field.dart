import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';

// Source: https://stackoverflow.com/questions/70086464/flutter-input-time-in-hhmmss-format-in-textformfield-or-textfield-without-usin
class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.contains(":") &&
        !newValue.text.contains(":") &&
        newValue.text.length == 2) {
      return newValue;
    }
    String value = newValue.text;
    if (newValue.text.length == 1) {
      value = int.parse(newValue.text).clamp(0, 2).toString();
    } else if (newValue.text.length == 2) {
      value =
          '${int.parse(newValue.text).clamp(0, 23).toString().padLeft(2, '0')}:';
    } else if (newValue.text.length == 3) {
      value =
          '${int.parse(newValue.text.substring(0, 2)).clamp(0, 23).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(2)).clamp(0, 5)}';
    } else if (newValue.text.length == 4) {
      value =
          '${newValue.text.substring(0, 2).toString().padLeft(2, '0')}:${int.parse(newValue.text.substring(2)).clamp(0, 59).toString().padLeft(2, '0')}';
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

class TimeInputField extends StatefulWidget {
  const TimeInputField({
    required this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.decoration,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autoFocus;
  final InputDecoration? decoration;
  final ValueChanged<TimeOfDay>? onSubmitted;

  @override
  TimeInputFieldState createState() => TimeInputFieldState();
}

class TimeInputFieldState extends State<TimeInputField> {
  @override
  Widget build(BuildContext context) {
    final onSubmitted = widget.onSubmitted;

    final baseDecoration = widget.decoration ?? textInputDecoration(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      decoration: baseDecoration.copyWith(hintText: '00:00'),
      textAlign: TextAlign.center,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        TimeTextInputFormatter(),
      ],
      onFieldSubmitted: onSubmitted != null
          ? (value) {
              final regex = RegExp(r'^\d{2}:\d{2}$');
              if (regex.hasMatch(value)) {
                final parts = value.split(':');

                onSubmitted(
                  TimeOfDay(
                    hour: int.parse(parts[0]),
                    minute: int.parse(parts[1]),
                  ),
                );
              }
            }
          : null,
      autofocus: widget.autoFocus,
    );
  }
}
