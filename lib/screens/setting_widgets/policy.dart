import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Policy extends StatelessWidget {
  const Policy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.policy,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              Text('Privacy Policy', style: GoogleFonts.sansita(fontSize: 18)),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                              child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.bebasNeue(),
                          )),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                    '''This privacy policy governs the use of Gona Vendor Marketplace'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Information we collect',
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                const Text(
                                    '''We collect information you provide to us directly, such as your business name, contact person's name, email address, and business details when you register for a vendor account.'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'How We Use Your Information',
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                const Text(
                                    '''We use the information we collect to facilitate your use of our services, to communicate with you regarding your vendor account and activities, and to personalize your experience on the platform.'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sharing of Information',
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                const Text(
                                    '''We do not share your personal or business information with third parties unless necessary for the operation of our services or as required by law.'''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Contact Us',
                                    style: GoogleFonts.sansita(fontSize: 20),
                                  ),
                                ),
                                const Text(
                                  ''
                                  'If you have any questions or concerns about our privacy policy, please contact us at yelsgink@gmail.com.'
                                  '',
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.forward,
                      color: Colors.green,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
