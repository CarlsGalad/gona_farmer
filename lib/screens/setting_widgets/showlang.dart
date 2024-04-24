import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// import '../../providers/category_provider.dart';
import '../../providers/item_provider.dart';
import '../../services/auth_page.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Select Language',
          style: GoogleFonts.bebasNeue(),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LanguageOption(
            language: 'English',
            onTap: () => _changeLanguage(context, 'en'),
          ),
          LanguageOption(
            language: 'Arabic',
            onTap: () => _changeLanguage(context, 'ar'),
          ),
          LanguageOption(
            language: 'French',
            onTap: () => _changeLanguage(context, 'fr'),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    Locale locale;
    // Determine the Locale based on the language code
    switch (languageCode) {
      case 'en':
        locale = const Locale('en', 'GB'); // English
        break;
      case 'ar':
        locale = const Locale('ar', 'SA'); // Arabic
        break;
      case 'fr':
        locale = const Locale('fr', 'FR'); // French
        break;
      // more cases for other languages as needed  when its time
      default:
        locale = const Locale('en', ''); // Default to English
    }

    runApp(
      MultiProvider(
        providers: [
          // Provide the authentication service
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),

          // Provide the Firestore service
          Provider<FirestoreService>(
            create: (_) => FirestoreService(),
          ),

// the item provider
          ChangeNotifierProxyProvider<FirestoreService, ItemProvider>(
            create: (_) => ItemProvider(),
            update: (_, firestoreService, itemProvider) {
              if (itemProvider != null) {
                itemProvider.updateFromFirestore(firestoreService);
                return itemProvider;
              } else {
                final newItemProvider = ItemProvider();
                // Handle the case where itemProvider is null
                newItemProvider.updateFromFirestore(firestoreService);
                return newItemProvider; // Creating a new instance
              }
            },
          ),

          //  // Use ChangeNotifierProxyProvider for CategoryProvider to synchronize with Firebase
          // ChangeNotifierProxyProvider<FirestoreService, CategoryProvider>(
          //   create: (_) => CategoryProvider(),
          //   update: (_, firestoreService, categoryProvider) {
          //     // Check if categoryProvider is null
          //     if (categoryProvider != null) {
          //       // Update the existing categoryProvider
          //       categoryProvider.updateFromFirestore(firestoreService);
          //       return categoryProvider;
          //     } else {
          //       // Create a new CategoryProvider and update it
          //       final newCategoryProvider = CategoryProvider();
          //       newCategoryProvider.updateFromFirestore(firestoreService);
          //       return newCategoryProvider;
          //     }
          //   },
          // )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'GB'), // English
            Locale('ar', 'SA'), // Arabic
            Locale('fr', 'FR'), // French
          ],
          locale: locale,
          home: const AuthPage(), // Dummy widget
        ),
      ),
    );

    Navigator.pop(context); // Close the dialog
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final VoidCallback onTap;

  const LanguageOption({
    super.key,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(language),
      ),
    );
  }
}

String getSelectedLanguage(BuildContext context) {
  // Retrieve the current locale from the context
  Locale locale = Localizations.localeOf(context);
  // Map the locale language code to the corresponding language name
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'ar':
      return 'Arabic';
    case 'fr':
      return 'French';
    default:
      return 'Unknown';
  }
}
