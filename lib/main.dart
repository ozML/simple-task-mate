import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simple_task_mate/database/data_base_migration_helper.dart';
import 'package:simple_task_mate/models/config_model.dart';
import 'package:simple_task_mate/models/date_time_model.dart';
import 'package:simple_task_mate/models/stamp_model.dart';
import 'package:simple_task_mate/models/stamp_summary_model.dart';
import 'package:simple_task_mate/models/task_model.dart';
import 'package:simple_task_mate/models/task_summary_model.dart';
import 'package:simple_task_mate/widgets/views/stamp_view.dart';
import 'package:simple_task_mate/widgets/views/task_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  sqfliteFfiInit();

  await DatabBaseMigrationHelper.init(
    ConfigModel.initializeConfigFile()[settingDbFilePath]!,
  );

  initializeDateFormatting('en', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConfigModel()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => DateTimeModel()),
        ChangeNotifierProvider(create: (context) => StampModel()),
        ChangeNotifierProvider(create: (context) => StampSummaryModel()),
        ChangeNotifierProvider(create: (context) => TaskModel()),
        ChangeNotifierProvider(create: (context) => TaskSummaryModel()),
      ],
      builder: (context, __) {
        final config = context.watch<ConfigModel>();

        final home = switch (config[settingStartView]) {
          1 => const TaskView(),
          _ => const StampView()
        };

        final locale = (config[settingLanguage]) as Locale;

        return MaterialApp(
          title: 'Simple Task Mate',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: home,
        );
      },
    );
  }
}
