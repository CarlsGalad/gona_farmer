
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../models/faq.dart';
import 'chat.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  final String hotlineNumber = '07080841335';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.help_center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: _buildFAQList(context, faqItems),
              ),
              const SizedBox(height: 16),
              _buildFooter(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildChatButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            size: 48,
            color: AppColors.accentColor,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.faq_title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers to common questions',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(BuildContext context, List<FAQItem> faqItems) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: faqItems.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: AppColors.border.withAlpha(128),
          ),
          itemBuilder: (context, index) {
            return _buildFAQItem(context, faqItems[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, FAQItem faqItem) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.primaryLight,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          faqItem.question,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        iconColor: AppColors.accentColor,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faqItem.answer,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.app_title,
            style: GoogleFonts.aboreto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.email_support,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactButton(
                context,
                icon: Icons.email_outlined,
                label: 'Email',
                onTap: () {
                  // Handle email contact
                },
              ),
              const SizedBox(width: 16),
              _buildContactButton(
                context,
                icon: Icons.phone_outlined,
                label: 'Call',
                onTap: () {
                  // Handle phone call
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.accentColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatListScreen(),
            ),
          );
        },
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.headset_mic),
      ),
    );
  }
}
