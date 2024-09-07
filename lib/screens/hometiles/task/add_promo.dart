// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../methods/add_item_image_methods.dart';
import '../../../models/conditional.dart';

final imageHelper = ImageHelper();

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

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
        await FirebaseFirestore.instance.collection('Category').get();

    setState(() {
      _categories.clear();
      _categories.add({});
      _categories.addAll(categoriesSnapshot.docs.map((doc) {
        var data = doc.data();
        // Ensure the id is an integer
        data['id'] = doc.id; // Use the document ID as the category ID
        return data;
      }));
      _selectedCategoryId = null;
      _selectedSubcategoryId = null;
      _subcategories.clear();
      _subcategories.add({});
    });
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
          // Ensure the id is an integer
          data['id'] = int.tryParse(doc.id) ?? 0; // Use 0 as a fallback
          return data;
        }));
        _selectedSubcategoryId = null;
      });
    } catch (error) {
      print("Error fetching subcategories: $error");
      rethrow;
    }
  }

  List<int> _generateYearList() {
    int currentYear = DateTime.now().year;
    return List<int>.generate(
        10, (index) => currentYear - index); // Last 10 years
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
          AppLocalizations.of(context)!.add_promo_item,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey.shade200,
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
                              child: Icon(
                                Icons.image,
                                size: 50,
                              ),
                            ),
                    ),
                    const SizedBox(height: 15.0),
                    // Pick image button for the image to be picked
                    Center(
                      child: MaterialButton(
                        color: Colors.green.shade100,
                        elevation: 18,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () async {
                          final files = await imageHelper.pickImage();
                          if (files.isNotEmpty) {
                            final croppedFile = await imageHelper.crop(
                                file: files.first,
                                cropStyle: CropStyle.rectangle);
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
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .error_uploading_image),
                                    ),
                                  );
                                }
                              } catch (error) {
                                setState(() {
                                  uploadingImage = false;
                                });
                                if (!mounted) return;
                                // Handle error uploading image
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .error_adding_item(error)),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text(AppLocalizations.of(context)!.add_image),
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
                    const SizedBox(height: 10.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 30,
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.name,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_name;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 8,
                          controller: _priceController,
                          decoration: InputDecoration(
                              prefixText: 'NGN',
                              labelText: AppLocalizations.of(context)!.price,
                              border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_price;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 8,
                          controller: _oldPriceController,
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.old_price,
                              border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_price;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 500,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.description,
                              border: InputBorder.none),
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_description;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          value: _selectedYear,
                          borderRadius: BorderRadius.circular(5),
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.grey[700],
                          // Text color for selected year when closed
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.farming_year,
                            border: InputBorder.none,
                          ),
                          items: _generateYearList().map((year) {
                            return DropdownMenuItem<int>(
                              alignment: Alignment.center,
                              value: year,
                              child: Text(
                                year.toString(),
                                style: const TextStyle(
                                    color: Colors
                                        .white), // Text color for year when open
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (context) {
                            return _generateYearList().map((year) {
                              return Text(
                                year.toString(),
                                style: const TextStyle(
                                    color: Colors
                                        .black), // Text color when the dropdown is closed
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value;
                              _farmingYearController.text = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return AppLocalizations.of(context)!
                                  .please_enter_farming_year;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConditionalWidget(
                          condition: _categories.isNotEmpty,
                          fallback: _buildLoadingIndicator(),
                          child: DropdownButtonFormField<int>(
                            borderRadius: BorderRadius.circular(5),
                            value: _selectedCategoryId,
                            dropdownColor: Colors.grey[600],
                            style: const TextStyle(color: Colors.black),
                            padding: const EdgeInsets.all(20),
                            items: _categories.map((category) {
                              int? id =
                                  int.tryParse(category['id'].toString()) ?? 0;
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: id,
                                child: Text(
                                  category['name']?.toString() ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
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
                                  _subcategories.add({
                                    'id': 0,
                                    'name': 'Select a Subcategory'
                                  });
                                  _selectedSubcategoryId = null;
                                });
                              }
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return _categories.map((category) {
                                return Text(
                                  category['name'] as String? ?? '',
                                  style: const TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Select a Category',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value == 0) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    // Subcategory Dropdown
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConditionalWidget(
                          condition: _subcategories.isNotEmpty &&
                              _selectedCategoryId != null,
                          fallback: _buildLoadingIndicator(),
                          child: DropdownButtonFormField<int>(
                            value: _selectedSubcategoryId,
                            dropdownColor: Colors.grey[600],
                            style: const TextStyle(color: Colors.black),
                            padding: const EdgeInsets.all(20),
                            items: _subcategories.map((subcategory) {
                              int? id =
                                  int.tryParse(subcategory['id'].toString()) ??
                                      0;
                              return DropdownMenuItem<int>(
                                value: id,
                                child: Text(
                                  subcategory['name']?.toString() ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubcategoryId = value;
                              });
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return _subcategories.map((subcategory) {
                                return Text(
                                  subcategory['name'] as String? ?? '',
                                  style: const TextStyle(color: Colors.black),
                                );
                              }).toList();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Select a Subcategory',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value == 0) {
                                return 'Please select a subcategory';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .available_quantity,
                              border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_quantity;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                              labelText: 'Weight', border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter item weight';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      color: Colors.grey.shade200,
                      elevation: 2,
                      shape: const BeveledRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.grey[700],
                          value: _selectedSellingMethod,
                          items: [
                            AppLocalizations.of(context)!.per_pack,
                            AppLocalizations.of(context)!.per_gallon,
                            AppLocalizations.of(context)!.per_head,
                            AppLocalizations.of(context)!.per_kilo,
                            AppLocalizations.of(context)!.per_bag,
                          ].map((method) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: method,
                              child: Text(
                                method,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return [
                              AppLocalizations.of(context)!.per_pack,
                              AppLocalizations.of(context)!.per_gallon,
                              AppLocalizations.of(context)!.per_head,
                              AppLocalizations.of(context)!.per_kilo,
                              AppLocalizations.of(context)!.per_bag,
                            ].map((method) {
                              return Text(
                                method,
                                style: const TextStyle(
                                    color: Colors
                                        .black), // Text color when dropdown is closed
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedSellingMethod = value;
                            });
                          },
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.selling_method,
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_select_selling_method;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: MaterialButton(
            color: Colors.green.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            minWidth: 100,
            elevation: 18,
            onPressed: () {
              if (_selectedCategoryId != null &&
                  _selectedSubcategoryId != null) {
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 60.0, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.submit,
                style:
                    GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserDetails() async {
    // Get the current user's UID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Fetch user city from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('farms')
              .doc(userId)
              .get();

      // Extract the deails from the user data
      setState(() {
        _userState = userSnapshot['state'];
        _userCity = userSnapshot['lga'] ??
            'Unknown'; // Default to 'Unknown' if city is not found
        _farmName = userSnapshot['farmName'] ?? 'Farm Name Not Found';
      });
    }
  }

  Future<void> _addItem(String? imageURL) async {
    print("Starting _addItem method");
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      print("User ID: $userId");
      if (userId != null) {
        try {
          await _fetchUserDetails();

          DocumentReference newItemRef =
              FirebaseFirestore.instance.collection('Items').doc();

          // Safely convert categoryId and subcategoryId to integers
          int? categoryId = _selectedCategoryId is int
              ? _selectedCategoryId
              : int.tryParse(_selectedCategoryId.toString());
          int? subcategoryId = _selectedSubcategoryId is int
              ? _selectedSubcategoryId
              : int.tryParse(_selectedSubcategoryId.toString());

          if (categoryId == null || subcategoryId == null) {
            throw Exception('Invalid category or subcategory ID');
          }

          await newItemRef.set({
            'name': _nameController.text.trim(),
            'price': int.parse(_priceController.text.trim()),
            'oldPrice': int.parse(_oldPriceController.text.trim()),
            'description': _descriptionController.text.trim(),
            'itemLocation': _userCity,
            'categoryId': categoryId,
            'subcategoryId': subcategoryId,
            'availQuantity': int.parse(_quantityController.text.trim()),
            'sellingMethod': _selectedSellingMethod,
            'farmingYear': _selectedYear,
            'farmId': userId,
            'itemPath': _downloadURL ?? imageURL,
            'id': newItemRef.id,
            'state': _userState,
            'weight': int.parse(_weightController.text.trim()),
            'promotionFarm': _farmName!,
            'label': 'promo',
          });

          print("Document set successfully");

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.item_added_successfully),
            backgroundColor: Colors.green.shade100,
          ));

          _clearForm();
          Navigator.pop(context);
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .error_adding_item(error.toString())),
            backgroundColor: Colors.red,
          ));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.user_not_logged_in),
          backgroundColor: Colors.red,
        ));
      }
    } else {}
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _oldPriceController.clear();
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
