import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants/app_colors.dart';
import 'change_pass.dart';
import 'edit_profile_screen.dart';
import 'showlang.dart';

class SettingsPrivacyPage extends StatefulWidget {
  const SettingsPrivacyPage({
    super.key,
  });

  @override
  State<SettingsPrivacyPage> createState() => _SettingsPrivacyPageState();
}

class _SettingsPrivacyPageState extends State<SettingsPrivacyPage>
    with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Settings & Privacy',
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                context,
                title: 'Account Settings',
                icon: Icons.person_outline,
              ),
              _buildSettingsCard(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.edit_outlined,
                    title: AppLocalizations.of(context)?.edit_profile ??
                        'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingItem(
                    context,
                    icon: Icons.lock_outline,
                    title: AppLocalizations.of(context)?.change_password ??
                        'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                context,
                title: 'Privacy Settings',
                icon: Icons.security_outlined,
              ),
              _buildSettingsCard(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.policy_outlined,
                    title: AppLocalizations.of(context)?.privacy_policy ??
                        'Privacy Policy',
                    onTap: () => _showPrivacyPolicyDialog(context),
                  ),
                  const Divider(height: 1),
                  _buildSettingItem(
                    context,
                    icon: Icons.description_outlined,
                    title: AppLocalizations.of(context)?.terms_of_service ??
                        'Terms of Service',
                    onTap: () => _showTermsOfServiceDialog(context),
                  ),
                  const Divider(height: 1),
                  _buildSettingItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: AppLocalizations.of(context)?.manage_notifications ??
                        'Manage Notifications',
                    onTap: () => _showNotificationSettingsDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                context,
                title: 'Other Settings',
                icon: Icons.settings_outlined,
              ),
              _buildSettingsCard(
                children: [
                  _buildLanguageSelector(context),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    String getLanguageName(Locale locale) {
      switch (locale.languageCode) {
        case 'en':
          return 'English';
        case 'fr':
          return 'Français';
        case 'ar':
          return 'العربية';
        case 'af':
          return 'Hausa';
        case 'zu':
          return 'Yoruba';
        case 'sw':
          return 'Igbo';
        default:
          return 'Unknown';
      }
    }

    Locale currentLocale = Localizations.localeOf(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const LanguageDialog();
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.language,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.languages ?? 'Languages',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getLanguageName(currentLocale),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppLocalizations.of(context)?.privacy_policy ?? 'Privacy Policy',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.policy_intro ??
                      'Welcome to our Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.info_we_collect ??
                      'Information We Collect',
                  content: AppLocalizations.of(context)?.collect_details ??
                      'We collect personal information that you provide to us.',
                ),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.how_we_use_info ??
                      'How We Use Your Information',
                  content: AppLocalizations.of(context)?.use_details ??
                      'We use the information we collect to provide and improve our services.',
                ),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.sharing_info ??
                      'Sharing Your Information',
                  content: AppLocalizations.of(context)?.sharing_details ??
                      'We do not sell or rent your personal information to third parties.',
                ),
                _buildPolicySection(
                  context,
                  title:
                      AppLocalizations.of(context)?.contact_us ?? 'Contact Us',
                  content: AppLocalizations.of(context)?.contact_details ??
                      'If you have any questions about our Privacy Policy, please contact us.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentColor,
              ),
              child: Text(
                AppLocalizations.of(context)?.close ?? 'Close',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPolicySection(BuildContext context,
      {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
        ),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showTermsOfServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppLocalizations.of(context)?.terms_of_service ??
                'Terms of Service',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.intro ??
                      'Welcome to our Terms of Service',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.section1_title ??
                      'Acceptance of Terms',
                  content: AppLocalizations.of(context)?.section1_content ??
                      'By accessing or using our service, you agree to be bound by these Terms.',
                ),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.section2_title ??
                      'User Accounts',
                  content: AppLocalizations.of(context)?.section2_content ??
                      'You are responsible for maintaining the security of your account.',
                ),
                _buildPolicySection(
                  context,
                  title: AppLocalizations.of(context)?.section3_title ??
                      'Content and Conduct',
                  content: AppLocalizations.of(context)?.section3_content ??
                      'You are responsible for all content you post and your conduct on our service.',
                ),
                _buildPolicySection(
                  context,
                  title:
                      AppLocalizations.of(context)?.contact_us ?? 'Contact Us',
                  content: AppLocalizations.of(context)?.contact_detailst ??
                      'If you have any questions about our Terms, please contact us.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentColor,
              ),
              child: Text(
                AppLocalizations.of(context)?.close ?? 'Close',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const NotificationSettingsDialog();
      },
    );
  }
}

class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  NotificationSettingsDialogState createState() =>
      NotificationSettingsDialogState();
}

class NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final List<String> notifications = [
    'Promotions and Discounts',
    'New Products',
    'Order Updates',
  ];

  Map<String, bool> notificationSettings = {
    'Promotions and Discounts': true,
    'New Products': false,
    'Order Updates': true,
  };

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      debugPrint('FCM Token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        AppLocalizations.of(context)?.get_notified_about ??
            'Get Notified About',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: notifications.map((notification) {
            return SwitchListTile(
              title: Text(
                notification,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              value: notificationSettings[notification] ?? false,
              activeColor: AppColors.accentColor,
              onChanged: (bool value) {
                setState(() {
                  notificationSettings[notification] = value;
                });
                // Subscribe or unsubscribe based on the user's preference
                if (value) {
                  _firebaseMessaging
                      .subscribeToTopic(notification.replaceAll(' ', '_'));
                } else {
                  _firebaseMessaging
                      .unsubscribeFromTopic(notification.replaceAll(' ', '_'));
                }
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentColor,
          ),
          child: Text(
            AppLocalizations.of(context)?.close ?? 'Close',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
