import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/time_input_field.dart';
import 'package:simple_task_mate/widgets/content_box.dart';

class StampEntryTile extends StatefulWidget {
  const StampEntryTile({
    required this.stamp,
    this.isEditable = false,
    this.onDeleteStamp,
    super.key,
  });

  final Stamp stamp;
  final bool isEditable;
  final void Function(Stamp stamp)? onDeleteStamp;

  @override
  State<StatefulWidget> createState() => StampEntryTileState();
}

class StampEntryTileState extends State<StampEntryTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);
    final primaryTextStyle = primaryTextStyleFrom(context);

    final onDeleteStamp = widget.onDeleteStamp;

    var content = Container(
      height: 50,
      width: 200,
      margin: const EdgeInsets.all(8.0),
      decoration: widget.isEditable && isHovering
          ? BoxDecoration(
              border: Border.all(width: 0.5, color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            switch (widget.stamp.type) {
              StampType.arrival => context.texts.labelArrive,
              StampType.departure => context.texts.labelLeave,
              _ => '?',
            },
            style: primaryTextStyle,
          ),
          const SizedBox(width: 20),
          Text(
            DateFormat('HH:mm').format(widget.stamp.time),
            style: primaryTextStyle,
          ),
          if (widget.isEditable && isHovering) ...[
            const SizedBox(width: 50),
            IconButton(
              icon: IconUtils.trashCan(context),
              onPressed: onDeleteStamp != null
                  ? () => onDeleteStamp(widget.stamp)
                  : null,
            ),
          ],
        ],
      ),
    );

    return widget.isEditable
        ? MouseRegion(
            onEnter: (event) => setState(() => isHovering = true),
            onExit: (event) => setState(() => isHovering = false),
            child: content,
          )
        : content;
  }
}

class StampEntryViewer extends StatefulWidget {
  const StampEntryViewer({
    required this.stamps,
    this.titleStyle = TitleStyle.header,
    this.isManualMode = true,
    this.isLoading = false,
    this.onModeChanged,
    this.onSaveStamp,
    this.onDeleteStamp,
    super.key,
  });

  final List<Stamp> stamps;
  final TitleStyle titleStyle;
  final bool isManualMode;
  final bool isLoading;
  final ValueChanged<bool>? onModeChanged;
  final void Function(Stamp stamp)? onSaveStamp;
  final void Function(Stamp stamp)? onDeleteStamp;

  @override
  State<StatefulWidget> createState() => StampEntryViewerState();
}

class StampEntryViewerState extends State<StampEntryViewer> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isManualStampDeparture = false;

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
        event.logicalKey == LogicalKeyboardKey.controlRight) {
      if (event is KeyDownEvent) {
        setState(() => _isManualStampDeparture = true);
      } else if (event is KeyUpEvent) {
        setState(() => _isManualStampDeparture = false);
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final inversePrimaryColor = inversePrimaryColorFrom(context);
    final primaryStampButtonStyle = FilledButton.styleFrom(
      side: BorderSide(color: inversePrimaryColor, width: 2),
    );

    final onModeChanged = widget.onModeChanged;
    final onSaveStamp = widget.onSaveStamp;
    final onDeleteStamp = widget.onDeleteStamp;

    void onSaveStampType(StampType type) {
      if (widget.isManualMode) {
        final value = _textEditingController.text;
        final regex = RegExp(r'^\d{2}:\d{2}$');
        if (regex.hasMatch(value)) {
          final parts = value.split(':');
          final time = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );

          onSaveStamp?.call(
            Stamp(
              type: type,
              time: context
                  .read<DateTimeModel>()
                  .selectedDate
                  .copyWith(hour: time.hour, minute: time.minute),
            ),
          );

          _textEditingController.clear();
          _focusNode.requestFocus();
        }
      } else {
        onSaveStamp?.call(
          Stamp(
            type: type,
            time: context.read<DateTimeModel>().dateTime,
          ),
        );
      }
    }

    void submitTime(TimeOfDay time) {
      final stampTime = context.read<DateTimeModel>().selectedDate.copyWith(
            hour: time.hour,
            minute: time.minute,
          );

      final type = HardwareKeyboard.instance.isControlPressed
          ? StampType.departure
          : StampType.arrival;

      onSaveStamp?.call(
        Stamp(
          type: type,
          time: stampTime,
        ),
      );

      _textEditingController.clear();
      _focusNode.requestFocus();
    }

    return Column(
      children: [
        Expanded(
          child: ContentBox(
            title: context.texts.labelStamps,
            titleStyle: widget.titleStyle,
            child: widget.isLoading
                ? Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: widget.stamps.length,
                    itemBuilder: (context, index) => StampEntryTile(
                      stamp: widget.stamps[index],
                      isEditable: widget.isManualMode,
                      onDeleteStamp: onDeleteStamp,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.isManualMode)
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 200,
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerLeft,
                    child: TimeInputField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      autoFocus: true,
                      onSubmitted: onSaveStamp != null ? submitTime : null,
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    icon: IconUtils.leave(
                      context,
                      color: inversePrimaryColor,
                      size: 20,
                    ),
                    label: Text(context.texts.buttonStampArrive),
                    onPressed: onSaveStamp != null
                        ? () => onSaveStampType(StampType.arrival)
                        : null,
                    style: widget.isManualMode && !_isManualStampDeparture
                        ? primaryStampButtonStyle
                        : null,
                  ),
                  const SizedBox(width: 20),
                  FilledButton.icon(
                    icon: IconUtils.come(
                      context,
                      color: inversePrimaryColor,
                      size: 20,
                    ),
                    label: Text(context.texts.buttonStampLeave),
                    onPressed: onSaveStamp != null
                        ? () => onSaveStampType(StampType.departure)
                        : null,
                    style: widget.isManualMode && _isManualStampDeparture
                        ? primaryStampButtonStyle
                        : null,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: widget.isManualMode
                      ? IconUtils.squareClose(context)
                      : IconUtils.edit(context),
                  onPressed: onModeChanged != null
                      ? () => onModeChanged(!widget.isManualMode)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
