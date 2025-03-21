// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get buttonStampArrive => 'Kommt';

  @override
  String get buttonStampLeave => 'Geht';

  @override
  String get buttonOk => 'Bestätigen';

  @override
  String get buttonCancel => 'Abbrechen';

  @override
  String get buttonAdd => 'Hinzufügen';

  @override
  String get buttonSave => 'Speichern';

  @override
  String get buttonApply => 'Anwenden';

  @override
  String get buttonReset => 'Zurücksetzen';

  @override
  String get buttonBack => 'Zurück';

  @override
  String get buttonCopy => 'Kopieren';

  @override
  String get buttonCopyAll => 'Alles kopieren';

  @override
  String get buttonEdit => 'Bearbeiten';

  @override
  String get buttonDelete => 'Löschen';

  @override
  String get buttonSelection => 'Auswahl';

  @override
  String get buttonSelect => 'Auswählen';

  @override
  String get buttonDeselect => 'Abwählen';

  @override
  String get buttonSelectAll => 'Alles auswählen';

  @override
  String get buttonDeselectAll => 'Alles abwählen';

  @override
  String get buttonMove => 'Verschieben';

  @override
  String get buttonToDate => 'Zu Datum';

  @override
  String get buttonToTask => 'Zu Aufgabe';

  @override
  String get buttonMoveToDate => 'Zu Datum verschieben';

  @override
  String get buttonChangeStampType => 'Typ ändern';

  @override
  String get labelArrive => 'Kommt';

  @override
  String get labelLeave => 'Geht';

  @override
  String get labelPresentnessTime => 'Arbeitstag';

  @override
  String get labelWorkingTime => 'Arbeitszeit';

  @override
  String get labelPauseTime => 'Pause';

  @override
  String get labelBookedTime => 'Gebuchte Zeit';

  @override
  String get labelRemainingTime => 'Verbleibende Zeit';

  @override
  String get labelMonday => 'Montag';

  @override
  String get labelTuesday => 'Dienstag';

  @override
  String get labelWednesday => 'Mitwoch';

  @override
  String get labelThursday => 'Donnerstag';

  @override
  String get labelFriday => 'Freitag';

  @override
  String get labelSaturday => 'Samstag';

  @override
  String get labelSunday => 'Sonntag';

  @override
  String get labelMondayShort => 'Mo';

  @override
  String get labelTuesdayShort => 'Di';

  @override
  String get labelWednesdayShort => 'Mi';

  @override
  String get labelThursdayShort => 'Do';

  @override
  String get labelFridayShort => 'Fr';

  @override
  String get labelSaturdayShort => 'Sa';

  @override
  String get labelSundayShort => 'So';

  @override
  String get labelWeek => 'Woche';

  @override
  String get labelStamps => 'Stempelungen';

  @override
  String get labelTasks => 'Aufgaben';

  @override
  String get labelDetails => 'Details';

  @override
  String get labelEntries => 'Einträge';

  @override
  String labelDuration(String time) {
    return 'Dauer: $time';
  }

  @override
  String get labelSearch => 'Suche';

  @override
  String get labelSelectedTask => 'Selektierte Aufgabe';

  @override
  String get labelDescription => 'Beschreibung';

  @override
  String get labelSearchPlaceholderTaskEntry => 'Ref ID oder Titel angeben';

  @override
  String get labelSearchIncludeEntries => 'Einträge durchsuchen';

  @override
  String get labelAddEntry => 'Eintrag hinzufügen';

  @override
  String get labelEditEntry => 'Eintrag bearbeiten';

  @override
  String get labelNewTask => 'Neue Aufgabe';

  @override
  String get labelTaskRefId => 'Referenz ID';

  @override
  String get labelTaskTitle => 'Aufgabentitel';

  @override
  String get labelTaskInfo => 'Aufgabenbeschreibung';

  @override
  String get labelTaskHRef => 'Link';

  @override
  String get labelTaskEntryInfo => 'Beschreibung';

  @override
  String get labelTaskEntryDuration => 'Dauer';

  @override
  String get labelSettings => 'Einstellungen';

  @override
  String get labelLanguageGerman => 'Deutsch';

  @override
  String get labelLanguageEnglish => 'Englisch';

  @override
  String get labelViewStamp => 'Stempeln';

  @override
  String get labelViewTask => 'Aufgaben';

  @override
  String get label24Hours => '24 Stunden';

  @override
  String get label12Hours => '12 Stunden';

  @override
  String get labelTimeTrackingStandard => 'Standard';

  @override
  String get labelTimeTrackingDecimal => 'Dezimal';

  @override
  String get labelPattern => 'Pattern';

  @override
  String get labelLink => 'Link';

  @override
  String get labelSettingDatabasePath => 'Datenbankpfad';

  @override
  String get labelSettingStyle => 'Stil';

  @override
  String get labelSettingLanguage => 'Sprache';

  @override
  String get labelSettingStartView => 'Startansicht';

  @override
  String get labelSettingInvertStampList => 'Umgekehrte Sortierung der Stempelliste';

  @override
  String get labelSettingAutoLinks => 'Automatische Links';

  @override
  String get labelSettingAutoLinkGoups => 'Automatische Link Gruppen';

  @override
  String get labelSettingClockTimeFormat => 'Uhrzeitformat';

  @override
  String get labelSettingTimeTrackingFormat => 'Zeiterfassungsformat';

  @override
  String get dialogTitleStampDelete => 'Stempelung löschen';

  @override
  String dialogInfoStampDelete(String type, String time) {
    return 'Die \"$type\" Stempelung um $time wird gelöscht';
  }

  @override
  String get dialogTitleStampDeleteSelected => 'Ausgewählte Stempelungen löschen';

  @override
  String get dialogInfoStampDeleteSelected => 'Die ausgewählten Stempelungen werden gelöscht';

  @override
  String get dialogTitleStampChangeType => 'Stempeltyp ändern';

  @override
  String dialogInfoStampChangeType(String type, String time, String targetType) {
    return 'Die \"$type\" Stempelung um $time wird in \"$targetType\" geändert';
  }

  @override
  String get dialogTitleStampMoveToDateSelected => 'Augewählte Stempelungen zum Datum verschieben';

  @override
  String get dialogInfoStampMoveToDateSelected => 'Die ausgewählten Stempelungen werden zum ausgewählten Datum verschoben';

  @override
  String get dialogTitleTaskDelete => 'Aufgabe löschen';

  @override
  String dialogInfoTaskDelete(String title) {
    return 'Die Aufgabe \n\"$title\" \nwird gelöscht';
  }

  @override
  String get dialogTitleTaskEntryDelete => 'Aufgabeneintrag löschen';

  @override
  String dialogInfoTaskEntryDelete(String info) {
    return 'Eintrag mit Beschreibung \"$info\" wird gelöscht';
  }

  @override
  String get dialogTitleTaskEntryDeleteSelected => 'Ausgewählte Aufgabeneinträge löschen';

  @override
  String dialogInfoTaskEntryDeleteSelected(String title) {
    return 'Ausgewählte Einträge der Aufgabe \n\"$title\" \nwerden gelöscht';
  }

  @override
  String get dialogTitleTaskEntryMoveToDateSelected => 'Ausgewählte Aufgabeneinträge zum Datum verschieben';

  @override
  String dialogInfoTaskEntryMoveToDateSelected(String title) {
    return 'Ausgewählte Einträge der Aufgabe \n\"$title\" \nwerden zum ausgewählten Datum verschoben';
  }

  @override
  String get dialogTitleTaskEntryMoveToTaskSelected => 'Ausgewählte Aufgabeneinträge zur Aufgabe verschieben';

  @override
  String dialogInfoTaskEntryMoveToTaskSelected(String title) {
    return 'Ausgewählte Einträge der Aufgabe \n\"$title\" \nwerden zur ausgewählten Aufgabe verschoben';
  }

  @override
  String get dialogTitleRestart => 'Neustart erforderlich';

  @override
  String get dialogInfoRestart => 'Änderungen sind nach Neustart verfügbar.\nJetzt anwenden?';

  @override
  String get dialogTitleResetSettings => 'Einstellungen zurücksetzen';

  @override
  String get dialogInfoResetSettings => 'Die Einstellungen werden auf die Standardwerte zurückgesetzt. \nDie Änderungen sind nach Neustarz verfügbar.';

  @override
  String get dialogTitleJumpToDate => 'Zum Datum wechseln?';
}
