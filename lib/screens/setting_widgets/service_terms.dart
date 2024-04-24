import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceTerms extends StatelessWidget {
  const ServiceTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
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
                  Icons.book,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              Text('Terms of Service',
                  style: GoogleFonts.sansita(fontSize: 18)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Terms of Service',
                          style: GoogleFonts.bebasNeue(fontSize: 20),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '''Welcome to the Gona Vendor Marketplace! By using our app, you agree to comply with and be bound by the following terms and conditions''',
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '1. Purchases and Deliveries',
                                  style: GoogleFonts.sansita(fontSize: 15),
                                ),
                              ),
                              const Text(
                                '''- Consumers place orders through our platform, and payment is processed immediately. We operate an escrow system where funds are held until delivery confirmation.
- Vendors are responsible for timely and accurate order fulfillment, ensuring that products are delivered in good condition and meet customer expectations.
- Payment is released to vendors upon successful delivery confirmation by the customer. We accept various payment methods, including credit/debit cards, mobile wallets, and cash on delivery where available.
- Vendors must adhere to the return and refund policy outlined in our terms of service, providing refunds or exchanges as required.''',
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '2. Vendor Responsibilities',
                                  style: GoogleFonts.sansita(fontSize: 15),
                                ),
                              ),
                              const Text(
                                '''- Vendors are responsible for accurately listing their products and ensuring that product descriptions are detailed and informative.
- It's important to promptly update product availability and inventory to prevent overselling or stockouts.
- Vendors should respond promptly to customer inquiries and feedback to maintain a positive reputation and customer satisfaction.''',
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '''3. Liability and Dispute Resolution''',
                                  style: GoogleFonts.sansita(fontSize: 15),
                                ),
                              ),
                              const Text(
                                '''- While we strive to ensure the quality and accuracy of product listings, we cannot guarantee the availability or quality of products offered by vendors.
- Disputes between vendors and customers should be resolved amicably and in accordance with our dispute resolution process outlined in our terms of service.
- Our platform reserves the right to suspend or terminate vendor accounts that violate our terms of service or engage in fraudulent or deceptive practices.''',
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Contact Us',
                                  style: GoogleFonts.sansita(fontSize: 15),
                                ),
                              ),
                              const Text(
                                '''If you have any questions or concerns about our terms of service, please contact us at support@gona.com.''',
                                textAlign: TextAlign.justify,
                              )
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
                  // Navigate to Privacy Policy screen
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    CupertinoIcons.forward,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
