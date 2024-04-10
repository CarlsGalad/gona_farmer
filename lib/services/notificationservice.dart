import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Create a list to store received notifications
  List<RemoteMessage> notifications = [];

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission if not granted already
    await _firebaseMessaging.requestPermission();

    // Get the installation ID (also known as Instance ID)
    String? installationId = await _firebaseMessaging.getToken();
    print('Installation ID: $installationId');

    // Initialize further settings for push notification
    initPushNotifications();
  }

  // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // If the message is null, do nothing
    if (message == null) return;

    // Add the received message to the list
    notifications.add(message);

    // Navigate to a new screen when the message is tapped
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  // Function to initialize background settings
  Future initPushNotifications() async {
    // Handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // Attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Handling messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }
}
