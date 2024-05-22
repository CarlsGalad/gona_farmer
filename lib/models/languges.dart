class Language {
  final int id;
  final String name;
  final String languagCode;

  Language(this.id, this.name, this.languagCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "en"),
      Language(2, "Hausa", "ha"),
      Language(3, "Arabic", "ar"),
      Language(4, "Yoruba", "yo"), // Corrected 'Yr' to 'yr' for consistency
      Language(5, "Igbo", "ig"),
      Language(6, "French", "fr"),
    ];
  }
}
