import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('th'),
    Locale('vi'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Startup Launcher'**
  String get appName;

  /// Title for the home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for the language selection option
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Label for the theme selection option
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Label for the light theme selection option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Label for the dark theme selection option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Label for the auto theme selection option
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Label for onboarding skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Label for onboarding next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Label for onboarding getStarted
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Label for onboarding title 1
  ///
  /// In en, this message translates to:
  /// **'Launch ideas faster'**
  String get onboardingTitle1;

  /// Label for onboarding title 1 description
  ///
  /// In en, this message translates to:
  /// **'Start your next Flutter app with production-ready architecture, themes, routing, and localization already setup.'**
  String get onboardingDesc1;

  /// Label for onboarding title 2
  ///
  /// In en, this message translates to:
  /// **'Built for serious startups'**
  String get onboardingTitle2;

  /// Label for onboarding title 2 description
  ///
  /// In en, this message translates to:
  /// **'Use clean structure, scalable state management, networking, and CI/CD from day one.'**
  String get onboardingDesc2;

  /// Label for onboarding title 3
  ///
  /// In en, this message translates to:
  /// **'Save weeks of setup'**
  String get onboardingTitle3;

  /// Label for onboarding title 3 description
  ///
  /// In en, this message translates to:
  /// **'No more repeating flavors, rename configs, tests, icons, or boilerplate every new project.'**
  String get onboardingDesc3;

  /// Label for onboarding title 4
  ///
  /// In en, this message translates to:
  /// **'Build. Launch. Grow.'**
  String get onboardingTitle4;

  /// Label for onboarding title 4 description
  ///
  /// In en, this message translates to:
  /// **'Focus on solving real problems and shipping products faster with Startup Launch.'**
  String get onboardingDesc4;

  /// Label for library screen title
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Home section title for trending manga
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// Home section title for latest updated manga
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// Home section title for popular manga
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// Placeholder text in manga search field
  ///
  /// In en, this message translates to:
  /// **'Search manga ...'**
  String get searchMangaHint;

  /// Search manga screen title
  ///
  /// In en, this message translates to:
  /// **'Search manga'**
  String get searchManga;

  /// Message when no manga search result found
  ///
  /// In en, this message translates to:
  /// **'Manga not found'**
  String get mangaNotFound;

  /// Action text when search returns no result
  ///
  /// In en, this message translates to:
  /// **'Clear and try again'**
  String get clearAndTryAgain;

  /// General label for manga items
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get manga;

  /// Status label indicating content loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get loaded;

  /// Plural label for pages
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// Section title for manga summary
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Singular label for page
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Plural label for chapter section
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// Singular label for chapter
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// Label for favorite manga section
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Label for continue reading section
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// Message shown when user has no favorite manga yet
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// Title shown on routing error screen
  ///
  /// In en, this message translates to:
  /// **'Navigation error'**
  String get navigationError;

  /// Fallback message when route error is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown routing error'**
  String get unknownRoutingError;

  /// Generic retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title shown when selected chapter cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Chapter Unavailable'**
  String get chapterUnavailable;

  /// Button label to open the next available chapter
  ///
  /// In en, this message translates to:
  /// **'Try Next Available'**
  String get tryNextAvailable;

  /// Button label to open the previous available chapter
  ///
  /// In en, this message translates to:
  /// **'Try Previous'**
  String get tryPrevious;

  /// Button label to return to chapter list
  ///
  /// In en, this message translates to:
  /// **'Back to Chapters'**
  String get backToChapters;
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
      <String>['en', 'ja', 'th', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
