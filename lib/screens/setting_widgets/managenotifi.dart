import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  NotificationSettingState createState() => NotificationSettingState();
}

class NotificationSettingState extends State<NotificationSetting> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<String> notifications = [
    'Promotions and Discounts',
    'New Products',
    'Order Updates',
  ];

  Map<String, bool> notificationSettings = {
    'Promotions and Discounts': true,
    'New Products': false,
    'Order Updates': true,
  };

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });
  }

  Widget _buildNotificationList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: notifications.map((notification) {
          return ListTile(
            title: Text(
              notification,
              style:
                  GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            trailing: Switch(
              activeColor: Colors.green,
              value: notificationSettings[notification] ?? false,
              onChanged: (bool value) {
                setState(() {
                  notificationSettings[notification] = value;
                });
                // Subscribe or unsubscribe based on the user's preference
                if (value) {
                  _firebaseMessaging
                      .subscribeToTopic(notification.replaceAll(' ', '_'));
                } else {
                  _firebaseMessaging
                      .unsubscribeFromTopic(notification.replaceAll(' ', '_'));
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Center(
            child: Text(
              AppLocalizations.of(context)!.get_notified_about,
              style: GoogleFonts.sansita(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content:
              SingleChildScrollView(child: _buildNotificationList(context)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.close,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.notifications,
                color: Colors.green,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.manage_notifications,
              style: GoogleFonts.sansita(fontSize: 18),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _showNotificationSettingsDialog(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
