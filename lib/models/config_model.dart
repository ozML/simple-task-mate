import 'dart:io';

import 'package:flutter/material.dart';
import 'package:properties/properties.dart';

String get workDirectory =>
    '${Platform.environment['APPDATA']}\\ozml\\SimpleTaskMate';

String get propertiesPath => '$workDirectory\\app.properties';

class ConfigEntry<T extends Object> {
  const ConfigEntry({
    required this.key,
    required this.defaultText,
    required this.fromText,
    required String Function(T value) toText,
    this.options,
    this.isActive = true,
    this.needsRestart = false,
  }) : _toText = toText;

  final String key;
  final String defaultText;
  final List<String>? options;
  final bool isActive;
  final bool needsRestart;
  final T Function(String text) fromText;
  final String Function(T value) _toText;

  Type get type => T;

  String toText(Object value) => _toText(value as T);

  List<ConfigEntryOption<T>>? optionValues() =>
      options?.map((e) => ConfigEntryOption(e, fromText(e))).toList();
}

class ConfigEntryOption<T> {
  ConfigEntryOption(this.text, this.value);

  final String text;
  final T value;
}

const String settingDbFilePath = 'dbfilepath';
const String settingStyle = 'style';
const String settingLanguage = 'language';
const String settingStartView = 'startview';

class ConfigModel extends ChangeNotifier {
  static final defs = <ConfigEntry>[
    ConfigEntry<String>(
      key: settingDbFilePath,
      defaultText: '$workDirectory\\data.db',
      fromText: (text) => text,
      toText: (value) => value,
      needsRestart: true,
    ),
    ConfigEntry<String>(
      key: settingStyle,
      defaultText: 'abstract',
      options: ['abstract', 'windows'],
      fromText: (text) => text,
      toText: (value) => value,
      isActive: false,
    ),
    ConfigEntry<Locale>(
      key: settingLanguage,
      defaultText: 'en',
      options: ['en', 'de'],
      fromText: (text) => Locale(text),
      toText: (value) => value.languageCode,
    ),
    ConfigEntry<int>(
      key: settingStartView,
      defaultText: 'stamp',
      options: ['stamp', 'task'],
      fromText: (text) => switch (text) { 'task' => 1, _ => 0 },
      toText: (value) => switch (value) { 1 => 'task', _ => 'stamp' },
    ),
  ];

  final _values = <String, Object>{};

  operator [](String key) => _values[key];
  operator []=(String key, Object value) => update(key, value);

  bool get isInitialized => _values.isNotEmpty;

  bool get isModified =>
      defs.where((element) => element.isActive).any((element) =>
          element.toText(_values[element.key]!) != element.defaultText);

  static ConfigEntry getDef(String key) =>
      defs.firstWhere((element) => element.key == key);

  static Properties initializeConfigFile() {
    final file = File(propertiesPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    final properties = Properties.fromFile(file.path);
    for (final entry in defs) {
      if (entry.isActive) {
        properties.add(entry.key, entry.defaultText, false);
      }
    }
    properties.saveToFile(file.path);

    return properties;
  }

  static bool restartNeeded(List<String> changedKeys) {
    for (final key in changedKeys) {
      if (defs.firstWhere((element) => element.key == key).needsRestart) {
        return true;
      }
    }
    return false;
  }

  void initialize() {
    final properties = initializeConfigFile();
    for (final entry in defs) {
      if (entry.isActive) {
        final valueText = properties.get(entry.key)!;
        final value = entry.fromText(valueText);
        _values[entry.key] = value;
      }
    }
  }

  T getValue<T>(String key) => this[key] as T;

  bool _update(String key, Object change) {
    if (defs.firstWhere((element) => element.key == key) case ConfigEntry def
        when def.isActive) {
      if (change.runtimeType != def.type) {
        throw Exception();
      }

      final value = _values[key];
      if (change != value) {
        _values[key] = change;

        return true;
      }
    }

    return false;
  }

  void update(String key, Object change) {
    if (_update(key, change)) {
      final def = defs.firstWhere((element) => element.key == key);
      final properties = Properties.fromFile(propertiesPath);
      properties[key] = def.toText(change);

      properties.saveToFile(propertiesPath);

      notifyListeners();
    }
  }

  void batchUpdate(List<(String, Object)> changes) {
    final properties = Properties.fromFile(propertiesPath);

    bool canUpdate = false;
    for (final change in changes) {
      if (_update(change.$1, change.$2)) {
        final def = defs.firstWhere((element) => element.key == change.$1);
        properties[change.$1] = def.toText(change.$2);

        canUpdate = true;
      }
    }

    if (canUpdate) {
      properties.saveToFile(propertiesPath);

      notifyListeners();
    }
  }
}
