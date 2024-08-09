import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../methods/add_promo_image.dart';
import '../../../models/conditional.dart';

final imageHelper = ImageHelperPromo();

class EditPromoDetailsPage extends StatefulWidget {
  final String itemId;

  const EditPromoDetailsPage({super.key, required this.itemId});

  @override
  EditPromoDetailsPageState createState() => EditPromoDetailsPageState();
}

class EditPromoDetailsPageState extends State<EditPromoDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _availQuantityController =
      TextEditingController();
  final TextEditingController _farmingYearController = TextEditingController();

  bool isLoading = false;
  int? _selectedCategoryId;
  Map<String, dynamic>? _selectedSubcategory;
  final List<Map<String, dynamic>> _categories = [{}];
  final List<Map<String, dynamic>> _subcategories = [{}];

  String? itemPath;
  String? _selectedSellingMethod;
  File? _image;
  bool uploadingImage = false;
  String? _downloadURL;

  @override
  void initState() {
    super.initState();
    _fetchPromoItemDetails();
    _fetchCategories();
  }

  Future<void> _fetchPromoItemDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('promotions')
          .doc(widget.itemId)
          .get();

      Map<String, dynamic> promoData = snapshot.data() ?? {};

      setState(() {
        _nameController.text = promoData['name'] ?? '';
        _priceController.text = (promoData['price'] ?? 0).toString();
        _descriptionController.text = promoData['description'] ?? '';
        _farmingYearController.text =
            (promoData['farmingYear'] ?? 0).toString();
        _availQuantityController.text =
            (promoData['availQuantity'] ?? 0).toString();
        itemPath = promoData['itemPath'];
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updatePromoDetails() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      // Construct the update data object
      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'farmingYear': int.parse(_farmingYearController.text.trim()),
        'availQuantity': int.parse(_availQuantityController.text.trim()),
        'categoryId': _selectedCategoryId?.toInt(),
        'subcategoryId': _selectedSubcategory!['id'] as int,
        'sellingMethod': _selectedSellingMethod,
      };

      // Check if downloadUrl is not null and not empty
      if (_downloadURL != null && _downloadURL!.isNotEmpty) {
        updateData['itemPath'] = _downloadURL;
      }

      // Update the document in Firestore
      await FirebaseFirestore.instance
          .collection(
              'Items') // Make sure the collection name matches your Firestore structure
          .doc(widget.itemId)
          .update(updateData);

      if (!mounted) return;
      // Show a success message or navigate back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.item_details_updated_successfully),
        ),
      );
    } catch (error) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .error_updating_item_details_with_error(error)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
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
          AppLocalizations.of(context)!.edit_discount_details,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  height: 200,
                  width: 200,
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : FutureBuilder(
                          future: () async {
                            if (itemPath != null) {
                              return await FirebaseStorage.instance
                                  .refFromURL(itemPath!);
                            }
                            return null;
                          }(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Reference?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 200,
                                height: 100,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ); // Loading indicator
                            } else if (snapshot.hasError) {
                              return const SizedBox(
                                width: 200,
                                height: 100,
                                child: Center(
                                  child: Text('Error!'),
                                ),
                              ); // Error message
                            } else {
                              if (snapshot.data != null) {
                                return FutureBuilder<String>(
                                  future: snapshot.data!.getDownloadURL(),
                                  builder: (context, urlSnapshot) {
                                    if (urlSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: Center(
                                            child: LoadingAnimationWidget
                                                .staggeredDotsWave(
                                                    color:
                                                        Colors.green.shade100,
                                                    size: 50)),
                                      ); // Loading indicator for download URL
                                    } else if (urlSnapshot.hasError) {
                                      return SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .error_fetching_download_url),
                                        ),
                                      ); // Error message for download URL
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 200,
                                        height: 200,
                                        child: Image.network(
                                          urlSnapshot.data!,
                                          fit: BoxFit
                                              .cover, // Adjust according to your requirement
                                        ),
                                      );
                                    }
                                  },
                                );
                              } else {
                                return SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .invalid_url),
                                  ),
                                ); // Error message for invalid URL
                              }
                            }
                          },
                        ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Pick image button for the image to be picked
              Center(
                child: MaterialButton(
                  color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  minWidth: 100,
                  elevation: 18,
                  onPressed: () async {
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
                            if (!context.mounted) return;
                            // Handle error uploading image
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green.shade100,
                                content: Text(AppLocalizations.of(context)!
                                    .error_uploading_image),
                              ),
                            );
                          }
                        } catch (error) {
                          setState(() {
                            uploadingImage = false;
                          }); // Handle error uploading image
                          if (!context.mounted) return;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(AppLocalizations.of(context)!.change_image),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.price,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                maxLines: null,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _farmingYearController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.farming_year,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                maxLines: null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
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
                      return AppLocalizations.of(context)!
                          .please_select_category;
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
                      labelText:
                          AppLocalizations.of(context)!.select_subcategory,
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
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _availQuantityController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.available_quantity,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                maxLines: null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),
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
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: MaterialButton(
            color: Colors.green.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            minWidth: 100,
            elevation: 18,
            onPressed: _updatePromoDetails,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.submit_changes,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    return Center(
      child: Text(AppLocalizations.of(context)!.loading),
    );
  }
}
