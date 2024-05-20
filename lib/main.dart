import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gona_vendor/models/language_const.dart';

import 'package:provider/provider.dart';

// import 'providers/category_provider.dart';
import 'providers/item_provider.dart';
import 'screens/notifications.dart';
import 'services/watcher.dart';
import 'services/auth_page.dart';
import 'services/auth_service.dart';

import 'services/firebase_options.dart';
import 'services/firestore_service.dart';
import 'services/notificationservice.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase before running the app
  final FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  // Start watching for order item changes
  final orderItemWatcher = OrderItemWatcher();
  orderItemWatcher.startWatching();

  runApp(
    MultiProvider(
      providers: [
        // Provide the authentication service
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

        // Add the provider for notifications here
        Provider<List<RemoteMessage>>.value(value: firebaseApi.notifications),

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
      ],
      child: const GonaVendor(),
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
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //  AppLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/'
            '/notification_screen': (context) => const NotificationScreen(),
      },
    );
  }
}
