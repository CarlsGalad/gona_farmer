import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../local_db.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // Load notifications from the local database
  Future<void> _loadNotifications() async {
    final db = LocalDb();
    final fetchedNotifications = await db.fetchAllNotifications();
    setState(() {
      notifications = fetchedNotifications;
    });
  }

  // Clear all notifications
  void _clearAllNotifications() async {
    final db = LocalDb();
    await db.clearAllNotifications();
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.aboreto(fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAllNotifications,
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('You have no notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['title'] ?? ''),
                  subtitle: Text(notification['body'] ?? ''),
                  trailing:
                      const Icon(Icons.notifications, color: Colors.green),
                );
              },
            ),
    );
  }
}
