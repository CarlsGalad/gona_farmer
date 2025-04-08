import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_colors.dart';
import '../../methods/add_item_image_methods.dart';
import '../../models/conditional.dart';
import '../../models/item.dart';
import '../../provider/item_provider.dart'; // For l10n

final imageHelper = ImageHelper();

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends ConsumerState<AddItemScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _farmingYearController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool isLoading = false;
  int? _selectedCategoryId;
  int? _selectedSubcategoryId;
  final List<Map<String, dynamic>> _categories = [{}];
  final List<Map<String, dynamic>> _subcategories = [{}];
  String? _downloadURL;
  String? _selectedSellingMethod;
  String? _userCity;
  String? _farmName;
  String? _userState;
  int? _selectedYear;

  bool uploadingImage = false;
  File? _image;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchCategories();

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
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _farmingYearController.dispose();
    _weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
          await FirebaseFirestore.instance.collection('Category').get();

      setState(() {
        _categories.clear();
        _categories.add({});
        _categories.addAll(categoriesSnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }));
        _selectedCategoryId = null;
        _selectedSubcategoryId = null;
        _subcategories.clear();
        _subcategories.add({});
      });
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(
          AppLocalizations.of(context)?.error ?? 'Error fetching categories');
    }
  }

  Future<void> _fetchSubcategories(int categoryId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> subcategoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('Category')
              .doc(categoryId.toString())
              .collection('Subcategories')
              .get();

      setState(() {
        _subcategories.clear();
        _subcategories.add({});
        _subcategories.addAll(subcategoriesSnapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = int.tryParse(doc.id) ?? 0;
          return data;
        }));
        _selectedSubcategoryId = null;
      });
    } catch (error) {
      _showErrorSnackBar('Error fetching subcategories');
    }
  }

  List<int> _generateYearList() {
    int currentYear = DateTime.now().year;
    return List<int>.generate(10, (index) => currentYear - index);
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)?.add_item ?? 'Add Item',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentColor,
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        context,
                        title: AppLocalizations.of(context)?.add_image ??
                            'Item Image',
                        icon: Icons.image_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildImageUploader(),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        title: 'Item Details',
                        icon: Icons.inventory_2_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _nameController,
                        label: AppLocalizations.of(context)?.name ?? 'Name',
                        icon: Icons.label_outline,
                        maxLength: 30,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.please_enter_name ??
                                'Please enter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _priceController,
                        label: AppLocalizations.of(context)?.price ?? 'Price',
                        icon: Icons.attach_money,
                        prefixText: 'NGN ',
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.please_enter_price ??
                                'Please enter price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: AppLocalizations.of(context)?.description ??
                            'Description',
                        icon: Icons.description_outlined,
                        maxLength: 800,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.please_enter_description ??
                                'Please enter description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        title: 'Category Information',
                        icon: Icons.category_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildYearDropdown(),
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      _buildSubcategoryDropdown(),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        title: 'Inventory Information',
                        icon: Icons.inventory_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _quantityController,
                        label:
                            AppLocalizations.of(context)?.available_quantity ??
                                'Available Quantity',
                        icon: Icons.production_quantity_limits_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                    ?.please_enter_quantity ??
                                'Please enter quantity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _weightController,
                        label: 'Weight',
                        icon: Icons.scale_outlined,
                        keyboardType: TextInputType.number,
                        suffixText: 'KG',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSellingMethodDropdown(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploader() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: uploadingImage
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentColor,
                      ),
                    )
                  : _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: AppColors.accentColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)?.add_image ??
                                  'Tap to add image',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickAndUploadImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add_photo_alternate),
            label: Text(
              _image == null
                  ? AppLocalizations.of(context)?.add_image ?? 'Add Image'
                  : AppLocalizations.of(context)?.change_image ??
                      'Change Image',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final files = await imageHelper.pickImage();
      if (files.isNotEmpty) {
        final croppedFile = await imageHelper.crop(
          file: files.first,
          cropStyle: CropStyle.rectangle,
        );

        if (croppedFile != null) {
          setState(() {
            _image = File(croppedFile.path);
            uploadingImage = true;
          });

          try {
            final downloadURL =
                await imageHelper.uploadImageToFirebaseStorage(croppedFile);

            if (downloadURL != null) {
              setState(() {
                _downloadURL = downloadURL;
                uploadingImage = false;
              });
            } else {    if (!mounted) return;
              _showErrorSnackBar(
             
                  AppLocalizations.of(context)?.error_uploading_image ??
                      'Error uploading image');
              setState(() {
                uploadingImage = false;
              });
            }
          } catch (error) {
            setState(() {
              uploadingImage = false;
            });               if (!mounted) return;
            _showErrorSnackBar(

                AppLocalizations.of(context)?.error_uploading_image ??
                    'Error uploading image');
          }
        }
      }
    } catch (error) {
      _showErrorSnackBar('Error selecting image');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? suffixText,
    int? maxLength,
    int? maxLines,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.accentColor),
          prefixText: prefixText,
          suffixText: suffixText,
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
            borderSide:
                const BorderSide(color: AppColors.accentColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        value: _selectedYear,
        decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context)?.farming_year ?? 'Farming Year',
          prefixIcon:
              const Icon(Icons.calendar_today, color: AppColors.accentColor),
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
            borderSide:
                const BorderSide(color: AppColors.accentColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: _generateYearList().map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedYear = value;
            if (value != null) {
              _farmingYearController.text = value.toString();
            }
          });
        },
        validator: (value) {
          if (value == null) {
            return AppLocalizations.of(context)?.please_enter_farming_year ??
                'Please select farming year';
          }
          return null;
        },
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentColor),
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ConditionalWidget(
        condition: _categories.isNotEmpty,
        fallback: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
          ),
        ),
        child: DropdownButtonFormField<int>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.select_category ??
                'Select Category',
            prefixIcon:
                const Icon(Icons.category, color: AppColors.accentColor),
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
              borderSide:
                  const BorderSide(color: AppColors.accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          items: _categories.map((category) {
            int? id = int.tryParse(category['id']?.toString() ?? '0') ?? 0;
            return DropdownMenuItem<int>(
              value: id,
              child: Text(category['name']?.toString() ?? ''),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null && value != 0) {
              await _fetchSubcategories(value);
              setState(() {
                _selectedCategoryId = value;
              });
            } else {
              setState(() {
                _selectedCategoryId = null;
                _subcategories.clear();
                _subcategories.add({});
                _selectedSubcategoryId = null;
              });
            }
          },
          validator: (value) {
            if (value == null || value == 0) {
              return AppLocalizations.of(context)?.please_select_category ??
                  'Please select a category';
            }
            return null;
          },
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentColor),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubcategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ConditionalWidget(
        condition: _subcategories.isNotEmpty && _selectedCategoryId != null,
        fallback: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)?.select_category ??
                  'Select a category first',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        child: DropdownButtonFormField<int>(
          value: _selectedSubcategoryId,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.select_subcategory ??
                'Select Subcategory',
            prefixIcon: const Icon(Icons.subject, color: AppColors.accentColor),
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
              borderSide:
                  const BorderSide(color: AppColors.accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          items: _subcategories.map((subcategory) {
            int? id = int.tryParse(subcategory['id']?.toString() ?? '0') ?? 0;
            return DropdownMenuItem<int>(
              value: id,
              child: Text(subcategory['name']?.toString() ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSubcategoryId = value;
            });
          },
          validator: (value) {
            if (value == null || value == 0) {
              return AppLocalizations.of(context)?.please_select_subcategory ??
                  'Please select a subcategory';
            }
            return null;
          },
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentColor),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSellingMethodDropdown() {
    final sellingMethods = [
      AppLocalizations.of(context)?.per_pack ?? 'Per Pack',
      AppLocalizations.of(context)?.per_gallon ?? 'Per Gallon',
      AppLocalizations.of(context)?.per_head ?? 'Per Head',
      AppLocalizations.of(context)?.per_kilo ?? 'Per Kilo',
      AppLocalizations.of(context)?.per_bag ?? 'Per Bag',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSellingMethod,
        decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context)?.selling_method ?? 'Selling Method',
          prefixIcon:
              const Icon(Icons.sell_outlined, color: AppColors.accentColor),
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
            borderSide:
                const BorderSide(color: AppColors.accentColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: sellingMethods.map((method) {
          return DropdownMenuItem<String>(
            value: method,
            child: Text(method),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedSellingMethod = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)?.please_select_selling_method ??
                'Please select selling method';
          }
          return null;
        },
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentColor),
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : _validateAndSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accentColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
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
                    AppLocalizations.of(context)?.submit ?? 'Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline, size: 20),
                ],
              ),
      ),
    );
  }

  // Use Riverpod to add the item
  Future<void> _addItem(String? imageURL) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _showErrorSnackBar(AppLocalizations.of(context)?.user_not_logged_in ??
            'User not logged in');
        setState(() => isLoading = false); // Reset loading state
        return;
      }

      try {
        await _fetchUserDetails();

        // Create the Item object.
        final newItem = Item(
          id: '', // Firestore will generate the ID.
          name: _nameController.text.trim(),
          price: int.parse(_priceController.text.trim()),
          description: _descriptionController.text.trim(),
          itemPath: imageURL ?? '', // Use the uploaded image URL
          itemLocation: _userCity ?? 'Unknown',
          state: _userState,
          itemFarm: _farmName ?? 'Unknown',
          categoryId: _selectedCategoryId!,
          farmingYear: _selectedYear!,
          vendorRating: 5.0, //Initial rating
          subcategoryId: _selectedSubcategoryId!,
          availQuantity: int.parse(_quantityController.text.trim()),
          sellingMethod: _selectedSellingMethod,
          weight: double.parse(_weightController.text.trim()),
          isPaused: false,
          farmId: userId,
        ); //
        await ref.read(createItemProvider(newItem).future);

        if (!mounted) return;

        _showSuccessSnackBar(
          AppLocalizations.of(context)?.item_added_successfully ??
              'Item added successfully',
        );

        // Clear form and navigate back
        _clearForm();
        Navigator.pop(context);
      } catch (error) {
        if (!mounted) return;
        _showErrorSnackBar(
          AppLocalizations.of(context)?.error_adding_item(error.toString()) ??
              'Error adding item: ${error.toString()}',
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void _validateAndSubmit() {
    if (_image == null) {
      _showErrorSnackBar('Please add an image');
      return;
    }

    if (_selectedCategoryId == null || _selectedSubcategoryId == null) {
      _showErrorSnackBar(AppLocalizations.of(context)
              ?.please_select_category_and_subcategory ??
          'Please select category and subcategory');
      return;
    }

    if (_formKey.currentState!.validate()) {
      _addItem(_downloadURL); // Pass the download URL
    }
  }

  Future<void> _fetchUserDetails() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch user city from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      // Extract the details from the user data
      setState(() {
        _userState = userSnapshot['state'];
        _userCity = userSnapshot['lga'] ??
            'Unknown'; // Default to 'Unknown' if city is not found
        _farmName = userSnapshot['farmName'] ?? 'Farm Name Not Found';
      });
    }
  }

  // Helper method to clear the form
  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _weightController.clear();
    _farmingYearController.clear();
    setState(() {
      _selectedCategoryId = null;
      _selectedSubcategoryId = null;
      _selectedYear = null;
      _selectedSellingMethod = null;
      _image = null;
      _downloadURL = null;
    });
  }
}
