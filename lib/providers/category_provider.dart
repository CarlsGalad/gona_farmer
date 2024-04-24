// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/category.dart';
// import '../models/subcategory.dart';
// import '../services/firestore_service.dart';

// class CategoryProvider with ChangeNotifier {
//   List<Category> _categories = [];
//   bool _isLoading = false;

//   List<Category> get categories => _categories;
//   bool get isLoading => _isLoading;

//   // Method to update data from Firestore
//   Future<void> updateFromFirestore(FirestoreService firestoreService) async {
//     _isLoading = true;
//     notifyListeners(); // Notify about loading state change
//     try {
//       final categoriesCollection =
//           FirebaseFirestore.instance.collection('Categories');
//       final querySnapshot = await categoriesCollection.get();
//       _categories = querySnapshot.docs.map((doc) {
//         final categoryData = doc.data();
//         final subcategories =
//             (categoryData['subcategories'] as List<dynamic>).map((subcatData) {
//           return Subcategory(
//             id: subcatData['id'] as int,
//             name: subcatData['name'] as String,
//           );
//         }).toList();
//         return Category(
//           id: categoryData['id'] as int,
//           name: categoryData['name'] as String,
//           imagePath: categoryData['imagePath'] as String,
//           subcategories: subcategories,
//         );
//       }).toList();
//       notifyListeners(); // Notify about categories update
//     } catch (error) {
//       // Handle errors appropriately
//       print('Error updating from Firestore: $error');
//     } finally {
//       _isLoading = false;
//       notifyListeners(); // Notify about loading state change (optional)
//     }
//   }

//   // Fetch categories
//   Future<void> fetchCategories(FirestoreService firestoreService) async {
//     // Use updateFromFirestore to fetch categories
//     await updateFromFirestore(firestoreService);
//   }

//   // Dispose of subscriptions (optional)
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // Define a method to get subcategories by category name
//   List<Subcategory> getSubcategoriesByCategoryName(String categoryName) {
//     final category = _categories.firstWhere(
//       (category) => category.name == categoryName,
//       orElse: () => Category(
//         id: -1,
//         name: 'Not Found',
//         imagePath: '',
//         subcategories: [],
//       ),
//     );
//     return category.subcategories;
//   }
// }
