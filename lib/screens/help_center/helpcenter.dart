import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'chat_help.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({
    super.key,
  });

  final String hotlineNumber = '07080841335';
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What types of products can I sell on the app?',
      answer:
          'You can sell a wide range of farming products and supplies, including farm produce, livestock, farming equipment, pesticides, herbicides, fertilizers, and other agricultural-related items.',
    ),
    FAQItem(
      question: 'How do I create a seller account?',
      answer:
          "To create a seller account, go to the app's registration page and select the option to register as a seller. Fill in the required information, including your contact details and business information. Once your account is verified, you can start listing your products for sale.",
    ),
    FAQItem(
      question: 'Is there a fee for selling on the app?',
      answer:
          'Yes, there may be a nominal fee or commission charged for each successful sale made through the app. The fee structure may vary depending on the type of product and the pricing plan chosen by the seller.',
    ),
    FAQItem(
      question: 'How do I list my products for sale?',
      answer:
          "To list your products for sale, log in to your seller account and navigate to the dashboard. From there, you can select the option to add a new product listing. Fill in the details of your product, including its name, description, price, and images. Once your listing is complete, it will be visible to potential buyers on the app.",
    ),
    FAQItem(
      question: 'What marketing tools are available to promote my products?',
      answer:
          'The app provides various marketing tools and features to help sellers promote their products, including featured listings, sponsored ads, and promotional campaigns. Sellers can also leverage social media integration and email marketing to reach a wider audience.',
    ),
    FAQItem(
      question: 'How do I manage orders and fulfillments?',
      answer:
          'You can manage orders and fulfillments through the seller dashboard. When a customer places an order, you will receive a notification, and the order details will be visible in your dashboard. You can then process the order, pack the items, and arrange for shipping or pickup.',
    ),
    FAQItem(
      question: 'What support is available for sellers?',
      answer:
          "The app provides dedicated seller support to assist with any questions or issues you may encounter. You can contact seller support through the app's help center or by reaching out to our customer service team via email or phone.",
    ),
    FAQItem(
      question: 'Can I sell internationally through the app?',
      answer:
          'Currently, the app only supports selling within the country. International selling capabilities may be added in the future, depending on market demand and regulatory considerations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        centerTitle: true,
        title: Text(
          'Help Center',
          style: GoogleFonts.bebasNeue(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'FAQ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
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
                      child: ExpansionTile(
                        title: Text(
                          faqItems[index].question,
                          style: GoogleFonts.sansita(fontSize: 18),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              faqItems[index].answer,
                              style: const TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Center(
                      child: Text(
                        'Gona Market Place By Carlson Galad',
                        style: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Customer Care',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            Icons.headset_mic,
                            color: Colors.redAccent,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Hotline: $hotlineNumber\n'
                              ' Email: surport@gona.com',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 160.0,
        ),
        child: SizedBox(
          width: 150,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveChatScreen(),
                  ));
            },
            backgroundColor: Colors.white,
            tooltip: 'Live Chat',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Live chat 24/7',
                    style: GoogleFonts.abel(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chat,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
