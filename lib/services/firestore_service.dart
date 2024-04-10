import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.data() ??
          {}; // Return user data, or an empty map if data is null
    } catch (e) {
      // Handle errors
      rethrow;
      // Re-throw the exception if needed
    }
  }

  //fetch items from firebase
  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('Items').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  // Method to fetch categories from Firestore
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('Category').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // Handle errors
      rethrow;
      // Re-throw the exception if needed
    }
  }
}
