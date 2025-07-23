import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @americanSoldiers.
  ///
  /// In en, this message translates to:
  /// **'(American soldiers in Iraq), '**
  String get americanSoldiers;

  /// No description provided for @amongOthers.
  ///
  /// In en, this message translates to:
  /// **'among others.'**
  String get amongOthers;

  /// No description provided for @andWar.
  ///
  /// In en, this message translates to:
  /// **'and War '**
  String get andWar;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @asylum.
  ///
  /// In en, this message translates to:
  /// **'(Asylum seekers from Venezuela), '**
  String get asylum;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get chooseImage;

  /// No description provided for @citizens.
  ///
  /// In en, this message translates to:
  /// **'(Citizens and communities of Madison, WI), '**
  String get citizens;

  /// No description provided for @climateChange.
  ///
  /// In en, this message translates to:
  /// **'Climate Change '**
  String get climateChange;

  /// No description provided for @climatScientist.
  ///
  /// In en, this message translates to:
  /// **'(Climate scientists worldwide), '**
  String get climatScientist;

  /// No description provided for @confirmRestart.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restart'**
  String get confirmRestart;

  /// No description provided for @democracy.
  ///
  /// In en, this message translates to:
  /// **'Democracy '**
  String get democracy;

  /// No description provided for @drawingName.
  ///
  /// In en, this message translates to:
  /// **'Drawing Name'**
  String get drawingName;

  /// No description provided for @ericChanisAnAmerican.
  ///
  /// In en, this message translates to:
  /// **'Eric Chan is an American contemporary visual artist known for his multi-disciplinary practice. He often creates artworks through participatory means with the public, and his projects investigate subjects, events and people that shape society.'**
  String get ericChanisAnAmerican;

  /// No description provided for @ericChanReceived.
  ///
  /// In en, this message translates to:
  /// **'Eric Chan received his BA from UC Berkeley and his MFA from Columbia University. His artworks and projects have been presented and participated in publicly in museums and cultural institutions. His artworks are in the permanent collections of museums internationally.'**
  String get ericChanReceived;

  /// No description provided for @firstNations.
  ///
  /// In en, this message translates to:
  /// **'First Nations '**
  String get firstNations;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @hoChunk.
  ///
  /// In en, this message translates to:
  /// **'(Ho-Chunk Nation), '**
  String get hoChunk;

  /// No description provided for @humanTrafficking.
  ///
  /// In en, this message translates to:
  /// **'Human Trafficking '**
  String get humanTrafficking;

  /// No description provided for @montageAcetates.
  ///
  /// In en, this message translates to:
  /// **'Montage Acetates'**
  String get montageAcetates;

  /// No description provided for @overrideChanges.
  ///
  /// In en, this message translates to:
  /// **'This will override your current changes and starts a new one.'**
  String get overrideChanges;

  /// No description provided for @refugees.
  ///
  /// In en, this message translates to:
  /// **'Refugees '**
  String get refugees;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @restartMessage.
  ///
  /// In en, this message translates to:
  /// **'This will erase all your current changes and start a new drawing.\nThis action cannot be undone. Do you want to proceed?'**
  String get restartMessage;

  /// No description provided for @revolution.
  ///
  /// In en, this message translates to:
  /// **'Revolution '**
  String get revolution;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveDrawing.
  ///
  /// In en, this message translates to:
  /// **'Save Drawing'**
  String get saveDrawing;

  /// No description provided for @statelessChildren.
  ///
  /// In en, this message translates to:
  /// **'(Stateless Children in Chiang Mai, Thailand), '**
  String get statelessChildren;

  /// No description provided for @studentsAndCitizen.
  ///
  /// In en, this message translates to:
  /// **'(students and citizens in Cairo during the Arab Spring), '**
  String get studentsAndCitizen;

  /// No description provided for @tapToPreview.
  ///
  /// In en, this message translates to:
  /// **'Tap to preview'**
  String get tapToPreview;

  /// No description provided for @ukraine.
  ///
  /// In en, this message translates to:
  /// **'(Ukraine-Russia), '**
  String get ukraine;

  /// No description provided for @processDrawing.
  ///
  /// In en, this message translates to:
  /// **'Process Drawing'**
  String get processDrawing;

  /// No description provided for @processDrawingWasConceived.
  ///
  /// In en, this message translates to:
  /// **'Process Drawing was conceived by Eric Chan and has been created for you.'**
  String get processDrawingWasConceived;

  /// No description provided for @processDrawingAndMontage.
  ///
  /// In en, this message translates to:
  /// **'\"Process Drawing\" and \"Montage Acetates\" are copyright © Eric A. Chan.'**
  String get processDrawingAndMontage;

  /// No description provided for @war.
  ///
  /// In en, this message translates to:
  /// **'War '**
  String get war;

  /// No description provided for @workingGlobally.
  ///
  /// In en, this message translates to:
  /// **'Working globally, the communities and themes of Eric Chan\'s artworks and projects include '**
  String get workingGlobally;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
