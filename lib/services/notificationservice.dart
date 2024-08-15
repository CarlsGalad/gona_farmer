import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../local_db.dart';
import '../main.dart';

class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final LocalDb _localDb = LocalDb(); // Create an instance of LocalDb

  FirebaseApi() {
    _initializeLocalNotifications();
  }

  // Initialize local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show local notification and save to database
  void _showLocalNotification(Map<String, dynamic> orderData) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      orderData['status'] == 'prepared' ? 'Order Prepared' : 'Order Delivered',
      'Item: ${orderData['item_name']}\nOrder ID: ${orderData['order_id']}',
      notificationDetails,
    );

    // Save notification to the local database
    await _localDb.insertNotification({
      'title': orderData['status'] == 'prepared'
          ? 'You have a New Order'
          : 'Order Delivered',
      'body':
          'Item: ${orderData['item_name']}\nOrder ID: ${orderData['order_id']}',
    });
  }

  // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final orderData = message.data;

    if (orderData['status'] == 'prepared' ||
        orderData['status'] == 'delivered') {
      _showLocalNotification(orderData);
    }

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  // Initialize Firebase Messaging
  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }
}
