import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'models/language_const.dart';
import 'services/auth_service.dart';
import 'services/firebase_options.dart';
import 'providers/item_provider.dart';
import 'services/firestore_service.dart';
import 'services/watcher.dart';
import 'services/notificationservice.dart';
import 'screens/notifications.dart';
import 'services/auth_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

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
      child: const GonaVendor(),
    ),
  );
}

class GonaVendor extends StatefulWidget {
  const GonaVendor({super.key});

  @override
  State<GonaVendor> createState() => _GonaVendorState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _GonaVendorState? state =
        context.findAncestorStateOfType<_GonaVendorState>();
    state?.setLocale(newLocale);
  }
}

class _GonaVendorState extends State<GonaVendor> {
  Locale? _locale;

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
      home: const AuthPage(),
      routes: {
        '/notification_screen': (context) => const NotificationScreen(),
      },
    );
  }
}
