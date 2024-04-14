import 'package:flutter/material.dart';

class DropdownMenuWidget extends StatelessWidget {
  const DropdownMenuWidget({Key? key}) : super(key: key);

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
              // Navigate to Profile screen
              break;
            case 'Notifications':
              // Navigate to Notifications screen
              break;
            case 'Messages':
              // Navigate to Messages screen
              break;
            case 'Help Centre':
              // Navigate to Help Centre screen
              break;
            case 'About':
              // Navigate to About screen
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Profile',
            child: Text('Profile'),
          ),
          const PopupMenuItem<String>(
            value: 'Notifications',
            child: Text('Notifications'),
          ),
          const PopupMenuItem<String>(
            value: 'Messages',
            child: Text('Messages'),
          ),
          const PopupMenuItem<String>(
            value: 'Help Centre',
            child: Text('Help Centre'),
          ),
          const PopupMenuItem<String>(
            value: 'About',
            child: Text('About'),
          ),
        ],
      ),
    );
  }
}
