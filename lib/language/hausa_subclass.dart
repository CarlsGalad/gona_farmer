import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';

class HaMaterialLocalizations extends GlobalMaterialLocalizations {
  const HaMaterialLocalizations({
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required localeName,
    applicationName = 'YourAppName',
    licenseCount = 5,
    firstRow = 1,
    lastRow = 10,
    rowCount = 50,
    tabIndex = 1,
    tabCount = 3,
    fullDate = '25/12/2024',
  }) : super(
          localeName: '',
        );

  static const int licenseCount = 5;

  static const int firstRow = 1;
  static const int lastRow = 10;
  static const int rowCount = 50;
  static const int tabIndex = 1;
  static const int tabCount = 3;
  static DateTime fullDate = DateTime(2024, 12, 25);

  String get welcomeMessage => "Barka da zuwa kasuwar Gona";
  String get emailHint => "Imel";
  String get passwordHint => "Kalmar sirri";
  String get forgotPassword => "An manta kalmar sirri?";
  String get signIn => "Shiga";
  String get orContinueWith => "Ko ci gaba da";
  String get dontHaveAccount => "Ba ku da asusu?";
  String get signUpNow => "Yi rajista yanzu";
  String get loading => "Ana loda...";
  String get userNotFound => "Ba a samu mai amfani ba";
  String get error => "Kuskure";
  String get welcomeBack => "Barka da zuwa!";
  String get ordersCount => "Nau'ukan";
  String get processedOrders => "Nau'ukan da aka samu";
  String get deliveredItems => "Kayayyakin da aka kai";
  String get totalSales => "Nau'in dukan";
  String get totalEarnings => "Samar da dukan";
  String get todaysTask => "Ayyukan yau";
  String get addItem => "Kara abu";
  String get inventory => "Kariyar jumla";
  String get manageItemsData => "Yin bayanin data na abu";
  String get addPromoItem => "Kara abu na bada";
  String get promotions => "Gajeren";
  String get managePromotionsData => "Yin bayanin data na gajeren";
  String get noInternetConnection => "Babu tallafi na intanet";
  String get retry => "Duba";
  String get profile => "Bayanin martaba";
  String get notifications => "Sanarwar";
  String get settings => "Saituna";
  String get about => "Game da mu";
  String get helpCenter => "Cibiyar Taimako";
  @override
  String get moreButtonTooltip => 'Karin bayani';

  //application name as a static constant
  static const String applicationName = 'Gona Farmers';

  @override
  String get aboutListTileTitleRaw => 'Game da $applicationName';

  @override
  String get alertDialogLabel => 'Faɗakarwa';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Koma baya';

  @override
  String get bottomSheetLabel => 'Ƙarƙashin takarda';

  @override
  String get calendarModeButtonLabel => 'Yanayin kalanda';

  @override
  String get cancelButtonLabel => 'Soke';

  @override
  String get closeButtonLabel => 'Rufe';

  @override
  String get closeButtonTooltip => 'Rufe';

  @override
  String get collapsedHint => 'An runtse';

  @override
  String get collapsedIconTapHint => 'Buɗe';

  @override
  String get continueButtonLabel => 'Ci gaba';

  @override
  String get copyButtonLabel => 'Kwafi';

  @override
  String get currentDateLabel => 'Yau';

  @override
  String get cutButtonLabel => 'Yanke';

  @override
  String get dateHelpText => 'Shigar da kwanan wata';

  @override
  String get dateInputLabel => 'Shigar da kwanan wata';

  @override
  String get dateOutOfRangeLabel => 'Kwanan wata baya cikin kewayo';

  @override
  String get datePickerHelpText => 'Zaɓi kwanan wata';

  @override
  String get dateRangeEndDateSemanticLabelRaw =>
      'Ƙarshen kwanan wata $fullDate';

  @override
  String get dateRangeEndLabel => 'Ƙarshen kwanan wata';

  @override
  String get dateRangePickerHelpText => 'Zaɓi kewayon kwanan wata';

  @override
  String get dateRangeStartDateSemanticLabelRaw =>
      'Farkon kwanan wata $fullDate';

  @override
  String get dateRangeStartLabel => 'Farkon kwanan wata';

  @override
  String get dateSeparator => '/';

