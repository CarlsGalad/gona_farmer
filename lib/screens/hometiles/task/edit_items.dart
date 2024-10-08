// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../methods/add_item_image_methods.dart';
import '../../../models/conditional.dart';

final imageHelper = ImageHelper();

class EditItemDetailsPage extends StatefulWidget {
  final String itemId;

  const EditItemDetailsPage({super.key, required this.itemId});

  @override
  EditItemDetailsPageState createState() => EditItemDetailsPageState();
}

class EditItemDetailsPageState extends State<EditItemDetailsPage> {
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
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
    _fetchCategories();
  }

  Future<void> _fetchItemDetails() async {
    try {
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
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updateItemDetails() async {
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
        'categoryId': _selectedCategoryId,
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
          backgroundColor: Colors.green.shade100,
          content: Text(AppLocalizations.of(context)!.item_added_successfully),
        ),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error_adding_item(error)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  List<int> _generateYearList() {
    int currentYear = DateTime.now().year;
    return List<int>.generate(
        10, (index) => currentYear - index); // Last 10 years
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.edit_item_details,
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
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
                      border: Border.all(color: Colors.green.shade200),
                      borderRadius: BorderRadius.circular(10)),
                  height: 200,
                  width: 200,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : FutureBuilder(
                          future: () async {
                            if (itemPath != null) {
                              // ignore: await_only_futures
                              return await FirebaseStorage.instance
                                  .refFromURL(itemPath!);
                            }
                            return null;
                          }(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Reference?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                width: 200,
                                height: 100,
                                child: Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                            color: Colors.green.shade100,
                                            size: 50)),
                              ); // Loading indicator
                            } else if (snapshot.hasError) {
                              return SizedBox(
                                width: 200,
                                height: 100,
                                child: Center(
                                  child:
                                      Text(AppLocalizations.of(context)!.error),
                                ),
                              ); // Error message
                            } else {
                              if (snapshot.data != null) {
                                return FutureBuilder<String>(
                                  future: snapshot.data!.getDownloadURL(),
                                  builder: (context, urlSnapshot) {
                                    if (urlSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: Center(
                                            child: CircularProgressIndicator()),
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            urlSnapshot.data!,
                                            fit: BoxFit
                                                .cover, // Adjust according to your requirement
                                          ),
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
                          }); // Handle error uploading image
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
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 30,
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 8,
                    controller: _priceController,
                    decoration: InputDecoration(
                        prefixText: 'NGN',
                        labelText: AppLocalizations.of(context)!.price,
                        border: InputBorder.none),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 800,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.description,
                        border: InputBorder.none),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                      labelText: AppLocalizations.of(context)!.farming_year,
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
              const SizedBox(
                height: 15,
              ),
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
                      style: const TextStyle(
                          color: Colors
                              .black), // Set the text style for the dropdown menu
                      padding: const EdgeInsets.all(20),
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          alignment: Alignment.center,
                          value: category['id']?.toInt(),
                          child: Text(
                            category['name'] as String? ?? '',
                            style: const TextStyle(
                                color: Colors
                                    .white), // Text color when dropdown is open
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return _categories.map((category) {
                          return Text(
                            category['name'] as String? ?? '',
                            style: const TextStyle(
                                color: Colors
                                    .black), // Text color when dropdown is closed
                          );
                        }).toList();
                      },
                      onChanged: (value) async {
                        if (value != null) {
                          await _fetchSubcategories(value);
                          setState(() {
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
                        labelText:
                            AppLocalizations.of(context)!.select_category,
                        hintStyle: const TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!
                              .please_select_category;
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
                  padding: const EdgeInsets.all(8.0),
                  child: ConditionalWidget(
                    condition: _subcategories.isNotEmpty &&
                        _selectedCategoryId != null,
                    fallback: _buildLoadingIndicator(),
                    child: DropdownButtonFormField<int>(
                      value: _selectedSubcategory != null
                          ? _selectedSubcategory!['id']
                          : null,
                      dropdownColor: Colors.grey[600],
                      style: const TextStyle(
                          color: Colors
                              .black), // Set the text style for the dropdown menu
                      padding: const EdgeInsets.all(20),
                      items: _subcategories.map((subcategory) {
                        return DropdownMenuItem<int>(
                          alignment: Alignment.center,
                          value: subcategory['id'] as int?,
                          child: Text(
                            subcategory['name'] as String? ?? '',
                            style: const TextStyle(
                                color: Colors
                                    .white), // Text color when dropdown is open
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return _subcategories.map((subcategory) {
                          return Text(
                            subcategory['name'] as String? ?? '',
                            style: const TextStyle(
                                color: Colors
                                    .black), // Text color when dropdown is closed
                          );
                        }).toList();
                      },
                      onChanged: (value) {
                        if (value != null) {
                          // Find the selected subcategory from the list of subcategories
                          var selectedSubcategory = _subcategories.firstWhere(
                            (subcategory) => subcategory['id'] == value,
                            orElse: () => <String, dynamic>{},
                          );

                          setState(() {
                            // Update the selected subcategory with the entire map
                            _selectedSubcategory = selectedSubcategory;
                          });
                        } else {
                          setState(() {
                            // If no subcategory is selected, set it to null
                            _selectedSubcategory = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.select_subcategory,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey.shade200,
                elevation: 2,
                shape: const BeveledRectangleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _availQuantityController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.available_quantity,
                        border: InputBorder.none),
                    maxLines: null,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                    onChanged: (value) {
                      setState(() {
                        _selectedSellingMethod = value;
                      });
                    },
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
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.selling_method,
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
            onPressed: _updateItemDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.submit_changes,
                  style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
                const SizedBox(
                  width: 7,
                ),
                const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
              ],
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
    return const Center(
      child: Text('Loading...'),
    );
  }
}
