part of "config_model.dart";

class ConfigEntry<T extends Object> {
  const ConfigEntry({
    required this.key,
    required this.defaultText,
    required this.fromText,
    required String Function(T value) toText,
    bool Function(Object value)? isValid,
    this.options,
    this.isActive = true,
    this.needsRestart = false,
  })  : _toText = toText,
        _isValid = isValid;

  final String key;
  final String defaultText;
  final List<String>? options;
  final bool isActive;
  final bool needsRestart;
  final bool Function(Object value)? _isValid;
  final T Function(String text) fromText;
  final String Function(T value) _toText;

  Type get type => T;

  String toText(Object value) => _toText(value as T);

  bool isValid(Object value) => _isValid?.call(value) ?? value.runtimeType == T;

  List<ConfigEntryOption<T>>? optionValues() =>
      options?.map((e) => ConfigEntryOption(e, fromText(e))).toList();
}

class ConfigEntryOption<T> {
  ConfigEntryOption(this.text, this.value);

  final String text;
  final T value;
}

enum ClockTimeFormat {
  twelveHours,
  twentyFourHours,
}

final _entries = <ConfigEntry>[
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
  ConfigEntry<bool>(
    key: settingInvertStampList,
    defaultText: 'false',
    fromText: (text) => bool.tryParse(text) ?? false,
    toText: (value) => value.toString(),
  ),
  ConfigEntry<bool>(
    key: settingAutoLinks,
    defaultText: 'false',
    fromText: (text) => bool.tryParse(text) ?? false,
    toText: (value) => value.toString(),
  ),
  ConfigEntry<List<Tuple<String, String>>>(
    key: settingAutoLinkGroups,
    defaultText: '{"groups":[]}',
    fromText: (text) =>
        tryDecodeJson<List<Tuple<String, String>>>(
          text,
          convert: (data) => data['groups']
              .map((e) => Tuple(
                    e.entries.first.key as String,
                    e.entries.first.value as String,
                  ))
              .whereType<Tuple<String, String>>()
              .toList(),
        ) ??
        [],
    toText: (value) => jsonEncode({
      'groups': value.map((e) => {e.value0: e.value1}).toList(),
    }),
    isValid: (value) =>
        value.runtimeType == <Tuple<String, String>>[].runtimeType,
  ),
  ConfigEntry<ClockTimeFormat>(
    key: settingClockTimeFormat,
    defaultText: '24',
    options: ['24', '12'],
    fromText: (text) => switch (text) {
      '12' => ClockTimeFormat.twelveHours,
      _ => ClockTimeFormat.twentyFourHours,
    },
    toText: (value) => switch (value) {
      ClockTimeFormat.twelveHours => '12',
      ClockTimeFormat.twentyFourHours => '24',
    },
  ),
];
