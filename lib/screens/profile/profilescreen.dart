import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../provider/farm_provider.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // Removed _imageFile:  Riverpod provider will manage state.
  bool _isUploading = false;
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

  Future<void> _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _isUploading = true; // Show loading indicator.
      });

      try {
        // Use the Riverpod provider to upload the image.
        ref.read(uploadFarmImageProvider(
            imageFile: File(pickedFile.path).readAsBytesSync()));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.profile_updated_successfully),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.update_failed),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false; // Hide loading indicator.
          });
        }
      }
    }
  }

  void signUserOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout?',
          style: GoogleFonts.abel(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.abel(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmProfileAsync =
        ref.watch(currentFarmProfileProvider); // Use the provider

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
          AppLocalizations.of(context)!.profile,
          style: GoogleFonts.abel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
            ),
          ),
        ],
      ),
      body: farmProfileAsync.when(
        // Use .when to handle loading, error, and data states
        data: (farmProfile) {
          if (farmProfile == null) {
            return _buildErrorState(AppLocalizations.of(context)!
                .user_data_not_found); // No farm profile found.
          }
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildProfileContent(farmProfile),
          );
        },
        loading: () => _buildLoadingIndicator(),
        error: (error, stack) =>
            _buildErrorState('Error: $error'), // Handle errors
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.accentColor,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.error.withAlpha(182),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.abel(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(FarmProfile farmProfile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildProfileHeader(farmProfile),
          _buildProfileBody(farmProfile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(FarmProfile farmProfile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight,
            AppColors.scaffoldBackground,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryLight,
                  child: _isUploading
                      ? const CircularProgressIndicator(
                          color: AppColors.accentColor,
                          strokeWidth: 3,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: farmProfile.imagePath.isNotEmpty
                              ? Image.network(
                                  farmProfile.imagePath,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _uploadImage, // Simplified onTap
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _capitalizeEachWord(farmProfile.farmName),
            style: GoogleFonts.abel(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            _capitalizeEachWord(farmProfile.ownersName),
            style: GoogleFonts.abel(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileBody(FarmProfile farmProfile) {
    // No User needed
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: AppLocalizations.of(context)!.personal_info,
            icon: Icons.person_outline,
            child: PersonalInfoContent(farmProfile: farmProfile),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: AppLocalizations.of(context)!.address,
            icon: Icons.location_on_outlined,
            child: AddressInfoContent(farmProfile: farmProfile),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Account Detail',
            icon: Icons.account_balance_outlined,
            child: AccountDetailContent(
                farmProfile: farmProfile), // Pass Farm Profile
          ),
          const SizedBox(height: 16),
          _buildLogoutButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.abel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: signUserOut,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sign out',
                  style: GoogleFonts.abel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return '';
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}

class PersonalInfoContent extends StatelessWidget {
  final FarmProfile farmProfile;

  const PersonalInfoContent({super.key, required this.farmProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            title: AppLocalizations.of(context)!.email,
            value: farmProfile.email,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            title: AppLocalizations.of(context)!.phone_number,
            value: farmProfile.mobile,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.person_outline,
            title: AppLocalizations.of(context)!.farm_owner,
            value: farmProfile.ownersName,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.abel(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : '-',
                style: GoogleFonts.abel(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddressInfoContent extends StatelessWidget {
  final FarmProfile farmProfile;

  const AddressInfoContent({super.key, required this.farmProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.home_outlined,
            title: AppLocalizations.of(context)!.address,
            value: farmProfile.address,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.location_city_outlined,
            title: AppLocalizations.of(context)!.city,
            value: farmProfile.city,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.map_outlined,
            title: AppLocalizations.of(context)!.state,
            value: farmProfile.farmState,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.abel(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : '-',
                style: GoogleFonts.abel(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccountDetailContent extends ConsumerStatefulWidget {
  final FarmProfile farmProfile;

  const AccountDetailContent({super.key, required this.farmProfile});

  @override
  AccountDetailContentState createState() => AccountDetailContentState();
}

class AccountDetailContentState extends ConsumerState<AccountDetailContent> {
  // No _accountDetails: Use the Riverpod provider.

  @override
  void initState() {
    super.initState();
  }

  // No _fetchAccountDetails

  void _showUpdateDialog(Map<String, dynamic> accountDetails) {
    showDialog(
      context: context,
      builder: (context) => UpdateAccountDialog(
        farmProfile: widget.farmProfile, // Pass farmProfile
        accountDetails: accountDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use accountDetailsProvider directly:
    final accountDetailsAsync =
        ref.watch(accountDetailsProvider(widget.farmProfile.userId));

    return accountDetailsAsync.when(
      data: (accountDetails) {
        bool hasAccountDetails =
            accountDetails['accountName']?.isNotEmpty == true ||
                accountDetails['bankName']?.isNotEmpty == true ||
                accountDetails['accountNumber']?.isNotEmpty == true;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (hasAccountDetails) ...[
                _buildAccountInfo(accountDetails),
              ] else ...[
                _buildNoAccountInfo(),
              ],
              const SizedBox(height: 16),
              _buildUpdateButton(accountDetails),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.error_fetching_details,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(Map<String, dynamic> accountDetails) {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.person_outline,
          title: AppLocalizations.of(context)!.account_name,
          value: accountDetails['accountName'] ?? '-',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.account_balance_outlined,
          title: AppLocalizations.of(context)!.bank_name,
          value: accountDetails['bankName'] ?? '-',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.credit_card_outlined,
          title: AppLocalizations.of(context)!.account_number,
          value: accountDetails['accountNumber'] ?? '-',
        ),
      ],
    );
  }

  Widget _buildNoAccountInfo() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: AppColors.textSecondary.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!
                .userNotFound, // Consider a more descriptive message
            style: GoogleFonts.abel(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(Map<String, dynamic> accountDetails) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showUpdateDialog(accountDetails),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.update_account_details,
          style: GoogleFonts.abel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.abel(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.abel(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UpdateAccountDialog extends ConsumerStatefulWidget {
  // Use ConsumerStatefulWidget
  final FarmProfile farmProfile; // Now takes farmProfile
  final Map<String, dynamic> accountDetails;

  const UpdateAccountDialog({
    super.key,
    required this.farmProfile, // Update here
    required this.accountDetails,
  });

  @override
  UpdateAccountDialogState createState() => UpdateAccountDialogState();
}

class UpdateAccountDialogState extends ConsumerState<UpdateAccountDialog> {
  late TextEditingController _accountNameController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  bool _isUpdating = false; // For loading indicator in the dialog.

  @override
  void initState() {
    super.initState();
    _accountNameController =
        TextEditingController(text: widget.accountDetails['accountName'] ?? '');
    _bankNameController =
        TextEditingController(text: widget.accountDetails['bankName'] ?? '');
    _accountNumberController = TextEditingController(
        text: widget.accountDetails['accountNumber'] ?? '');
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _updateAccountDetails() async {
    setState(() {
      _isUpdating = true; // Show loading indicator.
    });

    try {
      // Use the Riverpod provider for updating:
      await ref.read(updateAccountDetailsProvider(
              accountName: _accountNameController.text.trim(),
              bankName: _bankNameController.text.trim(),
              accountNumber: _accountNumberController.text.trim())
          .future);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .update_failed), // Correct success message
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .save_details_failed), // Correct error message
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false; // Hide loading indicator.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.update_account_details,
        style: GoogleFonts.abel(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _accountNameController,
              label: AppLocalizations.of(context)!.account_name,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bankNameController,
              label: AppLocalizations.of(context)!.bank_name,
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _accountNumberController,
              label: AppLocalizations.of(context)!.account_number,
              icon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUpdating ? null : () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isUpdating ? null : _updateAccountDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isUpdating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(AppLocalizations.of(context)!.update),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accentColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
