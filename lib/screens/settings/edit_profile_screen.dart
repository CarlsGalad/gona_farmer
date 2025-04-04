import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gona_vendor/models/helper/statesandlg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../provider/farm_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  // Change to ConsumerStatefulWidget
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _ownersNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();

  String? selectedState;
  String? selectedLga;
  bool _isLoading = false;
  // bool _dataLoaded = false; // No longer needed.  Riverpod manages loading state.

  Map<String, List<String>> statesAndLgas = {};

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadStatesAndLgas();
    // _fetchUserData(); // Removed:  We'll fetch with Riverpod in the build method

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
    _farmNameController.dispose();
    _ownersNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadStatesAndLgas() {
    setState(() {
      statesAndLgas = StatesAndLgas.statesAndLgas;
    });
  }

  // Removed _fetchUserData:  Riverpod will handle fetching the data

  Future<void> _submitChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use Riverpod to update
      final updatedProfile = FarmProfile(
        farmName: _farmNameController.text,
        ownersName: _ownersNameController.text,
        mobile: _mobileController.text,
        email: _emailController.text, // Update the email here
        address: _addressController.text,
        imagePath: ref
            .read(currentFarmProfileProvider)
            .value!
            .imagePath, // Keep existing image
        farmState: selectedState!, // Non-null assertion, ensure these are set
        city: selectedLga!, // Non-null assertion
        userId: ref
            .read(currentFarmProfileProvider)
            .value!
            .userId, // Keep existing userId
      );

      await ref.read(updateFarmProfileProvider(updatedProfile).future);

      if (mounted) {
        _showSuccessSnackBar(
            AppLocalizations.of(context)!.profile_updated_successfully);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar("Error updating profile: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmProfileAsync = ref.watch(currentFarmProfileProvider);

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
          AppLocalizations.of(context)!.update_profile,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: farmProfileAsync.when(
        // Use .when to handle loading, data, and error
        data: (farmProfile) {
          if (farmProfile == null) {
            return const Center(
                child: Text("Farm profile not found.")); // Handle null case
          }

          // Pre-fill the form fields *only* if they are empty.  This is important to
          // avoid overwriting user input while typing.
          if (_farmNameController.text.isEmpty) {
            _farmNameController.text = farmProfile.farmName;
          }
          if (_ownersNameController.text.isEmpty) {
            _ownersNameController.text = farmProfile.ownersName;
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = farmProfile.email;
          }
          if (_mobileController.text.isEmpty) {
            _mobileController.text = farmProfile.mobile;
          }
          if (_addressController.text.isEmpty) {
            _addressController.text = farmProfile.address;
          }

          // Set the selected state and LGA.  Use ?? to handle null.
          selectedState ??= farmProfile.farmState;
          selectedLga ??= farmProfile.city;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        context,
                        title: 'Farm Information',
                        icon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _farmNameController,
                        label: AppLocalizations.of(context)!.farm_name,
                        icon: Icons.business,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter farm name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ownersNameController,
                        label: AppLocalizations.of(context)!.farm_owner,
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter owner name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        title: 'Contact Information',
                        icon: Icons.contact_mail_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: AppLocalizations.of(context)!.email_address,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _mobileController,
                        label: AppLocalizations.of(context)!.phone_hint,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        prefixText: '+234 ',
                        hintText: '80 62 XXX XXX',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        title: 'Address Information',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressController,
                        label: AppLocalizations.of(context)!.address,
                        icon: Icons.home_outlined,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildStateDropdown(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLgaDropdown(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildUpdateButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ),
        ), // Show loading indicator
        error: (error, stack) =>
            Center(child: Text('Error: $error')), // Show error
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,
        prefixIcon: Icon(icon, color: AppColors.accentColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search state...",
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          menuProps: const MenuProps(
            backgroundColor: Colors.white,
          ),
        ),
        items: statesAndLgas.keys.toList(),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.state,
            prefixIcon:
                const Icon(Icons.map_outlined, color: AppColors.accentColor),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedState = value;
            selectedLga = null; // Reset LGA when state changes
          });
        },
        selectedItem: selectedState,
      ),
    );
  }

  Widget _buildLgaDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedState != null
              ? AppColors.border
              : AppColors.border.withAlpha(128),
        ),
      ),
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search LGA...",
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          menuProps: const MenuProps(
            backgroundColor: Colors.white,
          ),
        ),
        items: selectedState != null && statesAndLgas.containsKey(selectedState)
            ? statesAndLgas[selectedState]!
            : [],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.city,
            prefixIcon: Icon(
              Icons.location_city_outlined,
              color: selectedState != null
                  ? AppColors.accentColor
                  : AppColors.accentColor.withAlpha(128),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedLga = value;
          });
        },
        selectedItem: selectedLga,
        enabled: selectedState != null,
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.update_profile,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.save_outlined, size: 20),
                ],
              ),
      ),
    );
  }
}
