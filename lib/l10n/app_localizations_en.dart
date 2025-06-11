// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get chooseImage => 'Choose Image';

  @override
  String get confirmRestart => 'Confirm Restart';

  @override
  String get drawingName => 'Drawing Name';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get montageAcetates => 'Montage Acetates';

  @override
  String get overrideChanges =>
      'This will override your current changes and starts a new one.';

  @override
  String get restart => 'Restart';

  @override
  String get restartMessage =>
      'This will erase all your current changes and start a new drawing.\nThis action cannot be undone. Do you want to proceed?';

  @override
  String get save => 'Save';

  @override
  String get saveDrawing => 'Save Drawing';

  @override
  String get tapToPreview => 'Tap to preview';
}
