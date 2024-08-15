import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_page.dart';
import '../services/firebase_options.dart';
import '../services/notificationservice.dart';
import '../services/watcher.dart';
import 'welcome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Perform initialization tasks here
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final FirebaseApi firebaseApi = FirebaseApi();
    await firebaseApi.initPushNotifications();

    final orderItemWatcher = OrderItemWatcher();
    orderItemWatcher.startWatching();

    // Remove the native splash screen
    FlutterNativeSplash.remove();

    // Navigate to the appropriate screen
    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('lib/images/logo_plain.png', height: 150),
            const SizedBox(height: 20),
            const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Gona Market Africa \n',
                    style: GoogleFonts.agbalumo(
                        fontSize: 28.0, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'Vendors',
                    style: GoogleFonts.abel(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Optional: Center-align the text
            ),
           
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
