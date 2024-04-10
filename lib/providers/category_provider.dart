import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/subcategory.dart';
import '../services/firestore_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _category = [];
  bool _isLoading = false;

  List<Category> get categories => _category;
  bool get isLoading => _isLoading;

  StreamSubscription<QuerySnapshot>? _categoriesSubscription;

  // Method to update data from Firestore
  Future<void> updateFromFirestore(FirestoreService firestoreService) async {
    _isLoading = true;
    notifyListeners(); // Notify about loading state change
    try {
      final categoriesCollection =
          FirebaseFirestore.instance.collection('Category');
      final snapshot = await categoriesCollection.get();
      _category = [];
      for (final doc in snapshot.docs) {
        final categoryData = doc.data();
        final subcategoriesSnapshot =
            await doc.reference.collection('Subcategories').get();
        final subcategories = subcategoriesSnapshot.docs
            .map((subcatDoc) => Subcategory.fromMap(subcatDoc.data()))
            .toList();
        _category.add(Category(
          id: categoryData['id'] as int,
          name: categoryData['name'] as String,
          imagePath: categoryData['imagePath'] as String,
          subcategories: subcategories,
        ));
      }
      notifyListeners(); // Notify about categories update
    } catch (error) {
      // Handle errors appropriately
      print('Error updating from Firestore: $error');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify about loading state change (optional)
    }
  }

  // Fetch items and categories
  Future<void> fetchCategories(FirestoreService firestoreService) async {
    // Use updateFromFirestore to fetch categories
    await updateFromFirestore(firestoreService);
  }

  // Dispose of subscriptions (optional)
  @override
  void dispose() {
    _categoriesSubscription?.cancel();
    super.dispose();
    notifyListeners();
  }

  // Define the method to get subcategories by category name
  List<Subcategory> getSubcategoriesByCategoryName(String categoryName) {
    final category = _category.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => Category(
        id: -1,
        name: 'Not Found',
        imagePath: '',
        subcategories: [],
      ),
    );
    return category.subcategories;
  }
}
