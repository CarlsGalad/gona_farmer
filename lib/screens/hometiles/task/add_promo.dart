// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../methods/add_promo_image.dart';
import '../../../models/conditional.dart';

final imageHelper = ImageHelperPromo();

class AddPromoScreen extends StatefulWidget {
  const AddPromoScreen({super.key});

  @override
  AddPromoScreenState createState() => AddPromoScreenState();
}

class AddPromoScreenState extends State<AddPromoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _farmingYearController = TextEditingController();

  bool isLoading = false;
  int? _selectedCategoryId;
  Map<String, dynamic>? _selectedSubcategory;
  final List<Map<String, dynamic>> _categories = [{}];
  final List<Map<String, dynamic>> _subcategories = [{}];
  String? _downloadURL;
  String? _selectedSellingMethod;
  String? _userCity;
  String? _farmName;

  bool uploadingImage = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    // Fetch categories from Firestore
    QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        await FirebaseFirestore.instance.collection('Category').get();

    setState(() {
      _categories.clear();
      _categories.add({});
      _categories.addAll(categoriesSnapshot.docs.map((doc) => doc.data()));
      // Clear the selected category and subcategory
      _selectedCategoryId = null;
      _selectedSubcategory = null;
      _subcategories.clear();
      _subcategories.add({});
    });
  }

  Future<void> _fetchSubcategories(int categoryId) async {
    try {
      // Fetch subcategories from Firestore for the given category ID
      QuerySnapshot<Map<String, dynamic>> subcategoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('Category')
              .doc(categoryId.toString()) // Convert ID to String
              .collection('Subcategories')
              .get();

      setState(() {
        _subcategories.clear();
        _subcategories.add({});
        _subcategories
            .addAll(subcategoriesSnapshot.docs.map((doc) => doc.data()));
        // Clear the selected subcategory
        _selectedSubcategory = null;
      });
    } catch (error) {
      rethrow;
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Text('Loading...'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.add_promotions,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15)),
              width: 200,
              height: 200,
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Icon(Icons.image),
                    ),
            ),
            const SizedBox(height: 15.0),
            // Pick image button for the image to be picked
            GestureDetector(
              onTap: () async {
                final files = await imageHelper.pickImage();
                if (files.isNotEmpty) {
                  final croppedFile = await imageHelper.crop(
                      file: files.first, cropStyle: CropStyle.rectangle);
                  if (croppedFile != null) {
                    setState(() {
                      _image = File(croppedFile.path);
                    });

                    // Upload the cropped image
                    setState(() {
                      uploadingImage = true;
                    });
                    try {
                      final downloadURL = await imageHelper
                          .uploadImageToFirebaseStorage(croppedFile);
                      setState(() {
                        uploadingImage = false;
                      });

                      if (downloadURL != null) {
                        // Store the download URL in a state variable
                        setState(() {
                          _downloadURL = downloadURL;
                        });
                      } else {
                        // Handle error uploading image
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .error_uploading_image),
                          ),
                        );
                      }
                    } catch (error) {
                      setState(() {
                        uploadingImage = false;
                      });

                      // Handle error uploading image

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .error_uploading_image_with_error(error)),
                        ),
                      );
                    }
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                width: 100,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(AppLocalizations.of(context)!.add_image),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_name;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.price,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_price;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _oldPriceController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.old_price,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_price;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_description;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _farmingYearController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.farming_year,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .please_enter_farming_year;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            ConditionalWidget(
              condition: _categories.isNotEmpty,
              fallback: _buildLoadingIndicator(),
              child: DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id']?.toInt(),
                    child: Text(category['name'] as String? ?? ''),
                  );
                }).toList(),
                onChanged: (value) async {
                  if (value != null) {
                    // Perform asynchronous work outside of setState
                    await _fetchSubcategories(value);
                    setState(() {
                      // Update the state synchronously after the asynchronous work is done
                      _selectedCategoryId = value;
                    });
                  } else {
                    setState(() {
                      _selectedCategoryId = null;
                      _subcategories.clear();
                      _subcategories.add({});
                      _selectedSubcategory = null;
                    });
                  }
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.select_category,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!.please_select_category;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15.0),
            ConditionalWidget(
              condition:
                  _subcategories.isNotEmpty && _selectedCategoryId != null,
              fallback: _buildLoadingIndicator(),
              // Only show subcategories dropdown and loading indicator if subcategories exist and a category is selected
              child: DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedSubcategory,
                items: _subcategories.map((subcategory) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: subcategory,
                    child: Text(subcategory['name'] as String? ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategory = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.select_subcategory,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .please_select_subcategory;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.available_quantity,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_quantity;
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            DropdownButtonFormField<String>(
              value: _selectedSellingMethod,
              items: [
                AppLocalizations.of(context)!.per_pack,
                AppLocalizations.of(context)!.per_gallon,
                AppLocalizations.of(context)!.per_head,
                AppLocalizations.of(context)!.per_kilo,
                AppLocalizations.of(context)!.per_bag,
              ].map((method) {
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.selling_method,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .please_select_selling_method;
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (_selectedCategoryId != null && _selectedSubcategory != null) {
                _addItem(_downloadURL);
              } else {
                // Show error message if no category or subcategory is selected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .please_select_category_and_subcategory),
                  ),
                );
              }
            },
            child: Container(
                width: 250,
                height: 60,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 137, 247, 143),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context)!.submit,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ))),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserCity() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch user city from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      // Extract the city from the user data
      setState(() {
        _userCity = userSnapshot['city'] ??
            'Unknown'; // Default to 'Unknown' if city is not found
      });
    }
  }

  Future<void> _fetchFarmName() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch farm name from Firestore for the current user's farm
      DocumentSnapshot farmSnapshot = await FirebaseFirestore.instance
          .collection('farms')
          .doc(userId)
          .get();

      // Get the farm name from the document snapshot
      setState(() {
        _farmName = farmSnapshot['farmName'] ?? 'Farm Name Not Found';
      });
    }
  }

  Future<void> _addItem(String? imageURL) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Get the current user's UID from Firebase Authentication
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        try {
          // get the farmer city or location
          await _fetchUserCity();

          // get the farm name
          await _fetchFarmName();
          // Get a reference to a new document with an auto-generated ID
          DocumentReference newItemRef =
              FirebaseFirestore.instance.collection('promotions').doc();
          await newItemRef.set({
            'name': _nameController.text.trim(),
            'price': int.parse(
              _priceController.text.trim(),
            ),
            'oldPrice': int.parse(
              _oldPriceController.text.trim(),
            ),
            'description': _descriptionController.text.trim(),
            'promotionLocation': _userCity,
            'categoryId': _selectedCategoryId?.toInt(),
            'subcategoryId': _selectedSubcategory!['id'] as int,
            'availQuantity': int.parse(_quantityController.text.trim()),
            'sellingMethod': _selectedSellingMethod,
            'farmingYear': _farmingYearController,
            'farmId': userId,
            'imagePath': _downloadURL,
            'id': newItemRef.id,
            'promotionFarm': _farmName,
          });

          if (!mounted) return;
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.item_added_successfully),
            backgroundColor: Colors.green,
          ));
          // Clear text controllers
          _nameController.clear();
          _priceController.clear();
          _descriptionController.clear();

          _quantityController.clear();

          // Reset dropdowns
          setState(() {
            _selectedCategoryId = _categories.first as int?;
            _selectedSubcategory = _subcategories.first;
          });
        } catch (error) {
          if (!mounted) return;
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.error_adding_item(error)),
            backgroundColor: Colors.red,
          ));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Show error message if user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.user_not_logged_in),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
