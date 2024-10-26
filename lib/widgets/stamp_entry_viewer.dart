import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/services/api.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/time_input_field.dart';
import 'package:simple_task_mate/widgets/content_box.dart';

class StampEntryTile extends StatefulWidget {
  const StampEntryTile({
    required this.stamp,
    this.clockTimeFormat = ClockTimeFormat.twentyFourHours,
    this.locale = const Locale('en'),
    this.isEditable = false,
    this.onDeleteStamp,
    super.key,
  });

  static Key get keyTypeText => Key('$StampEntryTile/typeText');
  static Key get keyTimeText => Key('$StampEntryTile/timeText');
  static Key get keyActionDelete => Key('$StampEntryTile/actionDelete');

  final Stamp stamp;
  final ClockTimeFormat clockTimeFormat;
  final Locale locale;
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

    final clockTimeFormat = switch (widget.clockTimeFormat) {
      ClockTimeFormat.twelveHours => 'hh:mm a',
      _ => 'HH:mm',
    };
    final languageCode = widget.locale.languageCode;

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
            key: StampEntryTile.keyTypeText,
            switch (widget.stamp.type) {
              StampType.arrival => context.texts.labelArrive,
              StampType.departure => context.texts.labelLeave,
              _ => '?',
            },
            style: primaryTextStyle,
          ),
          const SizedBox(width: 20),
          Text(
            key: StampEntryTile.keyTimeText,
            DateFormat(clockTimeFormat, languageCode).format(widget.stamp.time),
            style: primaryTextStyle,
          ),
          if (widget.isEditable && isHovering) ...[
            const SizedBox(width: 50),
            IconButton(
              key: StampEntryTile.keyActionDelete,
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
    required this.date,
    required this.getTime,
    this.titleStyle = TitleStyle.header,
    this.clockTimeFormat = ClockTimeFormat.twentyFourHours,
    this.locale = const Locale('en'),
    this.isManualMode = true,
    this.isStampDisabled = false,
    this.isLoading = false,
    this.onModeChanged,
    this.onSaveStamp,
    this.onDeleteStamp,
    super.key,
  });

  static Key get keyLoadingIndicator =>
      Key('$StampEntryViewer/loadingIndicator');
  static Key get keyItemTile => Key('$StampEntryViewer/itemTile');
  static Key get keyManualTimeInput => Key('$StampEntryViewer/manualTimeInput');
  static Key get keyButtonArrive => Key('$StampEntryViewer/buttonArrive');
  static Key get keyButtonLeave => Key('$StampEntryViewer/buttonLeave');
  static Key get keyToggleStampMode => Key('$StampEntryViewer/togglStampMode');

  final List<Stamp> stamps;
  final DateTime date;
  final TitleStyle titleStyle;
  final ClockTimeFormat clockTimeFormat;
  final Locale locale;
  final bool isManualMode;
  final bool isStampDisabled;
  final bool isLoading;
  final DateTime Function() getTime;
  final ValueChanged<bool>? onModeChanged;
  final void Function(Stamp stamp)? onSaveStamp;
  final void Function(Stamp stamp)? onDeleteStamp;

  static Widget fromProvider({
    required BuildContext context,
    TitleStyle titleStyle = TitleStyle.header,
    bool isManualMode = true,
    ValueChanged<bool>? onModeChanged,
    void Function(Stamp stamp)? onSaveStamp,
    void Function(Stamp stamp)? onDeleteStamp,
    Key? key,
  }) {
    final locale = context.select<ConfigModel, Locale>(
      (value) => value.getValue(settingLanguage),
    );
    final clockTimeFormat = context.select<ConfigModel, ClockTimeFormat>(
      (value) => value.getValue(settingClockTimeFormat),
    );

    final selectedDate = context.select<DateTimeModel, DateTime>(
      (value) => value.selectedDate,
    );
    final currentDate = context.select<DateTimeModel, DateTime>(
      (value) => value.date,
    );
    final isCurrentDate = selectedDate == currentDate;

    final stampModel = context.watch<StampModel>();
    final stamps = stampModel.stamps;
    final isLoading = stampModel.isLoading;

    return StampEntryViewer(
      stamps: stamps,
      date: selectedDate,
      getTime: () => context.read<DateTimeModel>().dateTime,
      titleStyle: titleStyle,
      clockTimeFormat: clockTimeFormat,
      locale: locale,
      isManualMode: isManualMode,
      isStampDisabled: !isCurrentDate,
      isLoading: isLoading,
      onModeChanged: onModeChanged,
      onSaveStamp: onSaveStamp,
      onDeleteStamp: onDeleteStamp,
      key: key,
    );
  }

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
              time: widget.date.copyWith(hour: time.hour, minute: time.minute),
            ),
          );

          _textEditingController.clear();
          _focusNode.requestFocus();
        }
      } else {
        onSaveStamp?.call(
          Stamp(
            type: type,
            time: widget.getTime(),
          ),
        );
      }
    }

    void submitTime(TimeOfDay time) {
      final stampTime = widget.date.copyWith(
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

    final stamps = widget.stamps.reversed.toList();

    return Column(
      children: [
        Expanded(
          child: ContentBox(
            title: context.texts.labelStamps,
            titleStyle: widget.titleStyle,
            child: widget.isLoading
                ? Container(
                    key: StampEntryViewer.keyLoadingIndicator,
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: stamps.length,
                    itemBuilder: (context, index) => StampEntryTile(
                      key: StampEntryViewer.keyItemTile,
                      stamp: stamps[index],
                      locale: widget.locale,
                      clockTimeFormat: widget.clockTimeFormat,
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
                      key: StampEntryViewer.keyManualTimeInput,
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      autoFocus: true,
                      onSubmitted: onSaveStamp != null ? submitTime : null,
                    ),
                  ),
                ),
              if (!widget.isStampDisabled || widget.isManualMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      key: StampEntryViewer.keyButtonArrive,
                      icon: IconUtils.come(
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
                      key: StampEntryViewer.keyButtonLeave,
                      icon: IconUtils.leave(
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
                )
              else
                const SizedBox(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  key: StampEntryViewer.keyToggleStampMode,
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