  @override
  String get deleteButtonTooltip => 'Share';

  @override
  String get dialModeButtonLabel => 'Yanayin kira';

  @override
  String get dialogLabel => 'Tattaunawa';

  @override
  String get drawerLabel => 'Menu';

  @override
  String get expandedHint => 'An buɗe';

  @override
  String get expandedIconTapHint => 'Runtse';

  @override
  String get expansionTileCollapsedHint => 'An runtse';

  @override
  String get expansionTileCollapsedTapHint => 'Buɗe';

  @override
  String get expansionTileExpandedHint => 'An buɗe';

  @override
  String get expansionTileExpandedTapHint => 'Runtse';

  @override
  String get firstPageTooltip => 'Shafi na farko';

  @override
  String get hideAccountsLabel => 'Ɓoye asusu';

  @override
  String get inputDateModeButtonLabel => 'Yanayin shigar da kwanan wata';

  @override
  String get invalidDateFormatLabel => 'Tsarin kwanan wata mara inganci';

  @override
  String get invalidDateRangeLabel => 'Kewayon kwanan wata mara inganci';

  @override
  String get invalidTimeLabel => 'Lokaci mara inganci';

  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyChannelDown => 'Channel Down';

  @override
  String get keyboardKeyChannelUp => 'Channel Up';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Delete';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'End';

  @override
  String get keyboardKeyEscape => 'Escape';

  @override
  String get keyboardKeyFn => 'Fn';

  @override
  String get keyboardKeyHome => 'Home';

  @override
  String get keyboardKeyInsert => 'Insert';

  @override
  String get keyboardKeyMeta => 'Meta';

  @override
  String get keyboardKeyMetaMacOs => 'Command';

  @override
  String get keyboardKeyMetaWindows => 'Windows';

  @override
  String get keyboardKeyNumLock => 'Num Lock';

  @override
  String get keyboardKeyNumpad0 => 'Numpad 0';

  @override
  String get keyboardKeyNumpad1 => 'Numpad 1';

  @override
  String get keyboardKeyNumpad2 => 'Numpad 2';

  @override
  String get keyboardKeyNumpad3 => 'Numpad 3';

  @override
  String get keyboardKeyNumpad4 => 'Numpad 4';

  @override
  String get keyboardKeyNumpad5 => 'Numpad 5';

  @override
  String get keyboardKeyNumpad6 => 'Numpad 6';

  @override
  String get keyboardKeyNumpad7 => 'Numpad 7';

  @override
  String get keyboardKeyNumpad8 => 'Numpad 8';

  @override
  String get keyboardKeyNumpad9 => 'Numpad 9';

  @override
  String get keyboardKeyNumpadAdd => 'Numpad Add';

  @override
  String get keyboardKeyNumpadComma => 'Numpad Comma';

  @override
  String get keyboardKeyNumpadDecimal => 'Numpad Decimal';

  @override
  String get keyboardKeyNumpadDivide => 'Numpad Divide';

  @override
  String get keyboardKeyNumpadEnter => 'Numpad Enter';

  @override
  String get keyboardKeyNumpadEqual => 'Numpad Equal';

  @override
  String get keyboardKeyNumpadMultiply => 'Numpad Multiply';

  @override
  String get keyboardKeyNumpadParenLeft => 'Numpad (';

  @override
  String get keyboardKeyNumpadParenRight => 'Numpad )';

  @override
  String get keyboardKeyNumpadSubtract => 'Numpad Subtract';

  @override
  String get keyboardKeyPageDown => 'Page Down';

  @override
  String get keyboardKeyPageUp => 'Page Up';

  @override
  String get keyboardKeyPower => 'Power';

  @override
  String get keyboardKeyPowerOff => 'Power Off';

  @override
  String get keyboardKeyPrintScreen => 'Print Screen';

  @override
  String get keyboardKeyScrollLock => 'Scroll Lock';

  @override
  String get keyboardKeySelect => 'Select';

  @override
  String get keyboardKeyShift => 'Shift';

  @override
  String get keyboardKeySpace => 'Space';

  @override
  String get lastPageTooltip => 'Shafi na ƙarshe';

  @override
  String get lookUpButtonLabel => 'Bincike';

  @override
  String get menuBarMenuLabel => 'Menu';

