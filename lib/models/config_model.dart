import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:properties/properties.dart';
import 'package:simple_task_mate/utils/conversion_utils.dart';
import 'package:simple_task_mate/utils/tuple.dart';

part "config_entries.dart";

String get workDirectory =>
    '${Platform.environment['APPDATA']}\\ozml\\SimpleTaskMate';

String get propertiesPath => '$workDirectory\\app.properties';

const String settingDbFilePath = 'dbfilepath';
const String settingStyle = 'style';
const String settingLanguage = 'language';
const String settingStartView = 'startview';
const String settingInvertStampList = 'invertStampList';
const String settingAutoLinks = 'autolinks';
const String settingAutoLinkGroups = 'autolinkgroups';
const String settingClockTimeFormat = 'clocktimeformat';

class ConfigModel extends ChangeNotifier {
  static final defs = _entries;

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
      if (!def.isValid(change)) {
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
