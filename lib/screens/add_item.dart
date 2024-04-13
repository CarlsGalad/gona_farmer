import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  Map<String, dynamic>? _selectedCategory;
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
        await FirebaseFirestore.instance.collection('categories').get();

    setState(() {
      _categories.clear();
      _categories.add({});
      _categories.addAll(categoriesSnapshot.docs.map((doc) => doc.data()));
      // Clear the selected category and subcategory
      _selectedCategory = null;
      _selectedSubcategory = null;
      // Clear the subcategories list
      _subcategories.clear();
      _subcategories.add({});
    });
  }

  Future<void> _fetchSubcategories(String categoryId) async {
    try {
      // Fetch subcategories from Firestore for the given category ID
      QuerySnapshot<Map<String, dynamic>> subcategoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('categories')
              .doc(categoryId)
              .collection('subcategories')
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
            DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: category,
                  child: Text(category['name'] as String? ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  if (value != null) {
                    // Extract the category ID from the selected value
                    String categoryId = value['id'] as String;
                    // Call function to fetch subcategories for the selected category
                    _fetchSubcategories(categoryId);
                  } else {
                    // Clear the subcategories list and selected subcategory
                    _subcategories.clear();
                    _subcategories.add({});
                    _selectedSubcategory = null;
                  }
                });
              },
              decoration: const InputDecoration(labelText: 'Select Category'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<Map<String, dynamic>>(
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
            ),
            // Add other form fields as needed
          ],
        ),
      ),
    );
  }
}
