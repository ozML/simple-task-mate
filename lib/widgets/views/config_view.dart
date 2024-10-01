import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/controller_provider.dart';

class ConfigChangeModel extends ChangeNotifier {
  final _changes = <String, Object>{};

  operator [](String key) => _changes[key];
  operator []=(String key, Object value) {
    _changes[key] = value;
    notifyListeners();
  }

  bool get isEmpty => _changes.isEmpty;
  bool get isNotEmpty => _changes.isNotEmpty;

  List<(String, Object)> getChanges() =>
      _changes.entries.map((e) => (e.key, e.value)).toList();

  void clear({String? key}) {
    if (key != null) {
      _changes.remove(key);
    } else {
      _changes.clear();
    }
    notifyListeners();
  }
}

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

        final button = IconButton(
          icon: IconUtils.file(context),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
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

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => ConfigViewState();
}

class ConfigViewState extends State<ConfigView> {
  final _changeModel = ConfigChangeModel();

  @override
  Widget build(BuildContext context) {
    final primaryColor = primaryColorFrom(context);

    var body = ChangeNotifierProvider.value(
      value: _changeModel,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Divider(height: 1, color: primaryColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconUtils.gears(context),
              ),
              Text(
                context.texts.labelSettings,
                style: primaryTextStyleFrom(context, bold: true),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Divider(height: 1, color: primaryColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 800,
                  child: Column(
                    children: [
                      FileSelectionConfigTile(configKey: settingDbFilePath),
                      DropdownConfigTile<String, String>(
                        configKey: settingStyle,
                        itemsBuilder: (state) {
                          final options = ConfigModel.getDef(state.configKey)
                              .optionValues()
                              ?.whereType<ConfigEntryOption<String>>();

                          final items = options?.map(
                            (e) {
                              final label = switch (e.text) {
                                'abstract' => 'Abstract',
                                'windows' => 'Windows Material',
                                _ => ''
                              };

                              return DropdownMenuItem(
                                value: e.text,
                                child: Text(label),
                              );
                            },
                          ).toList();

                          return items ?? [];
                        },
                      ),
                      DropdownConfigTile<Locale, String>(
                        configKey: settingLanguage,
                        toItemValue: (configValue) => configValue.languageCode,
                        toConfigValue: (itemValue) => Locale(itemValue),
                        itemsBuilder: (state) {
                          final options = ConfigModel.getDef(state.configKey)
                              .optionValues()
                              ?.whereType<ConfigEntryOption<Locale>>();

                          final items = options?.map(
                            (e) {
                              final label = switch (e.text) {
                                'en' => context.texts.labelLanguageEnglish,
                                'de' => context.texts.labelLanguageGerman,
                                _ => ''
                              };

                              return DropdownMenuItem(
                                value: e.text,
                                child: Text(label),
                              );
                            },
                          ).toList();

                          return items ?? [];
                        },
                      ),
                      DropdownConfigTile<int, int>(
                        configKey: settingStartView,
                        itemsBuilder: (state) {
                          final options = ConfigModel.getDef(state.configKey)
                              .optionValues()
                              ?.whereType<ConfigEntryOption<int>>();

                          final items = options?.map(
                            (e) {
                              final label = switch (e.value) {
                                0 => context.texts.labelViewStamp,
                                1 => context.texts.labelViewTask,
                                _ => ''
                              };

                              return DropdownMenuItem(
                                value: e.value,
                                child: Text(label),
                              );
                            },
                          ).toList();

                          return items ?? [];
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Selector<ConfigModel, bool>(
                  selector: (context, model) => model.isModified,
                  builder: (context, value, _) {
                    return TextButton.icon(
                      icon: IconUtils.replay(context),
                      label: Text(context.texts.buttonReset),
                      onPressed: value
                          ? () => confirmConfigReset(
                                context: context,
                                action: () {
                                  final configModel =
                                      context.read<ConfigModel>();
                                  final defaultValues = ConfigModel.defs
                                      .map((e) => (
                                            e.key,
                                            e.fromText(e.defaultText),
                                          ))
                                      .toList();

                                  configModel.batchUpdate(defaultValues);

                                  // TODO restart app
                                },
                              )
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 20),
                Consumer<ConfigChangeModel>(
                  builder: (context, model, _) {
                    return TextButton.icon(
                      icon: IconUtils.check(context),
                      label: Text(context.texts.buttonApply),
                      onPressed: model.isNotEmpty
                          ? () {
                              final configModel = context.read<ConfigModel>();

                              void saveChanges() {
                                configModel.batchUpdate(model.getChanges());
                                model.clear();
                              }

                              final needsRestart = ConfigModel.restartNeeded(
                                model.getChanges().map((e) => e.$1).toList(),
                              );
                              if (needsRestart) {
                                confirmConfigChangeRestart(
                                  context: context,
                                  action: () {
                                    saveChanges();
                                    // TODO restart app
                                  },
                                );
                              } else {
                                saveChanges();
                              }
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            color: primaryColorFrom(context),
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: IconButton(
                icon: IconUtils.arrowLeft(
                  context,
                  color: inversePrimaryColorFrom(context),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Expanded(child: body)
        ],
      ),
    );
  }
}
