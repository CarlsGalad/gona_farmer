import 'package:flutter/material.dart';

import '../help_center/helpcenter.dart';

import '../notifications.dart';
import '../profile/profilescreen.dart';
import '../settings.dart';

class DropdownMenuWidget extends StatelessWidget {
  const DropdownMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.menu,
          size: 40,
        ),
        onSelected: (String result) {
          // Handle menu item selection here
          // You can navigate to different screens based on the selected item
          switch (result) {
            case 'Profile':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              ); // Navigate to Profile screen
              break;
            case 'Notifications':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
              // Navigate to Notifications screen
              break;

            case 'Help Centre':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpCenterScreen(),
                ),
              ); // Navigate to Help Centre screen
              break;
            case 'Settings':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPrivacyPage(),
                ),
              ); // Navigate to Help Centre screen
              break;
            case 'About':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpCenterScreen(),
                ),
              );
              // Navigate to About screen
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Profile',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Profile'),
                    Spacer(),
                    Icon(Icons.person),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Notifications',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Notifications'),
                    Spacer(),
                    Icon(Icons.notifications),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Settings',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Settings'),
                    Spacer(),
                    Icon(Icons.settings),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'About',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('About'),
                    Spacer(),
                    Icon(Icons.info),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
