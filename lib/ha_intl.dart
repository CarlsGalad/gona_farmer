import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

const haLocaleDatePatterns = {
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  'LLLL': 'LLLL',
  'M': 'L',
  'Md': 'd/M',
  'MEd': 'EEE, d/M',
  'MMM': 'LLL',
  'MMMd': 'd MMM',
  'MMMEd': 'EEE, d MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd MMMM',
  'MMMMEEEEd': 'EEEE, d MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M/y',
  'yMd': 'd/M/y',
  'yMEd': 'EEE, d/M/y',
  'yMMM': 'MMM y',
  'yMMMd': 'd MMM y',
  'yMMMEd': 'EEE, d MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd MMMM y',
  'yMMMMEEEEd': 'EEEE, d MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

const haDateSymbols = {
  'NAME': 'ha',
  'ERAS': <dynamic>[
    'K.H.',
    'B.H.',
  ],
  'ERANAMES': <dynamic>[
    'Kafin haihuwar Isa',
    'Bayan haihuwar Isa',
  ],
  'NARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'STANDALONENARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'MONTHS': <dynamic>[
    'Janairu',
    'Fabrairu',
    'Maris',
    'Afirilu',
    'Mayu',
    'Yuni',
    'Yuli',
    'Agusta',
    'Satumba',
    'Oktoba',
    'Nuwamba',
    'Disamba',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'Janairu',
    'Fabrairu',
    'Maris',
    'Afirilu',
    'Mayu',
    'Yuni',
    'Yuli',
    'Agusta',
    'Satumba',
    'Oktoba',
    'Nuwamba',
    'Disamba',
  ],
  'SHORTMONTHS': <dynamic>[
    'Jan.',
    'Fab.',
    'Mar.',
    'Afr.',
    'May.',
    'Yun.',
    'Yul.',
    'Ago.',
    'Sat.',
    'Okt.',
    'Nuw.',
    'Dis.',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'Jan.',
    'Fab.',
    'Mar.',
    'Afr.',
    'May.',
    'Yun.',
    'Yul.',
    'Ago.',
    'Sat.',
    'Okt.',
    'Nuw.',
    'Dis.',
  ],
  'WEEKDAYS': <dynamic>[
    'Lahadi',
    'Litinin',
    'Talata',
    'Laraba',
    'Alhamis',
    'Jumma\'a',
    'Asabar',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'Lahadi',
    'Litinin',
    'Talata',
    'Laraba',
    'Alhamis',
    'Jumma\'a',
    'Asabar',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'Lah.',
    'Lit.',
    'Tal.',
    'Lar.',
    'Alh.',
    'Jum.',
    'Asa.',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'Lah.',
    'Lit.',
    'Tal.',
    'Lar.',
    'Alh.',
    'Jum.',
    'Asa.',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'L',
    'L',
    'T',
    'L',
    'A',
    'J',
    'A',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'L',
    'L',
    'T',
    'L',
    'A',
    'J',
    'A',
  ],
  'SHORTQUARTERS': <dynamic>[
    'K1',
    'K2',
    'K3',
    'K4',
  ],
  'QUARTERS': <dynamic>[
    'Kwata na ɗaya',
    'Kwata na biyu',
    'Kwata na uku',
    'Kwata na huɗu',
  ],
  'AMPMS': <dynamic>[
    'Safiya',
    'Yamma',
  ],
  'DATEFORMATS': <dynamic>[
    'EEEE, d MMMM, y',
    'd MMMM, y',
    'd MMM y',
    'd/M/y',
  ],
  'TIMEFORMATS': <dynamic>[
    'HH:mm:ss zzzz',
    'HH:mm:ss z',
    'HH:mm:ss',
    'HH:mm',
  ],
  'AVAILABLEFORMATS': null,
  'FIRSTDAYOFWEEK': 0,
  'WEEKENDRANGE': <dynamic>[
    5,
    6,
  ],
  'FIRSTWEEKCUTOFFDAY': 3,
  'DATETIMEFORMATS': <dynamic>[
    '{1} {0}',
    '{1} \'da\' {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

class _HaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _HaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ha';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String hausa = intl.Intl.canonicalizedLocale(locale.toString());

    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: hausa,
      patterns: haLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(haDateSymbols),
    );

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
  bool shouldReload(_HaMaterialLocalizationsDelegate old) => false;
}

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
    required super.localeName,
  });

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
  String get aboutListTileTitleRaw => r'Game da $applicationName';

  @override
  String get alertDialogLabel => r'Faɗakarwa';

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get backButtonTooltip => r'Koma baya';

  @override
  String get bottomSheetLabel => r'Ƙarƙashin takarda';

  @override
  String get calendarModeButtonLabel => r'Yanayin kalanda';

  @override
  String get cancelButtonLabel => r'Soke';

  @override
  String get closeButtonLabel => r'Rufe';

  @override
  String get closeButtonTooltip => r'Rufe';

  @override
  String get collapsedHint => r'An runtse';

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _HaMaterialLocalizationsDelegate();

  @override
  String get collapsedIconTapHint => r'Buɗe';

  @override
  String get continueButtonLabel => r'Ci gaba';

  @override
  String get copyButtonLabel => r'Kwafi';

  @override
  String get currentDateLabel => r'Yau';

  @override
  String get cutButtonLabel => r'Yanke';

  @override
  String get dateHelpText => r'Shigar da kwanan wata';

  @override
  String get dateInputLabel => r'Shigar da kwanan wata';

  @override
  String get dateOutOfRangeLabel => r'Kwanan wata baya cikin kewayo';

  @override
  String get datePickerHelpText => r'Zaɓi kwanan wata';

  @override
  String get dateRangeEndDateSemanticLabelRaw =>
      r'Ƙarshen kwanan wata $fullDate';

  @override
  String get dateRangeEndLabel => r'Ƙarshen kwanan wata';

  @override
  String get dateRangePickerHelpText => r'Zaɓi kewayon kwanan wata';

  @override
  String get dateRangeStartDateSemanticLabelRaw =>
      r'Farkon kwanan wata $fullDate';

  @override
  String get dateRangeStartLabel => r'Farkon kwanan wata';

  @override
  String get dateSeparator => r'/';

  @override
  String get deleteButtonTooltip => r'Share';

  @override
  String get dialModeButtonLabel => r'Yanayin kira';

  @override
  String get dialogLabel => r'Tattaunawa';

  @override
  String get drawerLabel => r'Menu';

  @override
  String get expandedHint => r'An buɗe';

  @override
  String get expandedIconTapHint => r'Runtse';

  @override
  String get expansionTileCollapsedHint => r'An runtse';

  @override
  String get expansionTileCollapsedTapHint => r'Buɗe';

  @override
  String get expansionTileExpandedHint => r'An buɗe';

  @override
  String get expansionTileExpandedTapHint => r'Runtse';

  @override
  String get firstPageTooltip => r'Shafi na farko';

  @override
  String get hideAccountsLabel => r'Ɓoye asusu';

  @override
  String get inputDateModeButtonLabel => r'Yanayin shigar da kwanan wata';

  @override
  String get invalidDateFormatLabel => r'Tsarin kwanan wata mara inganci';

  @override
  String get invalidDateRangeLabel => r'Kewayon kwanan wata mara inganci';

  @override
  String get invalidTimeLabel => r'Lokaci mara inganci';

  @override
  String get keyboardKeyAlt => r'Alt';

  @override
  String get keyboardKeyAltGraph => r'AltGr';

  @override
  String get keyboardKeyBackspace => r'Backspace';

  @override
  String get keyboardKeyCapsLock => r'Caps Lock';

  @override
  String get keyboardKeyChannelDown => r'Channel Down';

  @override
  String get keyboardKeyChannelUp => r'Channel Up';

  @override
  String get keyboardKeyControl => r'Ctrl';

  @override
  String get keyboardKeyDelete => r'Delete';

  @override
  String get keyboardKeyEject => r'Eject';

  @override
  String get keyboardKeyEnd => r'End';

  @override
  String get keyboardKeyEscape => r'Escape';

  @override
  String get keyboardKeyFn => r'Fn';

  @override
  String get keyboardKeyHome => r'Home';

  @override
  String get keyboardKeyInsert => r'Insert';

  @override
  String get keyboardKeyMeta => r'Meta';

  @override
  String get keyboardKeyMetaMacOs => r'Command';

  @override
  String get keyboardKeyMetaWindows => r'Windows';

  @override
  String get keyboardKeyNumLock => r'Num Lock';

  @override
  String get keyboardKeyNumpad0 => r'Numpad 0';

  @override
  String get keyboardKeyNumpad1 => r'Numpad 1';

  @override
  String get keyboardKeyNumpad2 => r'Numpad 2';

  @override
  String get keyboardKeyNumpad3 => r'Numpad 3';

  @override
  String get keyboardKeyNumpad4 => r'Numpad 4';

  @override
  String get keyboardKeyNumpad5 => r'Numpad 5';

  @override
  String get keyboardKeyNumpad6 => r'Numpad 6';

  @override
  String get keyboardKeyNumpad7 => r'Numpad 7';

  @override
  String get keyboardKeyNumpad8 => r'Numpad 8';

  @override
  String get keyboardKeyNumpad9 => r'Numpad 9';

  @override
  String get keyboardKeyNumpadAdd => r'Numpad Add';

  @override
  String get keyboardKeyNumpadComma => r'Numpad Comma';

  @override
  String get keyboardKeyNumpadDecimal => r'Numpad Decimal';

  @override
  String get keyboardKeyNumpadDivide => r'Numpad Divide';

  @override
  String get keyboardKeyNumpadEnter => r'Numpad Enter';

  @override
  String get keyboardKeyNumpadEqual => r'Numpad Equal';

  @override
  String get keyboardKeyNumpadMultiply => r'Numpad Multiply';

  @override
  String get keyboardKeyNumpadParenLeft => r'Numpad (';

  @override
  String get keyboardKeyNumpadParenRight => r'Numpad )';

  @override
  String get keyboardKeyNumpadSubtract => r'Numpad Subtract';

  @override
  String get keyboardKeyPageDown => r'Page Down';

  @override
  String get keyboardKeyPageUp => r'Page Up';

  @override
  String get keyboardKeyPower => r'Power';

  @override
  String get keyboardKeyPowerOff => r'Power Off';

  @override
  String get keyboardKeyPrintScreen => r'Print Screen';

  @override
  String get keyboardKeyScrollLock => r'Scroll Lock';

  @override
  String get keyboardKeySelect => r'Select';

  @override
  String get keyboardKeyShift => r'Shift';

  @override
  String get keyboardKeySpace => r'Space';

  @override
  String get lastPageTooltip => r'Shafi na ƙarshe';

  @override
  String get lookUpButtonLabel => r'Bincike';

  @override
  String get menuBarMenuLabel => r'Menu';

  @override
  String get menuDismissLabel => r'Rufe menu';

  @override
  String get remainingTextFieldCharacterCountOther => r'Haruffa  saura';

  @override
  String get scanTextButtonLabel => r'Binciken rubutu';

  @override
  String get scrimLabel => r'Scrim';

  @override
  String get scrimOnTapHintRaw => r'Taba don rufe $scrimLabel';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.tall;

  @override
  String get searchWebButtonLabel => r'Bincika yanar gizo';

  @override
  String get selectedRowCountTitleOther => r' aka zaɓa';

  @override
  String get shareButtonLabel => r'Raba';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => r'Zaɓi sa’a';

  @override
  String get timePickerInputHelpText => r'Shigar da lokaci';

  @override
  String get timePickerMinuteModeAnnouncement => r'Zaɓi minti';

  @override
  String get unspecifiedDate => r'Kwanan wata ba a fayyace ba';

  @override
  String get unspecifiedDateRange => r'Kewayon kwanan wata ba a fayyace ba';

  @override
  String get licensesPackageDetailTextOther => r'$licenseCount lasisi';

  @override
  String get licensesPageTitle => r'Lasisi';

  @override
  String get modalBarrierDismissLabel => r'Rufe';

  @override
  String get nextMonthTooltip => r'Wata mai zuwa';

  @override
  String get nextPageTooltip => r'Shafi na gaba';

  @override
  String get okButtonLabel => r'OK';

  @override
  String get openAppDrawerTooltip => r'Buɗe menu';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow na cikin kusan $rowCount';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow na cikin $rowCount';

  @override
  String get pasteButtonLabel => r'Manna';

  @override
  String get popupMenuLabel => r'Menu';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get previousMonthTooltip => r'Wata na baya';

  @override
  String get previousPageTooltip => r'Shafi na baya';

  @override
  String get refreshIndicatorSemanticLabel => r'Sabunta';

  @override
  String get reorderItemDown => r'Matsa ƙasa';

  @override
  String get reorderItemLeft => r'Matsa hagu';

  @override
  String get reorderItemRight => r'Matsa dama';

  @override
  String get reorderItemToEnd => r'Matsa zuwa ƙarshe';

  @override
  String get reorderItemToStart => r'Matsa zuwa farko';

  @override
  String get reorderItemUp => r'Matsa sama';

  @override
  String get rowsPerPageTitle => r'Rijista ta shafi';

  @override
  String get saveButtonLabel => r'Ajiye';

  @override
  String get searchFieldLabel => r'Bincike';

  @override
  String get selectAllButtonLabel => r'Zaɓi duk';

  @override
  String get selectYearSemanticsLabel => r'Zaɓi shekara';

  @override
  String get showAccountsLabel => r'Nuna asusu';

  @override
  String get showMenuTooltip => r'Nuna menu';

  @override
  String get signedInLabel => r'An shiga';

  @override
  String get tabLabelRaw => r'Tab $tabIndex na $tabCount';

  @override
  String get timePickerDialHelpText => r'Zaɓi lokaci';

  @override
  String get timePickerHourLabel => r'Sa’a';

  @override
  String get timePickerMinuteLabel => r'Minti';

  @override
  String get viewLicensesButtonLabel => r'Duba lasisi';

  @override
  String get inputTimeModeButtonLabel => r'Yanayin shigar da lokaci';
}
