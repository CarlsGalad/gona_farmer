import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'blog/blog.dart';
import 'homepage.dart';
// import 'loan/loan.dart';

class VenGonaHomePage extends StatefulWidget {
  const VenGonaHomePage({super.key});

  @override
  State<VenGonaHomePage> createState() => _VenGonaHomePageState();
}

class _VenGonaHomePageState extends State<VenGonaHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Homepage(),
    // const Loan(),
    const Blog(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 39, 78, 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 14,
          ),
          child: GNav(
            tabActiveBorder: Border.all(
              color: Color.fromARGB(255, 224, 240, 87),
            ),
            selectedIndex: _selectedIndex,
            color: const Color.fromARGB(255, 87, 87, 87),
            activeColor: Colors.black,
            tabBackgroundColor: const Color.fromARGB(255, 137, 247, 143),
            // gap: 8,
            tabBorderRadius: 10,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            padding: const EdgeInsets.all(14),
            tabBackgroundGradient: const LinearGradient(colors: [
              Color.fromARGB(255, 39, 78, 40),
              Color.fromARGB(255, 101, 128, 57),
              Color.fromARGB(255, 224, 240, 87),
              Color.fromARGB(255, 222, 245, 222),
            ]),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
              ),
              // GButton(
              //   icon: Icons.money_sharp,
              //   text: 'Finance',
              // ),
              GButton(
                icon: Icons.newspaper,
                text: 'News',
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
