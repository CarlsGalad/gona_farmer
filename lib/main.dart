import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'models/language_const.dart';
import 'services/auth_service.dart';

import 'services/firestore_service.dart';
import 'screens/notifications.dart';

import 'welcomepages/splashscreen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
       
      ],
      child: GonaVendor(),
    ),
  );
  
}

class GonaVendor extends StatefulWidget {
  const GonaVendor({
    super.key,
  });

  @override
  State<GonaVendor> createState() => _GonaVendorState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _GonaVendorState? state =
        context.findAncestorStateOfType<_GonaVendorState>();
    state?.setLocale(newLocale);
  }
}

class _GonaVendorState extends State<GonaVendor> {
  Locale? _locale = const Locale('en');

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/notification_screen': (context) => const NotificationScreen(),
      },
    );
  }
}
