import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'conditional.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  int? _selectedCategoryId;
  Map<String, dynamic>? _selectedSubcategory;
  final List<Map<String, dynamic>> _categories = [{}];
  final List<Map<String, dynamic>> _subcategories = [{}];

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
      print('Error fetching subcategories: $error');
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                decoration: const InputDecoration(labelText: 'Select Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20.0),
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
                decoration:
                    const InputDecoration(labelText: 'Select Subcategory'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a subcategory';
                  }
                  return null;
                },
              ), // Show loading indicator only when fetching subcategories for a selected category
            ),
            const SizedBox(height: 20.0),
            // Add a text field for item name
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Item Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the item';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            // Add a text field for item description (optional)
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Item Description (Optional)',
              ),
              maxLines: null, // Allows for multi-line input
            ),
            const SizedBox(height: 20.0),
            // Add a button to submit the form
            ElevatedButton(
              onPressed: () {
                if (_selectedCategoryId != null &&
                    _selectedSubcategory != null) {
                  // Submit form data (consider implementing form validation and error handling)
                  // For example:
                  int categoryId = _selectedCategoryId!;
                  String subcategoryName =
                      _selectedSubcategory!['name'] as String;
                  // Submit data to Firestore or your backend service (modify based on your logic)
                } else {
                  // Show error message if no category or subcategory is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category and subcategory'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
