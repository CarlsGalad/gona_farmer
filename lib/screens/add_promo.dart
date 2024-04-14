import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'conditional.dart';

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
  String? imageURL;
  String? _selectedSellingMethod;
  String? _userCity;
  String? _farmName;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Promotions',
          style: GoogleFonts.aboreto(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _oldPriceController,
              decoration: const InputDecoration(
                  labelText: 'Old Price',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _farmingYearController,
              decoration: const InputDecoration(
                  labelText: 'Farming Year',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
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
            const SizedBox(height: 15.0),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                  labelText: 'Availabe Quantity',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 15.0),
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
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      floatingActionButton: Container(
        color: Colors.white,
        width: 120,
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
                  child: Text('Add Image'),
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
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (_selectedCategoryId != null && _selectedSubcategory != null) {
                _addItem();
              } else {
                // Show error message if no category or subcategory is selected
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a category and subcategory'),
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
                child: const Center(
                    child: Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ))),
          ),
        ),
      ),
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('promotions')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await firebaseStorageRef.putFile(imageFile);
      final downloadURL = await firebaseStorageRef.getDownloadURL();
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
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

  Future<void> _addItem() async {
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
            'itemLocation': _userCity,
            'categoryId': _selectedCategoryId?.toInt(),
            'subcategoryId': _selectedSubcategory!['id'] as int,
            'availQuantity': int.parse(_quantityController.text.trim()),
            'sellingMethod': _selectedSellingMethod,
            'farmingYear': _farmingYearController,
            'farmId': userId,
            'itemPath': imageURL,
            'id': newItemRef.id,
            'farmName': _farmName,
          });
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Item added successfully'),
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
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error adding item: $error'),
            backgroundColor: Colors.red,
          ));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Show error message if user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
