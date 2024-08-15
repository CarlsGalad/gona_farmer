import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gona_vendor/welcomepages/changelang.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<String> images = [
    'lib/images/photo.jpg',
    'lib/images/photo2.jpg',
    'lib/images/photo3.jpg',
  ];

  final List<String> notes = [
    'Welcome to Gona Market Africa! Sale and manage your farm produce with ease.',
    'Stay updated with real-time orders and track your deliveries effortlessly.',
    'Boost your sales by managing products, promotions, and monitoring performance.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 60), // Space for the status bar
          Image.asset("lib/images/logo_plain.png", height: 100),
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
          ), // App Logo
          Expanded(
            flex: 2,
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 250,
                enlargeCenterPage: true,
                autoPlay: false,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(image, fit: BoxFit.cover);
                  },
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.green : Colors.grey,
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              notes[_currentIndex],
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Changelang()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.chevron_right, size: 40, color: Colors.black)
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
