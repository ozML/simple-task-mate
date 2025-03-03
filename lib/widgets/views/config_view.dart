import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_task_mate/extensions/context.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/utils/dialog_utils.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/theme_utils.dart';
import 'package:simple_task_mate/widgets/config_tiles.dart';

class ConfigChangeModel extends ChangeNotifier {
  final _changes = <String, Object>{};

  operator [](String key) => _changes[key];
  operator []=(String key, Object value) {
    _changes[key] = value;
    notifyListeners();
  }

  bool get isEmpty => _changes.isEmpty;
  bool get isNotEmpty => _changes.isNotEmpty;

  bool hasChanges({String? key}) =>
      key != null ? _changes.containsKey(key) : isNotEmpty;

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

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => ConfigViewState();
}

class ConfigViewState extends State<ConfigView> {
  final _changeModel = ConfigChangeModel();

  @override
  Widget build(BuildContext context) {
    final configModel = context.watch<ConfigModel>();
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
                      DropdownConfigTile<ClockTimeFormat, ClockTimeFormat>(
                        configKey: settingClockTimeFormat,
                        itemsBuilder: (state) {
                          final options = ConfigModel.getDef(state.configKey)
                              .optionValues()
                              ?.whereType<ConfigEntryOption<ClockTimeFormat>>();

                          final items = options?.map(
                            (e) {
                              final label = switch (e.value) {
                                ClockTimeFormat.twentyFourHours =>
                                  context.texts.label24Hours,
                                ClockTimeFormat.twelveHours =>
                                  context.texts.label12Hours,
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
                      DropdownConfigTile<DurationFormat, DurationFormat>(
                        configKey: settingTimeTrackingFormat,
                        itemsBuilder: (state) {
                          final options = ConfigModel.getDef(state.configKey)
                              .optionValues()
                              ?.whereType<ConfigEntryOption<DurationFormat>>();

                          final items = options?.map(
                            (e) {
                              final label = switch (e.value) {
                                DurationFormat.standard =>
                                  context.texts.labelTimeTrackingStandard,
                                DurationFormat.decimal =>
                                  context.texts.labelTimeTrackingDecimal,
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
                      BinaryStateConfigTile(configKey: settingInvertStampList),
                      BinaryStateConfigTile(configKey: settingAutoLinks),
                      if (configModel.getValue(settingAutoLinks))
                        const TableConfigTile(configKey: settingAutoLinkGroups),
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
