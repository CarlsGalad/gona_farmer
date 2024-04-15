import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'conditional.dart';

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
  String? imageURL;
  String? itemPath;
  String? _selectedSellingMethod;

  @override
  void initState() {
    super.initState();
    _fetchPromoItemDetails();
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
      print('Error fetching item details: $error');
    }
  }

  Future<void> _updatePromoDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('promotions')
          .doc(widget.itemId)
          .update({
        'name': _nameController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'farmingYear': int.parse(_farmingYearController.text.trim()),
        'availQuantity': int.parse(_availQuantityController.text.trim()),
        'itemPath': imageURL,
        'categoryId': _selectedCategoryId?.toInt(),
        'subcategoryId': _selectedSubcategory!['id'] as int,
        'sellingMethod': _selectedSellingMethod,
      });
      // Show a success message or navigate back to the previous screen
    } catch (error) {
      print('Error updating item details: $error');
      // Show an error message to the user
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
          'Edit Details',
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
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: FutureBuilder(
                    future: FirebaseStorage.instance
                        .refFromURL(itemPath!)
                        .getDownloadURL(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          width: 200,
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
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
                        return SizedBox(
                          width: 200,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              snapshot.data!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
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
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
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
                decoration: const InputDecoration(
                    labelText: 'Farming year',
                    border: OutlineInputBorder(
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
                  decoration: const InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
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
                  decoration: const InputDecoration(
                      labelText: 'Select Subcategory',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a subcategory';
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
                decoration: const InputDecoration(
                    labelText: 'Available Quantity',
                    border: OutlineInputBorder(
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
                  'Per Pack',
                  'Per Gallon',
                  'Per Head',
                  'Per Kilo',
                  'Per Bag',
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
                decoration: const InputDecoration(
                  labelText: 'Selling Method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a selling method';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  color: Colors.white,
                  width: 150,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final pickedImage = await _pickImage();
                      if (pickedImage != null) {
                        final downloadURL = await _uploadImage(pickedImage);
                        setState(() {
                          imageURL = downloadURL;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Change Image'),
                          ),
                          Spacer(),
                          Icon(
                            Icons.image,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: GestureDetector(
            onTap: _updatePromoDetails,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(15)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Submit Changes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Icon(
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

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('promo_items')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await firebaseStorageRef.putFile(imageFile);
      final downloadURL = await firebaseStorageRef.getDownloadURL();
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
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
      print('Error fetching subcategories: $error');
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Text('Loading...'),
    );
  }
}
