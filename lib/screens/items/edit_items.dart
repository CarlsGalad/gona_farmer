import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/app_colors.dart';
import '../../methods/add_item_image_methods.dart';

final imageHelper = ImageHelper();

class EditItemDetailsPage extends StatefulWidget {
  final String itemId;

  const EditItemDetailsPage({super.key, required this.itemId});

  @override
  EditItemDetailsPageState createState() => EditItemDetailsPageState();
}

class EditItemDetailsPageState extends State<EditItemDetailsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _availQuantityController =
      TextEditingController();
  final TextEditingController _farmingYearController = TextEditingController();

  bool isLoading = false;
  int? _selectedCategoryId;
  int? _selectedSubcategoryId;
  final List<Map<String, dynamic>> _categories = [{}];
  final List<Map<String, dynamic>> _subcategories = [{}];

  String? itemPath;
  String? _selectedSellingMethod;
  File? _image;
  bool uploadingImage = false;
  String? _downloadURL;
  int? _selectedYear;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
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
    _availQuantityController.dispose();
    _farmingYearController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchItemDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Items')
          .doc(widget.itemId)
          .get();

      Map<String, dynamic> itemData = snapshot.data() ?? {};

      setState(() {
        _nameController.text = itemData['name'] ?? '';
        _priceController.text = (itemData['price'] ?? 0).toString();
        _descriptionController.text = itemData['description'] ?? '';
        _farmingYearController.text = (itemData['farmingYear'] ?? 0).toString();
        _availQuantityController.text =
            (itemData['availQuantity'] ?? 0).toString();
        itemPath = itemData['itemPath'];
        _selectedCategoryId = itemData['categoryId'];
        _selectedSubcategoryId = itemData['subcategoryId'];
        _selectedSellingMethod = itemData['sellingMethod'];
        _selectedYear = itemData['farmingYear'];

        // If category ID is available, fetch subcategories
        if (_selectedCategoryId != null) {
          _fetchSubcategories(_selectedCategoryId!);
        }
      });
    } catch (error) {if (!mounted) return;
      _showErrorSnackBar( 
          AppLocalizations.of(context)?.error_fetching_item_details(error) ??
              'Error fetching item details');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          data['id'] = int.tryParse(doc.id) ?? 0;
          return data;
        }));
      });
    } catch (error) {
      _showErrorSnackBar('Error fetching categories');
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

  Future<void> _updateItemDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Construct the update data object
      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'availQuantity': int.parse(_availQuantityController.text.trim()),
      };

      // Add optional fields if they are set
      if (_selectedYear != null) {
        updateData['farmingYear'] = _selectedYear;
      }

      if (_selectedCategoryId != null) {
        updateData['categoryId'] = _selectedCategoryId;
      }

      if (_selectedSubcategoryId != null) {
        updateData['subcategoryId'] = _selectedSubcategoryId;
      }

      if (_selectedSellingMethod != null) {
        updateData['sellingMethod'] = _selectedSellingMethod;
      }

      // Check if downloadUrl is not null and not empty
      if (_downloadURL != null && _downloadURL!.isNotEmpty) {
        updateData['itemPath'] = _downloadURL;
      }

      // Update the document in Firestore
      await FirebaseFirestore.instance
          .collection('Items')
          .doc(widget.itemId)
          .update(updateData);

      if (!mounted) return;

      _showSuccessSnackBar(
        AppLocalizations.of(context)?.item_details_updated_successfully ??
            'Item updated successfully',
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      _showErrorSnackBar(
        AppLocalizations.of(context)
                ?.error_updating_item_details(error.toString()) ??
            'Error updating item: ${error.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          AppLocalizations.of(context)?.edit_item_details ??
              'Edit Item Details',
          style: GoogleFonts.abel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading && _nameController.text.isEmpty
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
                        controller: _availQuantityController,
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
                      _buildSellingMethodDropdown(),
                      const SizedBox(height: 40),
                      _buildUpdateButton(),
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
            style: GoogleFonts.abel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
          Stack(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withAlpha(26),
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
                        : itemPath != null
                            ? FutureBuilder(
                                future: Future.value(itemPath),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.accentColor,
                                      ),
                                    );
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 40,
                                          color: AppColors.error,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Error loading image',
                                          style: GoogleFonts.abel(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        snapshot.data!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.accentColor,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                size: 40,
                                                color: AppColors.error,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Error loading image',
                                                style: GoogleFonts.abel(
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
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
                                    style: GoogleFonts.abel(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _pickAndUploadImage,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
              _image != null || itemPath != null
                  ? AppLocalizations.of(context)?.change_image ?? 'Change Image'
                  : AppLocalizations.of(context)?.add_image ?? 'Add Image',
              style: GoogleFonts.abel(
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
            } else { if (!mounted) return;
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
            }); if (!mounted) return;
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
    
    // Check if selected value exists in the items list
    bool valueExists = _selectedCategoryId != null &&
        _categories.any((c) => c['id'] == _selectedCategoryId);

    // If not, reset the selected value
    if (_selectedCategoryId != null && !valueExists) {
      _selectedCategoryId = null;
    }
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
      child: _categories.isNotEmpty
          ? DropdownButtonFormField<int>(
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
                int? id = category['id'] as int?;
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
                    _selectedSubcategoryId =
                        null; // Reset subcategory when category changes
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
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.accentColor),
              isExpanded: true,
              dropdownColor: Colors.white,
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
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
      child: _subcategories.isNotEmpty && _selectedCategoryId != null
          ? DropdownButtonFormField<int>(
              value: _selectedSubcategoryId,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.select_subcategory ??
                    'Select Subcategory',
                prefixIcon:
                    const Icon(Icons.subject, color: AppColors.accentColor),
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
                int? id = subcategory['id'] as int?;
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
                  return AppLocalizations.of(context)
                          ?.please_select_subcategory ??
                      'Please select a subcategory';
                }
                return null;
              },
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.accentColor),
              isExpanded: true,
              dropdownColor: Colors.white,
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select a category first',
                  style: GoogleFonts.abel(
                    color: AppColors.textSecondary,
                  ),
                ),
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

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : _updateItemDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accentColor.withAlpha(156),
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
                    AppLocalizations.of(context)?.update ?? 'Update Item',
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.save_outlined, size: 20),
                ],
              ),
      ),
    );
  }
}
