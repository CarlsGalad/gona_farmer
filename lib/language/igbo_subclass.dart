import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';

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

  //application name as a static constant
  static const String applicationName = 'Gona Farmers';

  @override
  String get aboutListTileTitleRaw => 'Banyere $applicationName';

  @override
  String get alertDialogLabel => 'Ncheta';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Azụ';

  @override
  String get cancelButtonLabel => 'Kagbuo';

  @override
  String get closeButtonLabel => 'Mechie';

  @override
  String get closeButtonTooltip => 'Mechie';

  @override
  String get collapsedIconTapHint => 'Kpuchie';

  @override
  String get continueButtonLabel => "Gaa n'ihu";

  @override
  String get copyButtonLabel => 'Detuo';

  @override
  String get cutButtonLabel => 'Bee';

  @override
  String get deleteButtonTooltip => 'Hichapụ';

  @override
  String get dialogLabel => 'Mkparịta ụka';

  @override
  String get drawerLabel => 'Drawer';

  @override
  String get expandedIconTapHint => 'Meghee';

  @override
  String get hideAccountsLabel => 'Zoo aha';

  @override
  String get licensesPageTitle => 'Licenses';

  @override
  String get modalBarrierDismissLabel => 'Kwụsị';

  @override
  String get nextMonthTooltip => 'Onwa Na-abia';

  @override
  String get nextPageTooltip => 'Peeji Na-abia';

  @override
  String get okButtonLabel => 'Ozioma';

  @override
  String get openAppDrawerTooltip => 'Mepee Drawer';

  @override
  String get pageRowsInfoTitleRaw => ' n’ime ';

  @override
  String get pageRowsInfoTitleApproximateRaw => "n’ime ihe dị ka";

  @override
  String get pasteButtonLabel => 'Tinye';

  @override
  String get popupMenuLabel => 'Menu Popup';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Onwa gara aga';

  @override
  String get previousPageTooltip => 'Peeji gara aga';

  @override
  String get refreshIndicatorSemanticLabel => 'Ntụgharị';

  @override
  String get reorderItemDown => 'Depụta ala';

  @override
  String get reorderItemLeft => 'Depụta aka ekpe';

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
  String get licensesPackageDetailTextOther => ' licenses';
  @override
  String get bottomSheetLabel => 'Bottom Sheet';

  @override
  String get calendarModeButtonLabel => "N'ụdị kalenda";

  @override
  String get collapsedHint => 'Agbachiri';

  @override
  String get currentDateLabel => 'Ụbọchị ugbu a';

  @override
  String get dateHelpText => 'Pịnye ụbọchị';

  @override
  String get dateInputLabel => 'Banye ụbọchị';

  @override
  String get dateOutOfRangeLabel => 'Ụbọchị ahụ dị na mpụga nso';

  @override
  String get datePickerHelpText => 'Họrọ ụbọchị';

  @override
  String get dateRangeEndLabel => 'Ọgwụgwụ ụbọchị';

  @override
  String get dateRangePickerHelpText => 'Họrọ nso ụbọchị';

  @override
  String get dateRangeStartLabel => 'Malite ụbọchị';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => "N'ụdị oku";

  @override
  String get expandedHint => 'Meghee';

  @override
  String get expansionTileCollapsedHint => 'Ngosipụta njikọ';

  @override
  String get expansionTileCollapsedTapHint => 'Pịa ka imeghe';

  @override
  String get expansionTileExpandedHint => 'Ngosi imeghe';

  @override
  String get expansionTileExpandedTapHint => 'Pịa ka igbochi';

  @override
  String get firstPageTooltip => 'Peji Mbụ';

  @override
  String get inputDateModeButtonLabel => "N'ụdị ụbọchị";

  @override
  String get inputTimeModeButtonLabel => "N'ụdị oge";

  @override
  String get invalidDateFormatLabel => 'Ụdị ụbọchị na-ezighi ezi';

  @override
  String get invalidDateRangeLabel => 'Nso ụbọchị na-ezighi ezi';

  @override
  String get invalidTimeLabel => 'Oge na-ezighi ezi';

  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyChannelDown => 'Akụrụngwa ala';

  @override
  String get keyboardKeyChannelUp => 'Akụrụngwa elu';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Hichapụ';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'Ọgwụ';

  @override
  String get keyboardKeyEscape => 'Mgba ọsọ';

  @override
  String get keyboardKeyFn => 'Fn';

  @override
  String get keyboardKeyHome => 'Malite';

  @override
  String get keyboardKeyInsert => 'Tinye';

  @override
  String get keyboardKeyMeta => 'Meta';

  @override
  String get keyboardKeyMetaMacOs => 'Cmd';

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
  String get keyboardKeyNumpadAdd => 'Numpad Tinye';

  @override
  String get keyboardKeyNumpadComma => 'Numpad Kọma';

  @override
  String get keyboardKeyNumpadDecimal => 'Numpad Decimal';

  @override
  String get keyboardKeyNumpadDivide => 'Numpad Kewaa';

  @override
  String get keyboardKeyNumpadEnter => 'Numpad Bata';

  @override
  String get keyboardKeyNumpadEqual => 'Numpad Nhata';

  @override
  String get keyboardKeyNumpadMultiply => 'Numpad Mụbaa';

  @override
  String get keyboardKeyNumpadParenLeft => 'Numpad N\'aka ekpe';

  @override
  String get keyboardKeyNumpadParenRight => 'Numpad N\'aka nri';

  @override
  String get keyboardKeyNumpadSubtract => 'Numpad Wepụ';

  @override
  String get keyboardKeyPageDown => 'Peeji ala';

  @override
  String get keyboardKeyPageUp => 'Peeji elu';

  @override
  String get keyboardKeyPower => 'Ike';

  @override
  String get keyboardKeyPowerOff => 'Gbanyụọ ike';

  @override
  String get keyboardKeyPrintScreen => 'Nye ọkụ';

  @override
  String get keyboardKeyScrollLock => 'Jikọọ na-atụgharị';

  @override
  String get keyboardKeySelect => 'Họrọ';

  @override
  String get keyboardKeyShift => 'Shift';

  @override
  String get keyboardKeySpace => 'Ụgwọ';

  @override
  String get lastPageTooltip => 'Peeji Ikpeazụ';

  @override
  String get lookUpButtonLabel => 'Lelee elu';

  @override
  String get menuBarMenuLabel => 'Menu Menu Bar';

  @override
  String get menuDismissLabel => 'Hapụ Menu';
  @override
  String get remainingTextFieldCharacterCountOther => 'Ọnụ ọgụgụ odide fọdụrụ:';

  @override
  String get scanTextButtonLabel => 'Nyochaa ederede';

  @override
  String get scrimLabel => 'Ihuenyo ekpuchi';

  @override
  String get scrimOnTapHintRaw => 'Pịa iji wepu ihe mkpuchi';

  @override
  ScriptCategory get scriptCategory =>
      ScriptCategory.englishLike; // Assuming English-like script

  @override
  String get searchWebButtonLabel => 'Chọọ na web';

  @override
  String get selectedRowCountTitleOther => 'Ọnụ ọgụgụ ahọrọla:';

  @override
  String get shareButtonLabel => 'Kekọrịta';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw =>
      TimeOfDayFormat.HH_colon_mm; // Assuming 24-hour format

  @override
  String get timePickerHourModeAnnouncement => 'Họrọ awa';

  @override
  String get timePickerInputHelpText => 'Tinye oge';

  @override
  String get timePickerMinuteModeAnnouncement => 'Họrọ nkeji';

  @override
  String get unspecifiedDate => 'Ụbọchị akọwapụtara';

  @override
  String get unspecifiedDateRange => 'Ụdị ụbọchị akọwapụtara';
}

const igLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  // Add more date patterns...
};

const igDateSymbols = {
  'NAME': 'ig',
  'ERAS': <dynamic>[
    'T.K.',
    'A.K.',
  ],
  // Add more date symbols...
};

class IgMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const IgMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ig';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String igbo = intl.Intl.canonicalizedLocale(locale.toString());

    await initializeDateFormatting(igbo, null);

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
  bool shouldReload(IgMaterialLocalizationsDelegate old) => false;
}
