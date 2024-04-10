import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final List<RemoteMessage> notifications =
        Provider.of<List<RemoteMessage>>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.bebasNeue(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 250.0, top: 10, bottom: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                Provider.of<List<RemoteMessage>>(context, listen: false)
                    .clear();
                setState(
                    () {}); // Trigger a rebuild of the widget to reflect the changes
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Clear All',
                        style: GoogleFonts.sansita(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.clear_all),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (notifications.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'You have no notifications yet.',
                      style: GoogleFonts.sansita(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final message = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(184, 181, 181, 1),
                            offset: Offset(5, 2),
                            blurRadius: 6.0,
                            spreadRadius: 3.0,
                            blurStyle: BlurStyle.normal,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                            offset: Offset(-6, -2),
                            blurRadius: 5.0,
                            spreadRadius: 3.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: ListTile(
                        title: Text(
                          message.notification?.title ?? '',
                          style: GoogleFonts.sansita(),
                        ),
                        subtitle: Text(
                          message.notification?.body ?? '',
                          textAlign: TextAlign.justify,
                        ),
                        trailing: const Icon(
                          Icons.notifications,
                          color: Colors.green,
                        ),
                        onTap: () {
                          // final FirebaseAuth auth = FirebaseAuth.instance;
                          // final User? currentUser = auth.currentUser;
                          // if (currentUser != null) {
                          //   if (message.data.containsKey('orderId') &&
                          //       message.data['userId'] == currentUser.uid) {
                          //     String orderId = message.data['orderId'];
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) =>
                          //             OrderTrackingScreen(orderId: orderId),
                          //       ),
                          //     );
                          //   } else if (message.data.containsKey('itemId')) {
                          //     String itemId = message.data['itemId'];
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               ItemDetailScreen(itemId: itemId)),
                          //     );
                          //   }
                          // }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
