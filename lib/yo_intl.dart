import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

const yoLocaleDatePatterns = {
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

const yoDateSymbols = {
  'NAME': 'yo',
  'ERAS': <dynamic>[
    'BCE',
    'CE',
  ],
  'ERANAMES': <dynamic>[
    'Ṣaaju Kristi',
    'Lẹ́yìn Kristi',
  ],
  'NARROWMONTHS': <dynamic>[
    'S',
    'E',
    'E',
    'I',
    'E',
    'O',
    'A',
    'O',
    'O',
    'Ọ',
    'B',
    'Ọ',
  ],
  'STANDALONENARROWMONTHS': <dynamic>[
    'S',
    'E',
    'E',
    'I',
    'E',
    'O',
    'A',
    'O',
    'O',
    'Ọ',
    'B',
    'Ọ',
  ],
  'MONTHS': <dynamic>[
    'Ṣẹ́rẹ́',
    'Èrèlé',
    'Ẹrẹ̀nà',
    'Ìgbé',
    'Ẹ̀bibi',
    'Òkúdu',
    'Agẹmo',
    'Ògún',
    'Owewe',
    'Ọ̀wàrà',
    'Bélú',
    'Ọ̀pẹ̀',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'Ṣẹ́rẹ́',
    'Èrèlé',
    'Ẹrẹ̀nà',
    'Ìgbé',
    'Ẹ̀bibi',
    'Òkúdu',
    'Agẹmo',
    'Ògún',
    'Owewe',
    'Ọ̀wàrà',
    'Bélú',
    'Ọ̀pẹ̀',
  ],
  'SHORTMONTHS': <dynamic>[
    'Ṣẹ́r',
    'Èrè',
    'Ẹrẹ̀',
    'Ìgb',
    'Ẹ̀bi',
    'Òkú',
    'Agẹ',
    'Ògú',
    'Owe',
    'Ọ̀wà',
    'Bél',
    'Ọ̀pẹ̀',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'Ṣẹ́r',
    'Èrè',
    'Ẹrẹ̀',
    'Ìgb',
    'Ẹ̀bi',
    'Òkú',
    'Agẹ',
    'Ògú',
    'Owe',
    'Ọ̀wà',
    'Bél',
    'Ọ̀pẹ̀',
  ],
  'WEEKDAYS': <dynamic>[
    'Àìkú',
    'Ajé',
    'Ìṣẹ́gun',
    'Ọjọ́rú',
    'Ọjọ́bọ',
    'Ẹtì',
    'Àbámẹ́ta',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'Àìkú',
    'Ajé',
    'Ìṣẹ́gun',
    'Ọjọ́rú',
    'Ọjọ́bọ',
    'Ẹtì',
    'Àbámẹ́ta',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'Àìk',
    'Ajé',
    'Ìṣẹ́',
    'Ọjr',
    'Ọjb',
    'Ẹtì',
    'Àbám',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'Àìk',
    'Ajé',
    'Ìṣẹ́',
    'Ọjr',
    'Ọjb',
    'Ẹtì',
    'Àbám',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'À',
    'A',
    'Ì',
    'Ọ',
    'Ọ',
    'Ẹ',
    'À',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'À',
    'A',
    'Ì',
    'Ọ',
    'Ọ',
    'Ẹ',
    'À',
  ],
  'SHORTQUARTERS': <dynamic>[
    'K1',
    'K2',
    'K3',
    'K4',
  ],
  'QUARTERS': <dynamic>[
    'Kọ́tà Kínní',
    'Kọ́tà Kejì',
    'Kọ́tà Kẹta',
    'Kọ́tà Kẹrin',
  ],
  'AMPMS': <dynamic>[
    'Àárọ̀',
    'Ọ̀sán',
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
    '{1} \'ní\' {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

class _YoMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _YoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String yoruba = intl.Intl.canonicalizedLocale(locale.toString());

    // The locale (in this case `nn`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: yoruba,
      patterns: yoLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(yoDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      YoMaterialLocalizations(
        localeName: yoruba,
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        fullYearFormat: intl.DateFormat('y', yoruba),
        compactDateFormat: intl.DateFormat('yMd', yoruba),
        shortDateFormat: intl.DateFormat('yMMMd', yoruba),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', yoruba),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', yoruba),
        yearMonthFormat: intl.DateFormat('MMMM y', yoruba),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(_YoMaterialLocalizationsDelegate old) => false;
}

class YoMaterialLocalizations extends GlobalMaterialLocalizations {
  const YoMaterialLocalizations({
    super.localeName = 'yo',
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
  });

  static const int licenseCount = 5;

  static const int firstRow = 1;
  static const int lastRow = 10;
  static const int rowCount = 50;
  static const int tabIndex = 1;
  static const int tabCount = 3;
  static const int selectedRowCount = 10;
  static DateTime fullDate = DateTime(2024, 12, 25);
  static const String applicationName = 'Gona Farmers';

  String get welcomeMessage => "Kaabọ si Ọjà Gona";
  String get emailHint => "I-meeli";
  String get passwordHint => "Ọrọ aṣínà";
  String get forgotPassword => "Ṣe o gbagbe ọrọ aṣínà?";
  String get signIn => "Wọle";
  String get orContinueWith => "Tabi tẹsiwaju pẹlu";
  String get dontHaveAccount => "Ṣe o ni àkọọlẹ?";
  String get signUpNow => "Forukọsilẹ bayii";
  String get loading => "Nwọle...";
  String get userNotFound => "Akọọlẹ naa ko si";
  String get error => "Aṣiṣe";
  String get welcomeBack => "Ẹkú Ayé!";
  String get ordersCount => "Awojọ";
  String get processedOrders => "Awojọ ti a sise";
  String get deliveredItems => "Ibi ti a fi";
  String get totalSales => "Ipinlẹ ibeere";
  String get totalEarnings => "Ipinlẹ alọ";
  String get todaysTask => "Iṣẹ ojọ ti ńlẹ";
  String get addItem => "Fi iṣẹ lọ";
  String get inventory => "Iṣẹ isọgbe";
  String get manageItemsData => "San iṣẹ ti o nilo";
  String get addPromoItem => "Fi iṣẹ ala lọ";
  String get promotions => "Ipinlẹ ala";
  String get managePromotionsData => "San iṣẹ ti o nilo";
  String get noInternetConnection => "Ko si owo orilẹ-ede";
  String get retry => "Jẹkí ọrẹ";
  String get profile => "Akọsilẹ";
  String get notifications => "Ifitonileti";
  String get settings => "Awọn eto";
  String get about => "Nipa";
  String get helpCenter => "Ile-iṣẹ Iranlọwọ";

  // Constructor and other methods might be needed here

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get backButtonTooltip => r'Pada';

  @override
  String get bottomSheetLabel => r'Ipele isalẹ';

  @override
  String get calendarModeButtonLabel => r'Ipo kalẹnda';

  @override
  String get cancelButtonLabel => r'Fagilee';

  @override
  String get closeButtonLabel => r'Pa';

  @override
  String get closeButtonTooltip => r'Pa';

  @override
  String get collapsedHint => r'Ti dínkù';

  @override
  String get collapsedIconTapHint => r'Ṣí';

  @override
  String get continueButtonLabel => r'Tẹsiwaju';

  @override
  String get copyButtonLabel => r'Daakọ';

  @override
  String get currentDateLabel => r'Ọjọ oni';

  @override
  String get cutButtonLabel => r'Ge';

  @override
  String get dateHelpText => r'Tẹ ọjọ sii';

  @override
  String get dateInputLabel => r'Tẹ ọjọ sii';

  @override
  String get dateOutOfRangeLabel => r'Ọjọ wa ni ita ti ibiti';

  @override
  String get datePickerHelpText => r'Yan ọjọ';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'Opin ọjọ $fullDate';

  @override
  String get dateRangeEndLabel => r'Opin ọjọ';

  @override
  String get dateRangePickerHelpText => r'Yan ibiti ọjọ';

  @override
  String get dateRangeStartDateSemanticLabelRaw => r'Ibẹrẹ ọjọ $fullDate';

  @override
  String get dateRangeStartLabel => r'Ibẹrẹ ọjọ';

  @override
  String get dateSeparator => r'/';

  @override
  String get deleteButtonTooltip => r'Pa';

  @override
  String get dialModeButtonLabel => r'Ipo tẹtẹ';

  @override
  String get dialogLabel => r'Ọ̀rọ̀';

  @override
  String get drawerLabel => r'Akojọ aṣayan';

  @override
  String get expandedHint => r'Ti ṣí';

  @override
  String get expandedIconTapHint => r'Dínkù';

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _YoMaterialLocalizationsDelegate();

  @override
  String get expansionTileCollapsedHint => r'Ti dínkù';

  @override
  String get expansionTileCollapsedTapHint => r'Ṣí';

  @override
  String get expansionTileExpandedHint => r'Ti ṣí';

  @override
  String get expansionTileExpandedTapHint => r'Dínkù';

  @override
  String get firstPageTooltip => r'Ojú ewe àkọ́kọ́';

  @override
  String get hideAccountsLabel => r'Tọju awọn àkọọlẹ';

  @override
  String get inputDateModeButtonLabel => r'Ipo ọjọ tiwọn';

  @override
  String get inputTimeModeButtonLabel => r'Ipo akoko tiwọn';

  @override
  String get licensesPackageDetailTextOther => r'Awọn iwe-aṣẹ miiran';

  @override
  String get licensesPageTitle => r'Awọn iwe-aṣẹ';

  @override
  String get modalBarrierDismissLabel => r'Pa';

  @override
  String get nextMonthTooltip => r'Oṣù tó ń bọ̀';

  @override
  String get nextPageTooltip => r'Ojú ewe tó ń bọ̀';

  @override
  String get okButtonLabel => r'O DARA';

  @override
  String get openAppDrawerTooltip => r'Ṣí àkọsílẹ̀';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'Nfihan $firstRow si $lastRow ti $rowCount';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow-$lastRow ti $rowCount';

  @override
  String get pasteButtonLabel => r'Lẹẹ';

  @override
  String get popupMenuLabel => r'Akojọ aṣayan';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get previousMonthTooltip => r'Oṣù tó kọjá';

  @override
  String get previousPageTooltip => r'Ojú ewe tó kọjá';

  @override
  String get refreshIndicatorSemanticLabel => r'Tunṣe';

  @override
  String get reorderItemDown => r'Ṣeto isalẹ';

  @override
  String get reorderItemLeft => r'Ṣeto si apa osi';

  @override
  String get reorderItemRight => r'Ṣeto si apa otun';

  @override
  String get reorderItemToEnd => r'Ṣeto si opin';

  @override
  String get reorderItemToStart => 'rṢeto si ibẹrẹ';

  @override
  String get reorderItemUp => r'Ṣeto oke';

  @override
  String get rowsPerPageTitle => r'Àwọn Ìlà fún ojú-ewe kọọkan:';

  @override
  String get saveButtonLabel => r'Fipamọ';

  @override
  String get searchFieldLabel => r'Ṣawari';

  @override
  String get selectAllButtonLabel => r'Yan gbogbo';

  @override
  String get selectYearSemanticsLabel => r'Yan odun';

  @override
  String get showAccountsLabel => r'Fihan awọn àkọọlẹ';

  @override
  String get showMenuTooltip => r'Fihan akojọ aṣayan';

  @override
  String get signedInLabel => r'Ti wọlé';

  @override
  String get tabLabelRaw => r'Taabu $tabIndex ti $tabCount';

  @override
  String get timePickerDialHelpText => r'Yan akoko';

  @override
  String get timePickerHourLabel => r'Wakati';

  @override
  String get timePickerMinuteLabel => r'Iṣẹju';

  @override
  String get viewLicensesButtonLabel => r'Wo awọn iwe-aṣẹ';

  @override
  String get moreButtonTooltip => r'Die e sii';

  @override
  String get aboutListTileTitleRaw => r'Nipa $applicationName';

  @override
  String get alertDialogLabel => r'Ikilọ';

  @override
  String get invalidDateFormatLabel => r'Ẹya ọjọ ti ko tọ́';

  @override
  String get invalidDateRangeLabel => r'Ibiti ọjọ ti ko tọ́';

  @override
  String get invalidTimeLabel => r'Akoko ti ko tọ́';

  @override
  String get keyboardKeyAlt => r'Alt';

  @override
  String get keyboardKeyAltGraph => r'AltGr';

  @override
  String get keyboardKeyBackspace => r'Pada';

  @override
  String get keyboardKeyCapsLock => r'Caps Lock';

  @override
  String get keyboardKeyChannelDown => r'Ikanni isalẹ';

  @override
  String get keyboardKeyChannelUp => r'Ikanni oke';

  @override
  String get keyboardKeyControl => r'Ctrl';

  @override
  String get keyboardKeyDelete => r'Pa';

  @override
  String get keyboardKeyEject => r'Ẹject';

  @override
  String get keyboardKeyEnd => r'Opin';

  @override
  String get keyboardKeyEscape => r'Esiki';

  @override
  String get keyboardKeyFn => r'Fn';

  @override
  String get keyboardKeyHome => r'Ile';

  @override
  String get keyboardKeyInsert => r'Tẹ';

  @override
  String get keyboardKeyMeta => r'Meta';

  @override
  String get keyboardKeyMetaMacOs => r'Cmd';

  @override
  String get keyboardKeyMetaWindows => r'Win';

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
  String get keyboardKeyNumpadComma => r'Numpad Kọma';

  @override
  String get keyboardKeyNumpadDecimal => r'Numpad Dida';

  @override
  String get keyboardKeyNumpadDivide => r'Numpad Pín';

  @override
  String get keyboardKeyNumpadEnter => r'Numpad Tẹ';

  @override
  String get keyboardKeyNumpadEqual => r'Numpad Dọgba';

  @override
  String get keyboardKeyNumpadMultiply => r'Numpad Mẹta';

  @override
  String get keyboardKeyNumpadParenLeft => r'Numpad Àkọsílẹ̀ Òsì';

  @override
  String get keyboardKeyNumpadParenRight => r'Numpad Àkọsílẹ̀ Òtún';

  @override
  String get keyboardKeyNumpadSubtract => r'Numpad Dín';

  @override
  String get keyboardKeyPageDown => r'Ojú ewe isalẹ';

  @override
  String get keyboardKeyPageUp => r'Ojú ewe oke';

  @override
  String get keyboardKeyPower => r'Agbara';

  @override
  String get keyboardKeyPowerOff => r'Pa Agbara';

  @override
  String get keyboardKeyPrintScreen => r'Fọto Àgbé';

  @override
  String get keyboardKeyScrollLock => r'Àṣàrò Lock';

  @override
  String get keyboardKeySelect => r'Yan';

  @override
  String get keyboardKeyShift => r'Shift';

  @override
  String get keyboardKeySpace => r'Aye';

  @override
  String get lastPageTooltip => r'Ojú ewe tó kẹhin';

  @override
  String get lookUpButtonLabel => r'Ṣawari';

  @override
  String get menuBarMenuLabel => r'Akojọ aṣayan';

  @override
  String get menuDismissLabel => r'Pa Akojọ aṣayan';

  @override
  String get scanTextButtonLabel => r'Ṣayẹwo';

  @override
  String get scrimLabel => r'Aṣọ itọju';

  @override
  String get scrimOnTapHintRaw => r'Fọwọ́ si aṣọ itọju';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchWebButtonLabel => r'Ṣàwárí lórí wẹẹ́bù';

  @override
  String get selectedRowCountTitleOther => r'Ìkànnì ${selectedRowCount} ti yàn';

  @override
  String get shareButtonLabel => r'Pín';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw =>
      TimeOfDayFormat.H_colon_mm; // Assuming 24-hour format is used

  @override
  String get timePickerHourModeAnnouncement => r'Yan wakati';

  @override
  String get timePickerInputHelpText => r'Tẹ akoko naa';

  @override
  String get timePickerMinuteModeAnnouncement => r'Yan ìṣẹ́jú';

  @override
  String get unspecifiedDate => r'Ọjọ́ àìtó';

  @override
  String get unspecifiedDateRange => r'Àkókò ọjọ́ àìtó';

  @override
  String get remainingTextFieldCharacterCountOther =>
      'Ọ̀dúnkùn ọ̀nàkọnnú tó kù';
}
