import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/language_const.dart';
import 'services/auth_service.dart';
import 'services/firebase_options.dart';
import 'providers/item_provider.dart';
import 'services/firestore_service.dart';
import 'services/watcher.dart';
import 'services/notificationservice.dart';
import 'screens/notifications.dart';
import 'services/auth_page.dart';
import 'welcomepages/welcome.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // instance of shared preferences
  final prefs = await SharedPreferences.getInstance();
  // check if its users first time
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

//initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

// watch for changes in order collection
  final orderItemWatcher = OrderItemWatcher();
  orderItemWatcher.startWatching();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<List<RemoteMessage>>.value(value: firebaseApi.notifications),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        ChangeNotifierProxyProvider<FirestoreService, ItemProvider>(
          create: (_) => ItemProvider(),
          update: (_, firestoreService, itemProvider) {
            if (itemProvider != null) {
              itemProvider.updateFromFirestore(firestoreService);
              return itemProvider;
            } else {
              final newItemProvider = ItemProvider();
              newItemProvider.updateFromFirestore(firestoreService);
              return newItemProvider;
            }
          },
        ),
      ],
      child: GonaVendor(
        isFirstTime: isFirstTime,
      ),
    ),
  );
}

class GonaVendor extends StatefulWidget {
  final bool isFirstTime;
  const GonaVendor({super.key, required this.isFirstTime});

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
  Widget build(context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      //

      locale: _locale,
      debugShowCheckedModeBanner: false,
      home: widget.isFirstTime ? const WelcomePage() : const AuthPage(),
      routes: {
        '/notification_screen': (context) => const NotificationScreen(),
      },
    );
  }
}