  @override
  String get menuDismissLabel => 'Rufe menu';

  @override
  String get remainingTextFieldCharacterCountOther => 'Haruffa  saura';

  @override
  String get scanTextButtonLabel => 'Binciken rubutu';

  @override
  String get scrimLabel => 'Scrim';

  @override
  String get scrimOnTapHintRaw => 'Taba don rufe $scrimLabel';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.tall;

  @override
  String get searchWebButtonLabel => 'Bincika yanar gizo';

  @override
  String get selectedRowCountTitleOther => ' aka zaɓa';

  @override
  String get shareButtonLabel => 'Raba';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => 'Zaɓi sa’a';

  @override
  String get timePickerInputHelpText => 'Shigar da lokaci';

  @override
  String get timePickerMinuteModeAnnouncement => 'Zaɓi minti';

  @override
  String get unspecifiedDate => 'Kwanan wata ba a fayyace ba';

  @override
  String get unspecifiedDateRange => 'Kewayon kwanan wata ba a fayyace ba';

  @override
  String get licensesPackageDetailTextOther => '$licenseCount lasisi';

  @override
  String get licensesPageTitle => 'Lasisi';

  @override
  String get modalBarrierDismissLabel => 'Rufe';

  @override
  String get nextMonthTooltip => 'Wata mai zuwa';

  @override
  String get nextPageTooltip => 'Shafi na gaba';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get openAppDrawerTooltip => 'Buɗe menu';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      '$firstRow–$lastRow na cikin kusan $rowCount';

  @override
  String get pageRowsInfoTitleRaw => '$firstRow–$lastRow na cikin $rowCount';

  @override
  String get pasteButtonLabel => 'Manna';

  @override
  String get popupMenuLabel => 'Menu';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Wata na baya';

  @override
  String get previousPageTooltip => 'Shafi na baya';

  @override
  String get refreshIndicatorSemanticLabel => 'Sabunta';

  @override
  String get reorderItemDown => 'Matsa ƙasa';

  @override
  String get reorderItemLeft => 'Matsa hagu';

  @override
  String get reorderItemRight => 'Matsa dama';

  @override
  String get reorderItemToEnd => 'Matsa zuwa ƙarshe';

  @override
  String get reorderItemToStart => 'Matsa zuwa farko';

  @override
  String get reorderItemUp => 'Matsa sama';

  @override
  String get rowsPerPageTitle => 'Rijista ta shafi';

  @override
  String get saveButtonLabel => 'Ajiye';

  @override
  String get searchFieldLabel => 'Bincike';

  @override
  String get selectAllButtonLabel => 'Zaɓi duk';

  @override
  String get selectYearSemanticsLabel => 'Zaɓi shekara';

  @override
  String get showAccountsLabel => 'Nuna asusu';

  @override
  String get showMenuTooltip => 'Nuna menu';

  @override
  String get signedInLabel => 'An shiga';

  @override
  String get tabLabelRaw => 'Tab $tabIndex na $tabCount';

  @override
  String get timePickerDialHelpText => 'Zaɓi lokaci';

  @override
  String get timePickerHourLabel => 'Sa’a';

  @override
  String get timePickerMinuteLabel => 'Minti';

  @override
  String get viewLicensesButtonLabel => 'Duba lasisi';
  @override
  String get inputTimeModeButtonLabel => 'Yanayin shigar da lokaci';
}

const haLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  // Add more date patterns...
};

const haDateSymbols = {
  'NAME': 'ha',
  'ERAS': <dynamic>[
    'K.H.',
    'B.H.',
  ],
  // Add more date symbols...
};

class HaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const HaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ha';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String hausa = intl.Intl.canonicalizedLocale(locale.toString());

    await initializeDateFormatting(hausa, null);

    return SynchronousFuture<MaterialLocalizations>(
      HaMaterialLocalizations(
        localeName: hausa,
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        fullYearFormat: intl.DateFormat('y', hausa),
        compactDateFormat: intl.DateFormat('yMd', hausa),
        shortDateFormat: intl.DateFormat('yMMMd', hausa),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', hausa),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', hausa),
        yearMonthFormat: intl.DateFormat('MMMM y', hausa),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(HaMaterialLocalizationsDelegate old) => false;
}
