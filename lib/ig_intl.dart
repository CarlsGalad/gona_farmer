import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

const igLocaleDatePatterns = {
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

const igDateSymbols = {
  'NAME': 'ig',
  'ERAS': <dynamic>[
    'T.K.',
    'A.K.',
  ],
  'ERANAMES': <dynamic>[
    'Tupu Kristi',
    'Afọ Kristi',
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
    'Ọ',
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
    'Ọ',
    'N',
    'D',
  ],
  'MONTHS': <dynamic>[
    'Jenụwarị',
    'Febụwarị',
    'Maachị',
    'Eprelu',
    'Mee',
    'Juun',
    'Julaị',
    'Ọgọọst',
    'Septemba',
    'Ọktoba',
    'Novemba',
    'Disemba',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'Jenụwarị',
    'Febụwarị',
    'Maachị',
    'Eprelu',
    'Mee',
    'Juun',
    'Julaị',
    'Ọgọọst',
    'Septemba',
    'Ọktoba',
    'Novemba',
    'Disemba',
  ],
  'SHORTMONTHS': <dynamic>[
    'Jen.',
    'Feb.',
    'Maa.',
    'Epr.',
    'Mee',
    'Juu.',
    'Jul.',
    'Ọgọ.',
    'Sep.',
    'Ọkt.',
    'Nov.',
    'Dis.',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'Jen.',
    'Feb.',
    'Maa.',
    'Epr.',
    'Mee',
    'Juu.',
    'Jul.',
    'Ọgọ.',
    'Sep.',
    'Ọkt.',
    'Nov.',
    'Dis.',
  ],
  'WEEKDAYS': <dynamic>[
    'Ụka',
    'Mọnde',
    'Tiuzdee',
    'Wenezdee',
    'Tọsdee',
    'Fraịdee',
    'Satọdee',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'Ụka',
    'Mọnde',
    'Tiuzdee',
    'Wenezdee',
    'Tọsdee',
    'Fraịdee',
    'Satọdee',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'Ụka',
    'Mọn',
    'Tiu',
    'Wen',
    'Tọs',
    'Fra',
    'Sat',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'Ụka',
    'Mọn',
    'Tiu',
    'Wen',
    'Tọs',
    'Fra',
    'Sat',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'Ụ',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'Ụ',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ],
  'SHORTQUARTERS': <dynamic>[
    'Ọ1',
    'Ọ2',
    'Ọ3',
    'Ọ4',
  ],
  'QUARTERS': <dynamic>[
    'Ọkara Mbụ',
    'Ọkara Abụọ',
    'Ọkara Atọ',
    'Ọkara Anọ',
  ],
  'AMPMS': <dynamic>[
    'A.M.',
    'P.M.',
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
    '{1} \'na\' {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

class _IgMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _IgMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ig';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String igbo = intl.Intl.canonicalizedLocale(locale.toString());

    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: igbo,
      patterns: igLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(igDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      IgMaterialLocalizations(
        localeName: igbo,
        decimalFormat: intl.NumberFormat.decimalPattern('en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        fullYearFormat: intl.DateFormat.y(igbo),
        compactDateFormat: intl.DateFormat.yMd(igbo),
        shortDateFormat: intl.DateFormat.yMMMd(igbo),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', igbo),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', igbo),
        yearMonthFormat: intl.DateFormat.yMMMM(igbo),
        shortMonthDayFormat: intl.DateFormat.MMMd(igbo),
      ),
    );
  }

  @override
  bool shouldReload(_IgMaterialLocalizationsDelegate old) => false;
}

class IgMaterialLocalizations extends GlobalMaterialLocalizations {
  const IgMaterialLocalizations({
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
  // Translations based on the provided JSON file
  String get welcomeMessage => 'Nnọọ na ahịa Gona';
  String get emailHint => 'Email';
  String get passwordHint => 'Okwuntughe';
  String get forgotPassword => 'Chefuru okwuntughe?';
  String get signIn => 'Banye';
  String get orContinueWith => "Ma ọ bụ gaa n'ihu na";
  String get dontHaveAccount => 'Ị nweghị akaụntụ?';
  String get signUpNow => 'Debanye aha ugbu a';
  String get loading => 'Na-ebudata...';
  String get userNotFound => 'Anaghị ahụ onye ọrụ';
  String get error => 'Njehie';
  String get welcomeBack => 'Nnabata!';
  String get ordersCount => 'Nde N\'ọrụ';
  String get processedOrders => 'Nde Mee';
  String get deliveredItems => 'Nde Na-Ewe';
  String get totalSales => 'Ego Ego';
  String get totalEarnings => 'Mba Nkwụsị';
  String get todaysTask => 'Nkọwa Ọma';
  String get addItem => 'Tinye Ebea';
  String get inventory => 'Isi Obi';
  String get manageItemsData => 'Choro Ebea Data';
  String get addPromoItem => 'Tinye Ebea Promo';
  String get promotions => 'Promotions';
  String get managePromotionsData => 'Choro Data N\'akwụkwọ';
  String get noInternetConnection => 'N\'anya n\'obi anwụghị dị';
  String get retry => 'Nọrọ Ịchọ';
  String get profile => 'Profaili';
  String get notifications => 'Nkwenye';
  String get settings => 'Nhazi';
  String get about => 'Banyere';
  String get helpCenter => 'Help Center';

  @override
  String get moreButtonTooltip => 'Ọzọ';


  @override
  String get aboutListTileTitleRaw => r'Banyere $applicationName';

  @override
  String get alertDialogLabel => r'Ncheta';

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get backButtonTooltip => r'Azụ';

  @override
  String get cancelButtonLabel => r'Kagbuo';

  @override
  String get closeButtonLabel => r'Mechie';

  @override
  String get closeButtonTooltip => r'Mechie';

  @override
  String get collapsedIconTapHint => r'Kpuchie';

  @override
  String get continueButtonLabel => r"Gaa n'ihu";

  @override
  String get copyButtonLabel => r'Detuo';

  @override
  String get cutButtonLabel => r'Bee';

  @override
  String get deleteButtonTooltip => r'Hichapụ';

  @override
  String get dialogLabel => r'Mkparịta ụka';

  @override
  String get drawerLabel => r'Drawer';

  @override
  String get expandedIconTapHint => r'Meghee';

  @override
  String get hideAccountsLabel => r'Zoo aha';

  @override
  String get licensesPageTitle => r'Licenses';

  @override
  String get modalBarrierDismissLabel => r'Kwụsị';

  @override
  String get nextMonthTooltip => r'Onwa Na-abia';

  @override
  String get nextPageTooltip => r'Peeji Na-abia';

  @override
  String get okButtonLabel => r'Ozioma';

  @override
  String get openAppDrawerTooltip => r'Mepee Drawer';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow n’ime $rowCount ';

  @override
  String get pageRowsInfoTitleApproximateRaw => r"$firstRow–$lastRow n’ime ihe dị ka  $rowCount";

  @override
  String get pasteButtonLabel => r'Tinye';

  @override
  String get popupMenuLabel => r'Menu Popup';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get previousMonthTooltip => r'Onwa gara aga';

  @override
  String get previousPageTooltip => r'Peeji gara aga';

  @override
  String get refreshIndicatorSemanticLabel => r'Ntụgharị';

  @override
  String get reorderItemDown => r'Depụta ala';

  @override
  String get reorderItemLeft => r'Depụta aka ekpe';

  @override
  String get reorderItemRight => 'Depụta aka nri';

  @override
  String get reorderItemToEnd => 'Depụta na njedebe';

  @override
  String get reorderItemToStart => 'Depụta na mmalite';

  @override
  String get reorderItemUp => 'Depụta elu';

  @override
  String get rowsPerPageTitle => 'Ahịrị kwa peeji:';

  @override
  String get saveButtonLabel => 'Chekwa';

  @override
  String get searchFieldLabel => 'Chọọ';

  @override
  String get selectAllButtonLabel => 'Họrọ ihe niile';

  @override
  String get selectYearSemanticsLabel => 'Họrọ Afọ';

  @override
  String get showAccountsLabel => 'Gosi aha';

  @override
  String get showMenuTooltip => 'Gosi menu';

  @override
  String get signedInLabel => 'Nwetara';

  @override
  String get tabLabelRaw => 'Tab nke';

  @override
  String get timePickerDialHelpText => 'Họrọ oge';

  @override
  String get timePickerHourLabel => 'Elekere';

  @override
  String get timePickerMinuteLabel => 'Nkeji';

  @override
  String get viewLicensesButtonLabel => 'Lee licenses';

  @override
  String get dateRangeEndDateSemanticLabelRaw => 'Ọgwụgwụ ụbọchị ';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'Malite ụbọchị';

  @override
  String get licensesPackageDetailTextOther => r'\$licenseCount licenses';
  @override
  String get bottomSheetLabel => r'Bottom Sheet';

  @override
  String get calendarModeButtonLabel => r"N'ụdị kalenda";

  @override
  String get collapsedHint => r'Agbachiri';

  @override
  String get currentDateLabel => r'Ụbọchị ugbu a';

  @override
  String get dateHelpText => r'Pịnye ụbọchị';

  @override
  String get dateInputLabel => r'Banye ụbọchị';

  @override
  String get dateOutOfRangeLabel => r'Ụbọchị ahụ dị na mpụga nso';

  @override
  String get datePickerHelpText => r'Họrọ ụbọchị';

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _IgMaterialLocalizationsDelegate();

  @override
  String get dateRangeEndLabel => r'Ọgwụgwụ ụbọchị';

  @override
  String get dateRangePickerHelpText => r'Họrọ nso ụbọchị';

  @override
  String get dateRangeStartLabel => r'Malite ụbọchị';

  @override
  String get dateSeparator => r'/';

  @override
  String get dialModeButtonLabel => r"N'ụdị oku";

  @override
  String get expandedHint => r'Meghee';

  @override
  String get expansionTileCollapsedHint => r'Ngosipụta njikọ';

  @override
  String get expansionTileCollapsedTapHint => r'Pịa ka imeghe';

  @override
  String get expansionTileExpandedHint => r'Ngosi imeghe';

  @override
  String get expansionTileExpandedTapHint => r'Pịa ka igbochi';

  @override
  String get firstPageTooltip => r'Peji Mbụ';

  @override
  String get inputDateModeButtonLabel => r"N'ụdị ụbọchị";

  @override
  String get inputTimeModeButtonLabel => r"N'ụdị oge";

  @override
  String get invalidDateFormatLabel => r'Ụdị ụbọchị na-ezighi ezi';

  @override
  String get invalidDateRangeLabel => r'Nso ụbọchị na-ezighi ezi';

  @override
  String get invalidTimeLabel => r'Oge na-ezighi ezi';

  @override
  String get keyboardKeyAlt => r'Alt';

  @override
  String get keyboardKeyAltGraph => r'AltGr';

  @override
  String get keyboardKeyBackspace => r'Backspace';

  @override
  String get keyboardKeyCapsLock => r'Caps Lock';

  @override
  String get keyboardKeyChannelDown => r'Akụrụngwa ala';

  @override
  String get keyboardKeyChannelUp => r'Akụrụngwa elu';

  @override
  String get keyboardKeyControl => r'Ctrl';

  @override
  String get keyboardKeyDelete => r'Hichapụ';

  @override
  String get keyboardKeyEject => r'Eject';

  @override
  String get keyboardKeyEnd => r'Ọgwụ';

  @override
  String get keyboardKeyEscape => r'Mgba ọsọ';

  @override
  String get keyboardKeyFn => r'Fn';

  @override
  String get keyboardKeyHome => r'Malite';

  @override
  String get keyboardKeyInsert => r'Tinye';

  @override
  String get keyboardKeyMeta => r'Meta';

  @override
  String get keyboardKeyMetaMacOs => r'Cmd';

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
  String get keyboardKeyNumpadAdd => r'Numpad Tinye';

  @override
  String get keyboardKeyNumpadComma => r'Numpad Kọma';

  @override
  String get keyboardKeyNumpadDecimal => r'Numpad Decimal';

  @override
  String get keyboardKeyNumpadDivide => r'Numpad Kewaa';

  @override
  String get keyboardKeyNumpadEnter => r'Numpad Bata';

  @override
  String get keyboardKeyNumpadEqual => r'Numpad Nhata';

  @override
  String get keyboardKeyNumpadMultiply => r'Numpad Mụbaa';

  @override
  String get keyboardKeyNumpadParenLeft => r"Numpad N\'aka ekpe";

  @override
  String get keyboardKeyNumpadParenRight => r"Numpad N\'aka nri";

  @override
  String get keyboardKeyNumpadSubtract => r'Numpad Wepụ';

  @override
  String get keyboardKeyPageDown => r'Peeji ala';

  @override
  String get keyboardKeyPageUp => r'Peeji elu';

  @override
  String get keyboardKeyPower => r'Ike';

  @override
  String get keyboardKeyPowerOff => r'Gbanyụọ ike';

  @override
  String get keyboardKeyPrintScreen => r'Nye ọkụ';

  @override
  String get keyboardKeyScrollLock => r'Jikọọ na-atụgharị';

  @override
  String get keyboardKeySelect => r'Họrọ';

  @override
  String get keyboardKeyShift => r'Shift';

  @override
  String get keyboardKeySpace => r'Ụgwọ';

  @override
  String get lastPageTooltip => r'Peeji Ikpeazụ';

  @override
  String get lookUpButtonLabel => r'Lelee elu';

  @override
  String get menuBarMenuLabel => r'Menu Menu Bar';

  @override
  String get menuDismissLabel => r'Hapụ Menu';
  @override
  String get remainingTextFieldCharacterCountOther => r'Ọnụ ọgụgụ odide fọdụrụ:';

  @override
  String get scanTextButtonLabel => r'Nyochaa ederede';

  @override
  String get scrimLabel => r'Ihuenyo ekpuchi';

  @override
  String get scrimOnTapHintRaw => r'Pịa iji wepu ihe mkpuchi';

  @override
  ScriptCategory get scriptCategory =>
      ScriptCategory.englishLike; // Assuming English-like script

  @override
  String get searchWebButtonLabel => r'Chọọ na web';

  @override
  String get selectedRowCountTitleOther => r'Ọnụ ọgụgụ ahọrọla:';

  @override
  String get shareButtonLabel => r'Kekọrịta';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw =>
      TimeOfDayFormat.HH_colon_mm; // Assuming 24-hour format

  @override
  String get timePickerHourModeAnnouncement => r'Họrọ awa';

  @override
  String get timePickerInputHelpText => r'Tinye oge';

  @override
  String get timePickerMinuteModeAnnouncement => r'Họrọ nkeji';

  @override
  String get unspecifiedDate => r'Ụbọchị akọwapụtara';

  @override
  String get unspecifiedDateRange => r'Ụdị ụbọchị akọwapụtara';
}
