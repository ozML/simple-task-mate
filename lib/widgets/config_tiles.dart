import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/utils/tuple.dart';
import 'package:simple_task_mate/widgets/controller_provider.dart';
import 'package:simple_task_mate/widgets/editable_table.dart';
import 'package:simple_task_mate/widgets/views/config_view.dart';

class ConfigEntryTileState<T> with EquatableMixin {
  const ConfigEntryTileState({
    required this.configKey,
    required this.value,
    required this.change,
  });

  final String configKey;
  final T value;
  final T? change;

  T get currentValue => change ?? value;

  @override
  List<Object?> get props => [configKey, value, change];
}

class ConfigEntryTile<T extends Object> extends StatelessWidget {
  const ConfigEntryTile({
    required this.configKey,
    required this.builder,
    this.disableReset = false,
    super.key,
  });

  final String configKey;
  final Widget Function(BuildContext context, ConfigEntryTileState<T> state)
      builder;
  final bool disableReset;

  @nonVirtual
  @override
  Widget build(BuildContext context) =>
      Selector2<ConfigModel, ConfigChangeModel, ConfigEntryTileState<T>?>(
        selector: (context, configModel, changeModel) {
          final value = configModel[configKey];
          if (value != null) {
            return ConfigEntryTileState(
              configKey: configKey,
              value: value,
              change: changeModel[configKey],
            );
          }

          return null;
        },
        builder: (context, state, child) {
          final entry = ConfigModel.getDef(configKey);
          if (state == null || !entry.isActive) {
            return const SizedBox();
          }

          final label = switch (configKey) {
            settingDbFilePath => context.texts.labelSettingDatabasePath,
            settingStyle => context.texts.labelSettingStyle,
            settingLanguage => context.texts.labelSettingLanguage,
            settingStartView => context.texts.labelSettingStartView,
            settingAutoLinks => context.texts.labelSettingAutoLinks,
            settingAutoLinkGroups => context.texts.labelSettingAutoLinkGoups,
            settingClockTimeFormat => context.texts.labelSettingClockTimeFormat,
            _ => ''
          };

          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  style: primaryTextStyleFrom(context, bold: true),
                ),
                Text(configKey, style: secondaryTextStyleFrom(context)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: builder(context, state),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: !disableReset && state.change != null
                      ? IconButton(
                          icon: IconUtils.replay(context),
                          onPressed: () => context
                              .read<ConfigChangeModel>()
                              .clear(key: configKey),
                        )
                      : null,
                ),
              ],
            ),
          );
        },
      );
}

class DropdownConfigTile<T extends Object, S extends Object>
    extends ConfigEntryTile<T> {
  DropdownConfigTile({
    required super.configKey,
    required this.itemsBuilder,
    this.toItemValue,
    this.toConfigValue,
    super.key,
  })  : assert(toItemValue != null || toItemValue == null && T == S, ''),
        assert(toConfigValue != null || toConfigValue == null && T == S, ''),
        super(
          builder: (context, state) => buildContent<T, S>(
            context,
            state,
            toItemValue,
            toConfigValue,
            itemsBuilder,
          ),
        );

  final S Function(T configValue)? toItemValue;
  final T Function(S itemValue)? toConfigValue;
  final List<DropdownMenuItem<S>> Function(ConfigEntryTileState<T> state)
      itemsBuilder;

  static Widget buildContent<T extends Object, S extends Object>(
    BuildContext context,
    ConfigEntryTileState<T> state,
    final S Function(T configValue)? toItemValue,
    final T Function(S itemValue)? toConfigValue,
    List<DropdownMenuItem<S>> Function(ConfigEntryTileState<T> state)
        itemsBuilder,
  ) {
    return InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<S>(
          value:
              toItemValue?.call(state.currentValue) ?? state.currentValue as S,
          isDense: true,
          isExpanded: true,
          items: itemsBuilder(state),
          onChanged: (newValue) {
            if (newValue != null) {
              context.read<ConfigChangeModel>()[state.configKey] =
                  toConfigValue?.call(newValue) ?? newValue as T;
            }
          },
        ),
      ),
    );
  }
}

class FileSelectionConfigTile extends ConfigEntryTile<String> {
  FileSelectionConfigTile({
    super.key,
    required super.configKey,
    this.fileExtensions,
  }) : super(
          builder: (context, state) =>
              buildContent(context, state, fileExtensions),
        );

  final List<String>? fileExtensions;

