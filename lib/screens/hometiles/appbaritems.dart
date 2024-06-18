import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          color: Colors.white,
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
                  builder: (context) => const HelpCenterScreen(),
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
                  builder: (context) => const HelpCenterScreen(),
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.profile),
                    const Spacer(),
                    const Icon(Icons.person),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Notifications',
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.notifications),
                    const Spacer(),
                    const Icon(Icons.notifications),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Settings',
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.settings),
                    const Spacer(),
                    const Icon(Icons.settings),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'About',
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.about),
                    const Spacer(),
                    const Icon(Icons.info),
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
