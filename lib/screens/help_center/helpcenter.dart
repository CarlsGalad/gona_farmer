import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/faq.dart';
import 'chat_help.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  final String hotlineNumber = '07080841335';

  @override
  Widget build(BuildContext context) {
    // Get localized FAQ items
    final List<FAQItem> faqItems = [
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_1,
        answer: AppLocalizations.of(context)!.faq_answer_1,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_2,
        answer: AppLocalizations.of(context)!.faq_answer_2,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_3,
        answer: AppLocalizations.of(context)!.faq_answer_3,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_4,
        answer: AppLocalizations.of(context)!.faq_answer_4,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_5,
        answer: AppLocalizations.of(context)!.faq_answer_5,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_6,
        answer: AppLocalizations.of(context)!.faq_answer_6,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_7,
        answer: AppLocalizations.of(context)!.faq_answer_7,
      ),
      FAQItem(
        question: AppLocalizations.of(context)!.faq_question_8,
        answer: AppLocalizations.of(context)!.faq_answer_8,
      ),
    ];

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
          AppLocalizations.of(context)!.help_center,
          style: GoogleFonts.bebasNeue(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.faq_title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                        AppLocalizations.of(context)!.app_title,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.customer_care,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          const Icon(
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
                              '${AppLocalizations.of(context)!.hotline_number} $hotlineNumber\n'
                              '${AppLocalizations.of(context)!.email_support} support@gona.com',
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
            tooltip: AppLocalizations.of(context)!.live_chat,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.live_chat_24_7,
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
