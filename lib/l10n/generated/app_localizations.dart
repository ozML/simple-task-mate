import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @buttonStampArrive.
  ///
  /// In en, this message translates to:
  /// **'Arrive'**
  String get buttonStampArrive;

  /// No description provided for @buttonStampLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get buttonStampLeave;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get buttonOk;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAdd;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get buttonApply;

  /// No description provided for @buttonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get buttonReset;

  /// No description provided for @buttonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get buttonBack;

  /// No description provided for @buttonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get buttonCopy;

  /// No description provided for @buttonCopyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get buttonCopyAll;

  /// No description provided for @buttonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get buttonEdit;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonSelection.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get buttonSelection;

  /// No description provided for @buttonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get buttonSelect;

  /// No description provided for @buttonDeselect.
  ///
  /// In en, this message translates to:
  /// **'Unselect'**
  String get buttonDeselect;

  /// No description provided for @buttonSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get buttonSelectAll;

  /// No description provided for @buttonDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Unselect all'**
  String get buttonDeselectAll;

  /// No description provided for @buttonMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get buttonMove;

  /// No description provided for @buttonToDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get buttonToDate;

  /// No description provided for @buttonToTask.
  ///
  /// In en, this message translates to:
  /// **'To Task'**
  String get buttonToTask;

  /// No description provided for @buttonMoveToDate.
  ///
  /// In en, this message translates to:
  /// **'Move to date'**
  String get buttonMoveToDate;

  /// No description provided for @buttonChangeStampType.
  ///
  /// In en, this message translates to:
  /// **'Change type'**
  String get buttonChangeStampType;

  /// No description provided for @labelArrive.
  ///
  /// In en, this message translates to:
  /// **'Arrive'**
  String get labelArrive;

  /// No description provided for @labelLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get labelLeave;

  /// No description provided for @labelPresentnessTime.
  ///
  /// In en, this message translates to:
  /// **'Working day'**
  String get labelPresentnessTime;

  /// No description provided for @labelWorkingTime.
  ///
  /// In en, this message translates to:
  /// **'Working time'**
  String get labelWorkingTime;

  /// No description provided for @labelPauseTime.
  ///
  /// In en, this message translates to:
  /// **'Pause time'**
  String get labelPauseTime;

  /// No description provided for @labelBookedTime.
  ///
  /// In en, this message translates to:
  /// **'Booked time'**
  String get labelBookedTime;

  /// No description provided for @labelRemainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining time'**
  String get labelRemainingTime;

  /// No description provided for @labelMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get labelMonday;

  /// No description provided for @labelTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get labelTuesday;

  /// No description provided for @labelWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get labelWednesday;

  /// No description provided for @labelThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get labelThursday;

  /// No description provided for @labelFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get labelFriday;

  /// No description provided for @labelSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get labelSaturday;

  /// No description provided for @labelSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get labelSunday;

  /// No description provided for @labelMondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get labelMondayShort;

  /// No description provided for @labelTuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get labelTuesdayShort;

  /// No description provided for @labelWednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wen'**
  String get labelWednesdayShort;

  /// No description provided for @labelThursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get labelThursdayShort;

  /// No description provided for @labelFridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get labelFridayShort;

  /// No description provided for @labelSaturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get labelSaturdayShort;

  /// No description provided for @labelSundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get labelSundayShort;

  /// No description provided for @labelWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get labelWeek;

  /// No description provided for @labelStamps.
  ///
  /// In en, this message translates to:
  /// **'Stamps'**
  String get labelStamps;

  /// No description provided for @labelTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get labelTasks;

  /// No description provided for @labelDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get labelDetails;

  /// No description provided for @labelEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get labelEntries;

  /// No description provided for @labelDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {time}'**
  String labelDuration(String time);

  /// No description provided for @labelSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get labelSearch;

  /// No description provided for @labelSelectedTask.
  ///
  /// In en, this message translates to:
  /// **'Selected task'**
  String get labelSelectedTask;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @labelSearchPlaceholderTaskEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter ref ID or title'**
  String get labelSearchPlaceholderTaskEntry;

  /// No description provided for @labelSearchIncludeEntries.
  ///
  /// In en, this message translates to:
  /// **'Search entries'**
  String get labelSearchIncludeEntries;

  /// No description provided for @labelAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get labelAddEntry;

  /// No description provided for @labelEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get labelEditEntry;

  /// No description provided for @labelNewTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get labelNewTask;

  /// No description provided for @labelTaskRefId.
  ///
  /// In en, this message translates to:
  /// **'Reference ID'**
  String get labelTaskRefId;

  /// No description provided for @labelTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get labelTaskTitle;

  /// No description provided for @labelTaskInfo.
  ///
  /// In en, this message translates to:
  /// **'Task description'**
  String get labelTaskInfo;

  /// No description provided for @labelTaskHRef.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get labelTaskHRef;

  /// No description provided for @labelTaskEntryInfo.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelTaskEntryInfo;

  /// No description provided for @labelTaskEntryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get labelTaskEntryDuration;

  /// No description provided for @labelSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get labelSettings;

  /// No description provided for @labelLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get labelLanguageGerman;

  /// No description provided for @labelLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get labelLanguageEnglish;

  /// No description provided for @labelViewStamp.
  ///
  /// In en, this message translates to:
  /// **'Stamp'**
  String get labelViewStamp;

  /// No description provided for @labelViewTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get labelViewTask;

  /// No description provided for @label24Hours.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get label24Hours;

  /// No description provided for @label12Hours.
  ///
  /// In en, this message translates to:
  /// **'12 hours'**
  String get label12Hours;

  /// No description provided for @labelTimeTrackingStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get labelTimeTrackingStandard;

  /// No description provided for @labelTimeTrackingDecimal.
  ///
  /// In en, this message translates to:
  /// **'Decimal'**
  String get labelTimeTrackingDecimal;

  /// No description provided for @labelPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get labelPattern;

  /// No description provided for @labelLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get labelLink;

  /// No description provided for @labelSettingDatabasePath.
  ///
  /// In en, this message translates to:
  /// **'Database path'**
  String get labelSettingDatabasePath;

  /// No description provided for @labelSettingStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get labelSettingStyle;

  /// No description provided for @labelSettingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelSettingLanguage;

  /// No description provided for @labelSettingStartView.
  ///
  /// In en, this message translates to:
  /// **'Start view'**
  String get labelSettingStartView;

  /// No description provided for @labelSettingInvertStampList.
  ///
  /// In en, this message translates to:
  /// **'Inverted stamp list order'**
  String get labelSettingInvertStampList;

  /// No description provided for @labelSettingAutoLinks.
  ///
  /// In en, this message translates to:
  /// **'Automatic links'**
  String get labelSettingAutoLinks;

  /// No description provided for @labelSettingAutoLinkGoups.
  ///
  /// In en, this message translates to:
  /// **'Automatic link groups'**
  String get labelSettingAutoLinkGoups;

  /// No description provided for @labelSettingClockTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Clock time format'**
  String get labelSettingClockTimeFormat;

  /// No description provided for @labelSettingTimeTrackingFormat.
  ///
  /// In en, this message translates to:
  /// **'Time tracking format'**
  String get labelSettingTimeTrackingFormat;

  /// No description provided for @dialogTitleStampDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete stamp'**
  String get dialogTitleStampDelete;

  /// No description provided for @dialogInfoStampDelete.
  ///
  /// In en, this message translates to:
  /// **'Stamp \"{type}\" at {time} will be deleted'**
  String dialogInfoStampDelete(String type, String time);

  /// No description provided for @dialogTitleStampDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected stamps'**
  String get dialogTitleStampDeleteSelected;

  /// No description provided for @dialogInfoStampDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected stamps will be deleted'**
  String get dialogInfoStampDeleteSelected;

  /// No description provided for @dialogTitleStampChangeType.
  ///
  /// In en, this message translates to:
  /// **'Change stamp type'**
  String get dialogTitleStampChangeType;

  /// No description provided for @dialogInfoStampChangeType.
  ///
  /// In en, this message translates to:
  /// **'Stamp \"{type}\" at {time} will be changed to \"{targetType}\"'**
  String dialogInfoStampChangeType(String type, String time, String targetType);

  /// No description provided for @dialogTitleStampMoveToDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Move selected stamps to date'**
  String get dialogTitleStampMoveToDateSelected;

  /// No description provided for @dialogInfoStampMoveToDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected stamps will be moved to the selected date'**
  String get dialogInfoStampMoveToDateSelected;

  /// No description provided for @dialogTitleTaskDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get dialogTitleTaskDelete;

  /// No description provided for @dialogInfoTaskDelete.
  ///
  /// In en, this message translates to:
  /// **'Task \n\"{title}\" \nwill be deleted'**
  String dialogInfoTaskDelete(String title);

  /// No description provided for @dialogTitleTaskEntryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete task entry'**
  String get dialogTitleTaskEntryDelete;

  /// No description provided for @dialogInfoTaskEntryDelete.
  ///
  /// In en, this message translates to:
  /// **'Task entry with info \"{info}\" will be deleted'**
  String dialogInfoTaskEntryDelete(String info);

  /// No description provided for @dialogTitleTaskEntryDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected task entries'**
  String get dialogTitleTaskEntryDeleteSelected;

  /// No description provided for @dialogInfoTaskEntryDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected entries of \n\"{title}\" \nwill be deleted'**
  String dialogInfoTaskEntryDeleteSelected(String title);

  /// No description provided for @dialogTitleTaskEntryMoveToDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Move selected task entries to date'**
  String get dialogTitleTaskEntryMoveToDateSelected;

  /// No description provided for @dialogInfoTaskEntryMoveToDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected entries of \n\"{title}\" \nwill be moved to the selected date'**
  String dialogInfoTaskEntryMoveToDateSelected(String title);

  /// No description provided for @dialogTitleTaskEntryMoveToTaskSelected.
  ///
  /// In en, this message translates to:
  /// **'Move selected task entries to task'**
  String get dialogTitleTaskEntryMoveToTaskSelected;

  /// No description provided for @dialogInfoTaskEntryMoveToTaskSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected entries of \n\"{title}\" \nwill be moved to the selected task'**
  String dialogInfoTaskEntryMoveToTaskSelected(String title);

  /// No description provided for @dialogTitleRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart required'**
  String get dialogTitleRestart;

  /// No description provided for @dialogInfoRestart.
  ///
  /// In en, this message translates to:
  /// **'Changes require restart.\nApply now?'**
  String get dialogInfoRestart;

  /// No description provided for @dialogTitleResetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get dialogTitleResetSettings;

  /// No description provided for @dialogInfoResetSettings.
  ///
  /// In en, this message translates to:
  /// **'The settings will be set back to default. \nRestart required for the changes to take effect.'**
  String get dialogInfoResetSettings;

  /// No description provided for @dialogTitleJumpToDate.
  ///
  /// In en, this message translates to:
  /// **'Jump to date?'**
  String get dialogTitleJumpToDate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