  static Widget buildContent(
    BuildContext context,
    ConfigEntryTileState<String> state,
    List<String>? fileExtensions,
  ) {
    return TextEditingControllerProvider(
      builder: (_, controller) {
        void updateValue(value) {
          context.read<ConfigChangeModel>()[state.configKey] = value;
        }

        final input = TextFormField(
          controller: controller..text = state.currentValue,
          decoration: textInputDecoration(context),
          onChanged: updateValue,
        );

        final file = File(state.value);

        final button = IconButton(
          icon: IconUtils.file(context),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              initialDirectory:
                  file.statSync().type == FileSystemEntityType.directory
                      ? file.path
                      : file.parent.path,
              type: fileExtensions?.isNotEmpty == true
                  ? FileType.custom
                  : FileType.any,
              allowedExtensions: fileExtensions,
            );
            if (result != null) {
              updateValue(result.files.single.path!);
            }
          },
        );

        return Row(
          children: [
            Expanded(child: input),
            const SizedBox(width: 10),
            button,
          ],
        );
      },
    );
  }
}

class BinaryStateConfigTile extends ConfigEntryTile<bool> {
  BinaryStateConfigTile({
    required super.configKey,
    super.key,
  }) : super(
          builder: (context, state) => Align(
            alignment: Alignment.centerLeft,
            child: Checkbox(
              value: state.currentValue,
              onChanged: (value) {
                if (value != null) {
                  context.read<ConfigChangeModel>()[state.configKey] = value;
                }
              },
            ),
          ),
        );
}

class TableConfigTile extends ConfigEntryTile<List<Tuple<String, String>>> {
  const TableConfigTile({
    required super.configKey,
    super.key,
  }) : super(builder: buildContent, disableReset: true);

  static Widget buildContent(
    BuildContext context,
    ConfigEntryTileState<List<Tuple<String, String>>> state,
  ) {
    final data = state.currentValue;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditableTable(
            header: TableRow(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.texts.labelPattern,
                    style: primaryTextStyleFrom(context),
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.texts.labelLink,
                    style: primaryTextStyleFrom(context),
                  ),
                ),
                const SizedBox(),
              ],
            ),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: IntrinsicColumnWidth()
            },
            rowHeight: const TableRowHeightConstraints.min(50),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            items: data,
            rowBuilder: (context, index, item, isEditMode, toggleEditMode) {
              final config = context.read<ConfigModel>();
              final changeModel = context.read<ConfigChangeModel>();

              final List<Widget> content;
              if (isEditMode) {
                content = [
                  TextEditingControllerProvider(
                    initialText: item.value0,
                    builder: (context, controller) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: textInputDecoration(context),
                        controller: controller,
                        onChanged: (value) {
                          changeModel[state.configKey] = data.toList()
                            ..[index] = item.copyWith(value0: value);
                        },
                      ),
                    ),
                  ),
                  TextEditingControllerProvider(
                    initialText: item.value1,
                    builder: (context, controller) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: textInputDecoration(context),
                        controller: controller,
                        onChanged: (value) {
                          changeModel[state.configKey] = data.toList()
                            ..[index] = item.copyWith(value1: value);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (changeModel.hasChanges(key: state.configKey))
                          IconButton(
                            icon: IconUtils.check(context),
                            onPressed: () {
                              config.update(state.configKey, data);
                              changeModel.clear();
                              toggleEditMode();
                            },
                          )
                        else
                          const SizedBox(width: 40),
                        IconButton(
                          icon: IconUtils.squareClose(context),
                          onPressed: () {
                            changeModel.clear(key: state.configKey);
                            toggleEditMode();
                          },
                        ),
                      ],
                    ),
                  ),
                ];
              } else {
                content = [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(item.value0),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(item.value1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: IconUtils.edit(context),
                          onPressed: toggleEditMode,
                        ),
                        IconButton(
                          icon: IconUtils.trashCan(context),
                          onPressed: () {
                            config.update(
                              state.configKey,
                              data.toList()..removeAt(index),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ];
              }

              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 0.5)),
                ),
                children: content,
              );
            },
          ),
          TextEditingControllerListProvider(
            count: 2,
            builder: (context, controllers) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 0.5)),
                ),
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: textInputDecoration(context),
                          controller: controllers[0],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: textInputDecoration(context),
                          controller: controllers[1],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 8, 8, 8),
                      child: IconButton(
                        icon: IconUtils.add(context),
                        onPressed: () {
                          final pattern = controllers[0].text;
                          final link = controllers[1].text;

                          if (pattern.isNotEmpty && link.isNotEmpty) {
                            context.read<ConfigModel>().update(
                                  state.configKey,
                                  state.value.toList()
                                    ..add(Tuple(pattern, link)),
                                );
                            controllers[0].clear();
                            controllers[1].clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
