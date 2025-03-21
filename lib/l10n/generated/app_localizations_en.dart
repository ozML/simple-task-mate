// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get buttonStampArrive => 'Arrive';

  @override
  String get buttonStampLeave => 'Leave';

  @override
  String get buttonOk => 'Ok';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonAdd => 'Add';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonApply => 'Apply';

  @override
  String get buttonReset => 'Reset';

  @override
  String get buttonBack => 'Back';

  @override
  String get buttonCopy => 'Copy';

  @override
  String get buttonCopyAll => 'Copy all';

  @override
  String get buttonEdit => 'Edit';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonSelection => 'Selection';

  @override
  String get buttonSelect => 'Select';

  @override
  String get buttonDeselect => 'Unselect';

  @override
  String get buttonSelectAll => 'Select all';

  @override
  String get buttonDeselectAll => 'Unselect all';

  @override
  String get buttonMove => 'Move';

  @override
  String get buttonToDate => 'To Date';

  @override
  String get buttonToTask => 'To Task';

  @override
  String get buttonMoveToDate => 'Move to date';

  @override
  String get buttonChangeStampType => 'Change type';

  @override
  String get labelArrive => 'Arrive';

  @override
  String get labelLeave => 'Leave';

  @override
  String get labelPresentnessTime => 'Working day';

  @override
  String get labelWorkingTime => 'Working time';

  @override
  String get labelPauseTime => 'Pause time';

  @override
  String get labelBookedTime => 'Booked time';

  @override
  String get labelRemainingTime => 'Remaining time';

  @override
  String get labelMonday => 'Monday';

  @override
  String get labelTuesday => 'Tuesday';

  @override
  String get labelWednesday => 'Wednesday';

  @override
  String get labelThursday => 'Thursday';

  @override
  String get labelFriday => 'Friday';

  @override
  String get labelSaturday => 'Saturday';

  @override
  String get labelSunday => 'Sunday';

  @override
  String get labelMondayShort => 'Mon';

  @override
  String get labelTuesdayShort => 'Tue';

  @override
  String get labelWednesdayShort => 'Wen';

  @override
  String get labelThursdayShort => 'Thu';

  @override
  String get labelFridayShort => 'Fri';

  @override
  String get labelSaturdayShort => 'Sat';

  @override
  String get labelSundayShort => 'Sun';

  @override
  String get labelWeek => 'Week';

  @override
  String get labelStamps => 'Stamps';

  @override
  String get labelTasks => 'Tasks';

  @override
  String get labelDetails => 'Details';

  @override
  String get labelEntries => 'Entries';

  @override
  String labelDuration(String time) {
    return 'Duration: $time';
  }

  @override
  String get labelSearch => 'Search';

  @override
  String get labelSelectedTask => 'Selected task';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelSearchPlaceholderTaskEntry => 'Enter ref ID or title';

  @override
  String get labelSearchIncludeEntries => 'Search entries';

  @override
  String get labelAddEntry => 'Add entry';

  @override
  String get labelEditEntry => 'Edit entry';

  @override
  String get labelNewTask => 'New task';

  @override
  String get labelTaskRefId => 'Reference ID';

  @override
  String get labelTaskTitle => 'Task title';

  @override
  String get labelTaskInfo => 'Task description';

  @override
  String get labelTaskHRef => 'Link';

  @override
  String get labelTaskEntryInfo => 'Description';

  @override
  String get labelTaskEntryDuration => 'Duration';

  @override
  String get labelSettings => 'Settings';

  @override
  String get labelLanguageGerman => 'German';

  @override
  String get labelLanguageEnglish => 'English';

  @override
  String get labelViewStamp => 'Stamp';

  @override
  String get labelViewTask => 'Task';

  @override
  String get label24Hours => '24 hours';

  @override
  String get label12Hours => '12 hours';

  @override
  String get labelTimeTrackingStandard => 'Standard';

  @override
  String get labelTimeTrackingDecimal => 'Decimal';

  @override
  String get labelPattern => 'Pattern';

  @override
  String get labelLink => 'Link';

  @override
  String get labelSettingDatabasePath => 'Database path';

  @override
  String get labelSettingStyle => 'Style';

  @override
  String get labelSettingLanguage => 'Language';

  @override
  String get labelSettingStartView => 'Start view';

  @override
  String get labelSettingInvertStampList => 'Inverted stamp list order';

  @override
  String get labelSettingAutoLinks => 'Automatic links';

  @override
  String get labelSettingAutoLinkGoups => 'Automatic link groups';

  @override
  String get labelSettingClockTimeFormat => 'Clock time format';

  @override
  String get labelSettingTimeTrackingFormat => 'Time tracking format';

  @override
  String get dialogTitleStampDelete => 'Delete stamp';

  @override
  String dialogInfoStampDelete(String type, String time) {
    return 'Stamp \"$type\" at $time will be deleted';
  }

  @override
  String get dialogTitleStampDeleteSelected => 'Delete selected stamps';

  @override
  String get dialogInfoStampDeleteSelected => 'Selected stamps will be deleted';

  @override
  String get dialogTitleStampChangeType => 'Change stamp type';

  @override
  String dialogInfoStampChangeType(String type, String time, String targetType) {
    return 'Stamp \"$type\" at $time will be changed to \"$targetType\"';
  }

  @override
  String get dialogTitleStampMoveToDateSelected => 'Move selected stamps to date';

  @override
  String get dialogInfoStampMoveToDateSelected => 'Selected stamps will be moved to the selected date';

  @override
  String get dialogTitleTaskDelete => 'Delete task';

  @override
  String dialogInfoTaskDelete(String title) {
    return 'Task \n\"$title\" \nwill be deleted';
  }

  @override
  String get dialogTitleTaskEntryDelete => 'Delete task entry';

  @override
  String dialogInfoTaskEntryDelete(String info) {
    return 'Task entry with info \"$info\" will be deleted';
  }

  @override
  String get dialogTitleTaskEntryDeleteSelected => 'Delete selected task entries';

  @override
  String dialogInfoTaskEntryDeleteSelected(String title) {
    return 'Selected entries of \n\"$title\" \nwill be deleted';
  }

  @override
  String get dialogTitleTaskEntryMoveToDateSelected => 'Move selected task entries to date';

  @override
  String dialogInfoTaskEntryMoveToDateSelected(String title) {
    return 'Selected entries of \n\"$title\" \nwill be moved to the selected date';
  }

  @override
  String get dialogTitleTaskEntryMoveToTaskSelected => 'Move selected task entries to task';

  @override
  String dialogInfoTaskEntryMoveToTaskSelected(String title) {
    return 'Selected entries of \n\"$title\" \nwill be moved to the selected task';
  }

  @override
  String get dialogTitleRestart => 'Restart required';

  @override
  String get dialogInfoRestart => 'Changes require restart.\nApply now?';

  @override
  String get dialogTitleResetSettings => 'Reset settings';

  @override
  String get dialogInfoResetSettings => 'The settings will be set back to default. \nRestart required for the changes to take effect.';

  @override
  String get dialogTitleJumpToDate => 'Jump to date?';
}
