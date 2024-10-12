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
import 'package:simple_task_mate/widgets/controller_provider.dart';
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
    super.key,
  });

  final String configKey;
  final Widget Function(BuildContext context, ConfigEntryTileState<T> state)
      builder;

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
                  child: state.change != null
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
